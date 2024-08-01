# frozen_string_literal: true

module Binbundle
  # String helpers
  class ::String
    def gem_list
      split("\n").delete_if { |line| line.strip.empty? || line =~ /^#/ }.each_with_object([]) do |l, arr|
        m = l.match(/^(?:sudo )?gem install (?:--user-install )?(?<gem>\S+)(?: (?:-v|--version) '(?<version>[0-9.]+)')?/)
        arr << { gem: m['gem'], version: m['version'] }
      end
    end

    def sudo(include_version: true)
      gem_list.map do |gem|
        version = include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "sudo gem install #{gem[:gem]}#{version}"
      end
    end

    def user_install(include_version: true)
      gem_list.map do |gem|
        version = include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "gem install --user-install #{gem[:gem]}#{version}"
      end
    end

    def normal_install(include_version: true)
      gem_list.map do |gem|
        version = include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "gem install #{gem[:gem]}#{version}"
      end
    end
  end
end
