# frozen_string_literal: true

module Binbundle
  # String helpers
  class GemList
    attr_writer :include_version

    attr_reader :gem_list

    def initialize(contents, include_version: true)
      @contents = contents
      @include_version = include_version
      @gem_list = gem_list
    end

    def gem_list
      @gem_list ||= @contents.split("\n").delete_if { |line| line.strip.empty? || line =~ /^#/ }.each_with_object([]) do |l, arr|
        m = l.match(/^(?:sudo )?gem install (?:--user-install )?(?<gem>\S+)(?: (?:-v|--version) '(?<version>[0-9.]+)')?/)
        arr << { gem: m['gem'], version: m['version'] }
      end
    end

    def sudo
      @gem_list.map do |gem|
        version = @include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "sudo gem install #{gem[:gem]}#{version}"
      end
    end

    def user_install
      @gem_list.map do |gem|
        version = @include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "gem install --user-install #{gem[:gem]}#{version}"
      end
    end

    def normal_install
      @gem_list.map do |gem|
        version = @include_version && gem[:version] ? " -v '#{gem[:version]}'" : ''
        "gem install #{gem[:gem]}#{version}"
      end
    end
  end
end
