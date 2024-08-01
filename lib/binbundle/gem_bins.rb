module Binbundle
  # Main class
  class GemBins
    def local_gems
      Gem::Specification.sort_by { |g| [g.name.downcase, g.version] }.group_by(&:name)
    end

    def initialize(options = {})
      @include_version = options[:include_version] || false
      @user_install = options[:user_install]
      @sudo = options[:sudo]
      @dry_run = options[:dry_run]
      @file = File.expand_path(options[:file])

      @local_gems = local_gems.delete_if { |_, specs| specs.delete_if { |spec| spec.executables.empty? }.empty? }
    end

    def install
      unless File.exist?(@file)
        puts "File #{@file} not found"
        Process.exit 1
      end

      res = Prompt.yn("Install gems from #{File.basename(@file)}", default_response: true)

      Process.exit 0 unless res

      puts "Installing gems from #{@file}"

      contents = IO.read(@file)
      gem_list = GemList.new(contents, include_version: @include_version)
      lines = if @sudo
                gem_list.sudo
              elsif @user_install
                gem_list.user_install
              else
                gem_list.normal_install
              end

      if @dry_run
        puts lines.join("\n")
        Process.exit 0
      end

      `sudo echo -n ''` if @sudo

      @errors = []

      lines.each do |cmd|
        spinner = TTY::Spinner.new("[:spinner] #{cmd} ...", hide_cursor: true, format: :dots_2)

        spinner.auto_spin

        output = `/bin/bash -c '#{cmd}' 2>&1`
        result = $?.success?

        if result
          spinner.success
          spinner.stop
        else
          spinner.error
          spinner.stop
          @errors << output
        end
      end

      unless @errors.empty?
        puts "ERRORS:"
        puts @errors.join("\n")
      end
    end

    def gem_command(gem, attrs)
      ver = @include_version ? " -v '#{attrs[:version]}'" : ''
      ui = @user_install ? '--user-install ' : ''
      sudo = @sudo ? 'sudo ' : ''
      "# Executables: #{attrs[:bins].join(', ')}\n#{sudo}gem install #{ui}#{gem}#{ver}"
    end

    def generate
      gems_with_bins = {}

      @local_gems.each do |g, specs|
        versions = specs.map { |spec| spec.version.to_s }
        bins = specs.map(&:executables)
        gems_with_bins[g] = { version: versions.max, bins: bins.sort.uniq }
      end

      output = gems_with_bins.map { |gem, attrs| gem_command(gem, attrs) }.join("\n\n")

      if @dry_run
        puts output
      else
        write_file(output)
      end
    end

    def write_file(output)
      if File.exist?(@file)
        res = Prompt.yn("#{@file} already exists, overwrite", default_response: false)
        Process.exit 1 unless res
      end

      File.open(@file, 'w') do |f|
        f.puts '#!/bin/bash'
        f.puts
        f.puts output
      end

      puts "Wrote list to #{@file}"

      res = Prompt.yn('Make file executable', default_response: true)

      return unless res

      FileUtils.chmod 0o777, @file
      puts 'Made file executable'
    end
  end
end
