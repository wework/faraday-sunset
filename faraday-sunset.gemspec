# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'faraday-sunset'
  spec.version       = '0.2.0'
  spec.summary       = 'Automatically detect deprecated HTTP endpoints'
  spec.description   = 'Faraday middleware that sniffs responses for Sunset headers'
  spec.homepage      = 'https://github.com/philsturgeon/faraday-sunset'
  spec.licenses      = ['MIT']
  spec.authors       = ['WeWork Engineering']
  spec.email         = ['engineering@wework.com']

  spec.files         = Dir['LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_dependency 'faraday', '>= 0.9.0', '< 2'

  spec.add_development_dependency 'appraisal', '~> 2'
  spec.add_development_dependency 'rollbar'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'simplecov', '~> 0.15'
end
