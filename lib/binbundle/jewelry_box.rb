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

    def initialize(include_version: true, sudo: false, user_install: false, contents: nil)
      @include_version = include_version
      @sudo = sudo
      @user_install = user_install

      super()

      if contents
        init_from_contents(contents)
      end

    end

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

    def gem_for_bin(bin)
      m = select { |gem| gem.bins&.include?(bin) }.first
      return "Gem for #{bin} not found" unless m

      m.gem
    end

    def bins_for_gem(gem)
      m = select { |g| g.gem == gem }.first
      return "Gem #{gem} not found" unless m

      m.bins ? m.bins.join(', ') : 'Missing info'
    end

    def to_s
      map do |j|
        j.to_s
      end.join("\n")
    end
  end
end
