# frozen_string_literal: true

lib = File.expand_path(File.join('..', 'lib'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'binbundle/version'

Gem::Specification.new do |s|
  s.name          = 'binbundle'
  s.version       = Binbundle::VERSION
  s.authors       = ['Brett Terpstra']
  s.email         = ['me@brettterpstra.com']

  s.summary       = 'Bundle all your gem binaries.'
  s.description   = 'Easily take a snapshot of all binaries installed with Gem and restore on a fresh system.'
  s.homepage      = 'https://github.com/ttscoff/binbundle'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.6.0'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/ttscoff/binbundle'
  s.metadata['changelog_uri'] = 'https://github.com/ttscoff/binbundle/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency "simplecov", "~> 0.21"
  s.add_development_dependency "simplecov-console", "~> 0.9"
  s.add_development_dependency "yard", "~> 0.9", ">= 0.9.26"

  s.add_runtime_dependency('tty-spinner', '~> 0.9')
end
