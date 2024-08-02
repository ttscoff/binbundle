# frozen_string_literal: true

module Binbundle
  # String helpers
  class GemList
    attr_writer :include_version

    def initialize(contents, include_version: true)
      @contents = contents
      @include_version = include_version
    end

    def gem_list
      return @gem_list if @gem_list

      rx = /(?mix)(?:\#\sExecutables:\s(?<bins>[\S\s,]+?)\n)?(?:sudo\s)?gem\sinstall
            \s(?:--user-install\s)?
            (?<gem>\S+)(?:\s(?:-v|--version)\s'(?<version>[0-9.]+)')?/
      @gem_list = []
      @contents.to_enum(:scan, rx).map { Regexp.last_match }.each do |m|
        @gem_list << { gem: m['gem'], bins: m['bins']&.split(', '), version: m['version'] }
      end
      @gem_list
    end

    def sudo
      gem_list.map do |gem|
        version = @include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "sudo gem install #{gem[:gem]}#{version}"
      end
    end

    def user_install
      gem_list.map do |gem|
        version = @include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "gem install --user-install #{gem[:gem]}#{version}"
      end
    end

    def normal_install
      gem_list.map do |gem|
        version = @include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "gem install #{gem[:gem]}#{version}"
      end
    end

    def gem_for_bin(bin)
      m = gem_list.select { |gem| gem[:bins].include?(bin) }.first
      return "Gem for #{bin} not found" unless m

      m[:gem]
    end

    def bins_for_gem(gem)
      m = gem_list.select { |g| g[:gem] == gem }.first
      return "Gem #{gem} not found" unless m

      m[:bins] ? m[:bins].join("\n") : 'Missing info'
    end
  end
end
