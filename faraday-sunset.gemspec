# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday_sunset/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday_sunset"
  spec.version       = FaradaySunset::VERSION
  spec.authors       = ["Phil Sturgeon"]
  spec.email         = ["me@philsturgeon.uk"]

  spec.summary       = "Automatically detect deprecated HTTP endpoints"
  spec.description   = "Faraday middleware that sniffs responses for Sunset headers"
  spec.homepage      = "https://github.com/philsturgeon/faraday-sunset"
  spec.licenses      = ['MIT']

  spec.files                = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end
  spec.bindir               = "bin"
  spec.require_paths        = ["lib"]
  spec.metadata["yard.run"] = "yri"

  spec.add_dependency "faraday", ">= 0.9.0", "< 0.14"
  spec.add_dependency "faraday_middleware", '~> 0'

  spec.add_development_dependency "appraisal", "~> 2"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "coveralls", '~> 0.7'
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "simplecov", '~> 0.15'
  spec.add_development_dependency "yard"
  spec.add_development_dependency "webmock"
end
