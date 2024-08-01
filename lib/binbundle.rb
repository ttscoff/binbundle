# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'tty-spinner'
require_relative 'binbundle/version'
require_relative 'binbundle/prompt'
require_relative 'binbundle/gem_list'
require_relative 'binbundle/gem_bins'

module Binbundle
  class Error < StandardError; end
  # Your code goes here...
end
