# nimono

nimono is a interface to CaboCha for CRuby(mri/yarv) and JRuby(jvm).
It depends on the CaboCha library so the library will have to install first.

## Requirements

nimono requires the following:

- [CaboCha _0.69_](https://taku910.github.io/cabocha/)
- [CaboCha](https://taku910.github.io/cabocha/) requires [CRF++](https://taku910.github.io/crfpp/), [MeCab](http://taku910.github.io/mecab/#download) and either of the following dictionaries.
- mecab-ipadic, mecab-jumandic, unidic. For further information please refer to the [MeCab](http://taku910.github.io/mecab/#).
- [FFI _1.9.0 or higher_](https://rubygems.org/gems/ffi)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nimono'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nimono

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nimono. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

