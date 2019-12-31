[![Travis Build Status](http://img.shields.io/travis/Studiosity/plagscan-ruby.svg?style=flat)](https://travis-ci.org/Studiosity/plagscan-ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/43ec9575fe4727b96adb/maintainability)](https://codeclimate.com/github/Studiosity/plagscan-ruby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/43ec9575fe4727b96adb/test_coverage)](https://codeclimate.com/github/Studiosity/plagscan-ruby/test_coverage)
[![Gem Version](http://img.shields.io/gem/v/plagscan.svg?style=flat)](http://rubygems.org/gems/plagscan)

# PlagScan

Ruby wrapper for PlagScan plagiarism API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'plagscan'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install plagscan

# Supported APIs

## Ping
#### Check if the PlagScan API is available 
```ruby
Plagscan.ping
=> true
```

## Token
#### Authenticate and fetch `access_token` to use with other APIs
```ruby
Plagscan::Token.fetch client_id: '1234', client_secret: 'secret'
=> { access_token: 'secret_token', expires_in: 86400 }
```

## Documents
#### Upload documents to be checked by PlagScan 
```ruby
Plagscan::Documents.create access_token: 'secret_token', file: file
=> { documentID: '1234', .... }
```

N.B. you can also pass through the document as raw text using the `text` parameter in place of the `file` parameter.

Optional parameters for `userID`, `textname`, `toRepository` and `saveOrig`.
See [document create documentation](https://api.plagscan.com/v3docs/#api-Document-SubmitDocument)
for further details

#### Begin check of document uploaded to PlagScan
```ruby
Plagscan::Documents.check access_token: 'secret_token', document_id: 1234
=> nil
```

#### Retrieve results of document scan
```ruby
Plagscan::Documents.retrieve access_token: 'secret_token', document_id: 1234, mode: 0
=> { ... }
```
See [document retrieve documentation](https://api.plagscan.com/v3docs/#api-Document-RetrieveDocumentReport)
for further details

## Users
#### List user details
```ruby
Plagscan::Users.list access_token: 'secret_token'
=> [{ ... }, { ... }, ...]
```
See [user list documentation](https://api.plagscan.com/v3docs/#api-User-ListUser) for further details

#### Get user details
```ruby
Plagscan::Users.get access_token: 'secret_token', user_id: 123456
=> { ... }
```
See [user get documentation](https://api.plagscan.com/v3docs/#api-User-GetUser) for further details


# Development

For details of the PlagScan API see documentation at https://api.plagscan.com/v3docs/


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Studiosity/plagscan-ruby.

Note that spec tests are appreciated to minimise regressions.
Before submitting a PR, please ensure that:
 
```bash
$ rspec
```
and

```bash
$ rubocop
```
both succeed 


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
