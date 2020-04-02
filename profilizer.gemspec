# frozen_string_literal: true

require_relative 'lib/profilizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'profilizer'
  spec.version       = Profilizer::VERSION
  spec.authors       = ['Dzmitry Kremez']
  spec.email         = ['mr.dkremez@gmail.com']

  spec.summary       = 'Profile you methods easier'
  spec.description   = <<~DEC
    Some times we need to test in development how long our methods execute,
    how much memery code consumes, how many objects it allocates.
    What if we don't want to touch the code a lot and just like kind of a decorator
    that will log profile info into the console.
    This gem helps to do it in one line of code.
  DEC
  spec.homepage      = 'https://github.com/dkremez/profilizer'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby2_keywords', '~> 0.0.2'
end
