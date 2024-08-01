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
      lines = if @sudo
                contents.sudo(include_version: @include_version)
              elsif @user_install
                contents.user_install(include_version: @include_version)
              else
                contents.normal_install(include_version: @include_version)
              end

      if @dry_run
        puts lines.join("\n")
        Process.exit 0
      end

      `sudo echo -n ''` if @sudo

      lines.each do |cmd|
        print cmd

        output = `/bin/bash -c '#{cmd}' 2>&1`
        result = $?.success?

        if result
          puts ' ✅'
        else
          puts ' 😥'
          puts output
        end
      end
    end

    def generate
      gems_with_bins = {}

      @local_gems.map do |g, specs|
        versions = specs.map { |spec| spec.version.to_s }
        bins = specs.map(&:executables)
        gems_with_bins[g] = { version: versions.max, bins: bins.sort.uniq }
      end

      lines = []

      gems_with_bins.each do |k, v|
        ver = @include_version ? " -v '#{v[:version]}'" : ''
        ui = @user_install ? '--user-install ' : ''
        sudo = @sudo ? 'sudo ' : ''
        lines << "# Executables: #{v[:bins].join(', ')}\n#{sudo}gem install #{ui}#{k}#{ver}"
      end

      output = lines.join("\n\n")

      if @dry_run
        puts output
      else
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
        if res
          FileUtils.chmod 0o777, @file
          puts 'Made file executable'
        end
      end
    end
  end
end
