# Faraday Sunset

[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![MIT License][license-image]][license-url]

Watch out for Sunset headers on HTTP responses, as they signify the deprecation (and eventual removal) of an endpoint.

## Usage

Add gem to Gemfile:

```ruby
gem 'faraday_sunset'
```

Enabling Sunset detection is as simple as referencing the middleware in your Faraday connection block:

``` ruby
connection = Faraday::Connection.new(url: '...') do |conn|
  conn.response :sunset, active_support: true
  # or
  conn.response :sunset, logger: Rails.logger
end
```

You can [configure `ActiveSupport::Deprecation`](TODO LINK TO DOCS) to warn in a few different ways, or pass in any object that acts a bit like a Rack logger, Rails logger, or anything with a `warn` method that takes a string.

## Requirements

- **Ruby:** v2.2 - v2.4
- **Faraday:** v0.8 - v0.13

## TODO

- [ ] Surface `Link` with rel=sunset as per Sunset RFC draft 03

## Testing

To run tests and modify locally, you'll want to `bundle install` in this directory.

```
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [philsturgeon/faraday_sunset](https://github.com/philsturgeon/faraday_sunset). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

[coveralls-image]:https://coveralls.io/repos/github/philsturgeon/faraday_sunset/badge.svg?branch=master
[coveralls-url]:https://coveralls.io/github/philsturgeon/faraday_sunset?branch=master

[travis-url]:https://travis-ci.org/philsturgeon/faraday_sunset
[travis-image]: https://travis-ci.org/philsturgeon/faraday_sunset.svg?branch=master

[license-url]: LICENSE
[license-image]: http://img.shields.io/badge/license-MIT-000000.svg?style=flat-square
