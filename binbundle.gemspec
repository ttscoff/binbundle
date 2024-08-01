# frozen_string_literal: true

require_relative "lib/binbundle/version"

Gem::Specification.new do |spec|
  spec.name          = 'binbundle'
  spec.version       = Binbundle::VERSION
  spec.authors       = ['Brett Terpstra']
  spec.email         = ['me@brettterpstra.com']

  spec.summary       = 'Bundle all your gem binaries.'
  spec.description   = 'Easily take a snapshot of all binaries installed with Gem and restore on a fresh system.'
  spec.homepage      = 'https://github.com/ttscoff/binbundle'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ttscoff/binbundle'
  spec.metadata['changelog_uri'] = 'https://github.com/ttscoff/binbundle/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
