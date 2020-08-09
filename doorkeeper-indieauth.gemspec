# frozen_string_literal: true

require_relative 'lib/doorkeeper/indieauth/version'

Gem::Specification.new do |spec|
  spec.name          = 'doorkeeper-indieauth'
  spec.version       = Doorkeeper::IndieAuth::VERSION
  spec.authors       = ['Tony Burns']
  spec.email         = ['tony@tonyburns.net']

  spec.summary       = 'IndieAuth provider for Rails built on Doorkeeper'
  spec.description   = 'Doorkeeper IndieAuth is an IndieAuth provider built on the Doorkeeper library'
  spec.homepage      = 'https://github.com/craftyphotons/doorkeeper-indieauth'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/craftyphotons/doorkeeper-indieauth'
  spec.metadata['changelog_uri'] = 'https://github.com/craftyphotons/doorkeeper-indieauth/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'doorkeeper'
  spec.add_dependency 'link-header-parser'
  spec.add_dependency 'microformats'
  spec.add_dependency 'validate_url'
end
