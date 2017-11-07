# Faraday Sunset

[![Build Status][travis-image]][travis-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![MIT License][license-image]][license-url]

Watch out for HTTP responses declaring their end of life, using the Sunset header to signal deprecation (and eventual removal) of an endpoint.

[Sunset][sunset-draft] is an in-development HTTP response header. Check out [GitHub][sunset-github] for issues and discussion around it's development.

> This specification defines the Sunset HTTP response header field, which indicates that a URI is likely to become unresponsive at a specified point in the future.

[sunset-draft]: https://tools.ietf.org/html/draft-wilde-sunset-header-03
[sunset-github]: https://github.com/dret/I-D/tree/master/sunset-header

The header we're sniffing for looks a little like this:

```
Sunset: Sat, 31 Dec 2018 23:59:59 GMT
```

So long as the server being called is inserting a `Sunset` header to the response with a [HTTP date], this client-side code will do stuff.

[HTTP date]: https://tools.ietf.org/html/rfc7231#section-7.1.1.1

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
- **Faraday:** v0.9 - v0.13

## Related Projects

- [rails-sunset](https://github.com/wework/rails-sunset) - Mark your endpoints as deprecated the Railsy way
- [guzzle-sunset](https://github.com/hskrasek/guzzle-sunset) - Sniff for deprecations with popular PHP client Guzzle

## TODO

- [ ] Surface `Link` with rel=sunset as per Sunset RFC draft 04?

## Testing

To run tests and modify locally, you'll want to `bundle install` in this directory.

```
bundle exec appraisal rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [wework/faraday-sunset](https://github.com/wework/faraday-sunset). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

[coveralls-image]:https://coveralls.io/repos/github/wework/faraday-sunset/badge.svg?branch=master
[coveralls-url]:https://coveralls.io/github/wework/faraday-sunset?branch=master

[travis-url]:https://travis-ci.org/wework/faraday-sunset
[travis-image]: https://travis-ci.org/wework/faraday-sunset.svg?branch=master

[license-url]: LICENSE
[license-image]: http://img.shields.io/badge/license-MIT-000000.svg?style=flat-square
