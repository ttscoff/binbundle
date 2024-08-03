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

    ##
    ## Create a new Jewel object
    ##
    ## @param      gem_name  [String] The gem name
    ## @param      bins      [Array|String] The executables
    ## @param      version   [String] The semantic version
    ##
    ## @return     [Jewel] new jewel object
    ##
    def initialize(gem_name = '', bins = [], version = nil)
      @gem = gem_name
      @bins = if bins.is_a?(String)
                bins.split(/ *, */)
              else
                bins
              end
      @version = version
      @include_version = true
    end

    ##
    ## Output Jewel as command
    ##
    ## @return     [String] Command representation of the object.
    ##
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

    ##
    ## Output a Binfile-ready version of the Jewel
    ##
    ## @return     [String] Binfile string
    ##
    def gem_command
      ver = @include_version ? " -v '#{@version}'" : ''
      ui = @user_install ? '--user-install ' : ''
      sudo = @sudo ? 'sudo ' : ''
      "# Executables: #{@bins.join(', ')}\n#{to_s}"
    end
  end
end
