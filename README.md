# Faraday Sunset

[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![MIT License][license-image]][license-url]

Watch out for [Sunset headers] on HTTP responses, as they signify the deprecation (and eventual removal) of an endpoint.

Sunset is an in-development RFC for a HTTP response header, [currently v03][sunset-draft]. Check out [GitHub][sunset-github] for issues and discussion around it's development.

> This specification defines the Sunset HTTP response header field, which indicates that a URI is likely to become unresponsive at a specified point in the future.

[sunset-draft]: https://tools.ietf.org/html/draft-wilde-sunset-header-03
[sunset-github]: https://github.com/dret/I-D/tree/master/sunset-header

## Usage

Add gem to Gemfile:

```ruby
gem 'faraday-sunset'
```

Enabling Sunset detection is as simple as referencing the middleware in your Faraday connection block:

``` ruby
connection = Faraday.new(url: '...') do |conn|
  conn.response :sunset, active_support: true
  # or
  conn.response :sunset, logger: Rails.logger
end
```

You can [configure `ActiveSupport::Deprecation`][active-support-deprecation] to warn in a few different ways, or pass in any object that acts a bit like a Rack logger, Rails logger, or anything with a `warn` method that takes a string.

[active-support-deprecation]: http://api.rubyonrails.org/classes/ActiveSupport/Deprecation/Behavior.html

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

Bug reports and pull requests are welcome on GitHub at [philsturgeon/faraday-sunset](https://github.com/philsturgeon/faraday-sunset). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

[coveralls-image]:https://coveralls.io/repos/github/philsturgeon/faraday-sunset/badge.svg?branch=master
[coveralls-url]:https://coveralls.io/github/philsturgeon/faraday-sunset?branch=master

[travis-url]:https://travis-ci.org/philsturgeon/faraday-sunset
[travis-image]: https://travis-ci.org/philsturgeon/faraday-sunset.svg?branch=master

[license-url]: LICENSE
[license-image]: http://img.shields.io/badge/license-MIT-000000.svg?style=flat-square
