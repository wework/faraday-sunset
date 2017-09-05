$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_group 'lib', 'lib'
end

require 'faraday'
require 'faraday_sunset'
