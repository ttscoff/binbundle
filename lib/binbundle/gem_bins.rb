# frozen_string_literal: true

module Binbundle
  # Main class
  class GemBins
    # Get gem for bin :gem_for
    attr_writer :gem_for

    # Get bins for gem :bin_for
    attr_writer :bin_for

    # Set options (for testing)
    attr_writer :file, :dry_run

    ##
    ## Create a new GemBins object
    ##
    ## @param      options  The options
    ## @option options [Boolean] :include_version Include version number in output
    ## @option options [Boolean] :sudo Include sudo in output
    ## @option options [Boolean] :user_install Include --user-install in output
    ## @option options [Boolean] :dry_run Output to STDOUT
    ## @option options [String] :file File to parse
    ## @option options [Boolean] :local Work from local gems instead of Binfile
    ##
    def initialize(options = {})
      @include_version = options[:include_version] || false
      @user_install = options[:user_install]
      @sudo = options[:sudo]
      @dry_run = options[:dry_run]
      @file = File.expand_path(options[:file])
    end

    ##
    ## Retrieve info (bin_for or gem_for)
    ##
    ## @param      options  The options
    ## @option options [Boolean] :local Work from local gems instead of Binfile
    ## @option options [String] :gem_for Find gem for this binary
    ## @option options [String] :bin_for Find bins for this gem
    ##
    ## @return [String] resulting gem or bins
    def info(options)
      unless File.exist?(@file) || options[:local]
        puts "File #{@file} not found"
        Process.exit 1
      end

      contents = if options[:local]
                   bins_to_s
                 else
                   IO.read(@file)
                 end

      gem_list = JewelryBox.new(contents: contents,
                                include_version: @include_version,
                                sudo: @sudo,
                                user_install: @user_install)
      if options[:gem_for]
        gem_list.gem_for_bin(options[:gem_for])
      elsif options[:bin_for]
        gem_list.bins_for_gem(options[:bin_for])
      end
    end

    ##
    ## Install all gems in Binfile
    ##
    def install
      unless File.exist?(@file)
        puts "File #{@file} not found"
        Process.exit 1
      end

      contents = IO.read(@file)
      lines = JewelryBox.new(contents: contents, include_version: @include_version, sudo: @sudo,
                             user_install: @user_install)

      total = lines.count
      successes = 0
      failures = 0
      res = Prompt.yn("Install #{total} gems from #{File.basename(@file)}", default_response: true)
      Process.exit 0 unless res

      puts "Installing gems from #{@file}"

      if @dry_run
        puts lines
        Process.exit 0
      end

      `sudo echo -n ''` if @sudo

      @errors = []

      lines.each do |cmd|
        # rubocop:disable Naming/VariableNumber
        spinner = TTY::Spinner.new("[:spinner] #{cmd} ...", hide_cursor: true, format: :dots_2)
        # rubocop:enable Naming/VariableNumber

        spinner.auto_spin

        output = `/bin/bash -c '#{cmd}' 2>&1`
        result = $CHILD_STATUS.success?

        if result
          successes += 1
          spinner.success
          spinner.stop
        else
          failures += 1
          spinner.error
          spinner.stop
          @errors << output
        end
      end

      puts "Total #{total}, installed: #{successes}, #{failures} errors."

      return if @errors.empty?

      puts 'ERRORS:'
      puts @errors.join("\n")
      Process.exit 1
    end

    ##
    ## Output all gems as Binfile format
    ##
    ## @return     [String] Binfile format
    ##
    def bins_to_s
      local_gems.map(&:gem_command).join("\n\n")
    end

    ##
    ## Output or write Binfile
    ##
    def generate
      output = bins_to_s

      if @dry_run
        puts output
      else
        write_file(output)
      end
    end

    ##
    ## Writes to Binfile
    ##
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

    private

    ##
    ## Find local gems and group by name
    ##
    ## @return     [Array] array of local gems as Hashes
    ##
    def local_gems
      gems_with_bins = JewelryBox.new(include_version: @include_version, sudo: @sudo, user_install: @user_install)

      all = Gem::Specification.sort_by { |g| [g.name.downcase, g.version] }.group_by(&:name)
      all.delete_if { |_, specs| specs.delete_if { |spec| spec.executables.empty? }.empty? }
      all.each do |g, specs|
        gems_with_bins << Jewel.new(g, specs.last.executables.sort.uniq, specs.last.version.to_s)
      end

      gems_with_bins
    end
  end
end
