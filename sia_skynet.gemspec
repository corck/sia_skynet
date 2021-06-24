# frozen_string_literal: true

require_relative 'lib/skynet/version'

Gem::Specification.new do |spec|
  spec.name          = 'skynet_ruby'
  spec.version       = Skynet::VERSION
  spec.authors       = ['Christoph Klocker']
  spec.email         = ['christoph@vedanova.com']

  spec.summary       = 'Skynet client to interact with Sia Skynet'
  spec.description   = 'Skynet is a decentralized storage solution built on the Sia blockchain'
  spec.homepage      = 'https://siasky.net'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/corck/sia_skynet'
  # spec.metadata["changelog_uri"] = "https://github.com/corck/sia_skynet"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'typhoeus', '~> 1.4.0'
  spec.add_dependency 'mime-types', '~> 3.3.0'
  spec.add_dependency 'multipart_body', '~> 0.2.1'
end
