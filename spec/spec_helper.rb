# frozen_string_literal: true

unless ENV['CI'] == 'true'
  # SimpleCov::Formatter::Codecov # For CI
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start
end

require 'binbundle'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def defaults
  {
    bin_for: nil,
    dry_run: true,
    file: 'spec/gemlist.txt',
    gem_for: nil,
    include_version: true,
    local: false,
    sudo: false,
    user_install: false
  }
end
