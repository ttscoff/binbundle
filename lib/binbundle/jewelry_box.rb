# frozen_string_literal: true

module Binbundle
  # String helpers
  class JewelryBox < Array
    # Include version info in output
    attr_writer :include_version

    # Include sudo
    attr_writer :sudo

    # Include --user-install
    attr_writer :user_install

    ##
    ## Create a new JewelryBox object
    ##
    ## @param      include_version  [Boolean] include version
    ## @param      sudo             [Boolean] include sudo
    ## @param      user_install     [Boolean] include --user-install
    ## @param      contents         [String] The contents to parse
    ##
    ## @return [JewelryBox] New JewelryBox object
    def initialize(include_version: true, sudo: false, user_install: false, contents: nil)
      @include_version = include_version
      @sudo = sudo
      @user_install = user_install

      super()

      return unless contents

      init_from_contents(contents)
    end

    ##
    ## Read and parse a Binfile for gems to install
    ##
    ## @param      contents  [String] The contents
    ##
    def init_from_contents(contents)
      rx = /(?mix)(?:\#\sExecutables:\s(?<bins>[\S\s,]+?)\n)?(?:sudo\s)?gem\sinstall
            \s(?:--user-install\s)?
            (?<gem>\S+)(?:\s(?:-v|--version)\s'(?<version>[0-9.]+)')?/
      contents.to_enum(:scan, rx).map { Regexp.last_match }.each do |m|
        g = Jewel.new(m['gem'], m['bins'], m['version'])
        g.include_version = @include_version
        g.sudo = @sudo
        g.user_install = @user_install
        push(g)
      end
    end

    ##
    ## Find a gem for a given binary name
    ##
    ## @param      bin   [String] The bin to search for
    ##
    ## @return     [String] Associated gem name
    ##
    def gem_for_bin(bin)
      m = select { |gem| gem.bins&.include?(bin) }.first
      return "Gem for #{bin} not found" unless m

      m.gem
    end

    ##
    ## List binaries for a given gem name
    ##
    ## @param      gem   [String] The gem name to search for
    ##
    def bins_for_gem(gem)
      m = select { |g| g.gem == gem }.first
      return "Gem #{gem} not found" unless m

      m.bins ? m.bins.join(', ') : 'Missing info'
    end

    ##
    ## Output a Binfile version of the JewelryBox
    ##
    ## @return     [String] String representation of the object.
    ##
    def to_s
      map(&:to_s).join("\n")
    end
  end
end
