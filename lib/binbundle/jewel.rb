# frozen_string_literal: true

module Binbundle
  # String helpers
  class Jewel
    # Include version info in output
    attr_writer :include_version

    # Include sudo
    attr_writer :sudo

    # Include --user-install
    attr_writer :user_install

    # Binaries
    attr_reader :bins

    # Gem name
    attr_reader :gem

    def initialize(gem_name, bins, version)
      @gem = gem_name
      @bins = if bins.is_a?(String)
                bins.split(/ *, */)
              else
                bins
              end
      @version = version
      @include_version = true
    end

    def to_s
      version = @include_version && @version ? " -v '#{@version}'" : ''
      if @sudo
        "sudo gem install #{@gem}#{version}"
      elsif @user_install
        "gem install --user-install #{@gem}#{version}"
      else
        "gem install #{@gem}#{version}"
      end
    end

    def gem_command
      ver = @include_version ? " -v '#{@version}'" : ''
      ui = @user_install ? '--user-install ' : ''
      sudo = @sudo ? 'sudo ' : ''
      "# Executables: #{@bins.join(', ')}\n#{sudo}gem install #{ui}#{@gem}#{ver}"
    end
  end
end
