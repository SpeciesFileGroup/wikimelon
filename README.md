# Wikimelon

Wikimelon is a Ruby wrapper on the [Wikidata](https://wikidata.org) API. Code follow the spirit/approach of the Gem [serrano](https://github.com/sckott/serrano), and indeed much of the wrapping utility is copied 1:1 from that repo, thanks [@sckott](https://github.com/sckott).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wikimelon'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wikimelon

## Usage


---
### Queries
Run a Wikidata query:
```ruby
query = """
SELECT ?human ?humanLabel ?zoobank WHERE {
  ?human wdt:P31 wd:Q5.
  ?human wdt:P2006 ?zoobank.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
} LIMIT 100 OFFSET 0
"""
Wikimelon.query(query) #  => MultiJson object
```

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, update the `CHANGELOG.md`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SpeciesFileGroup/wikimelon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/SpeciesFileGroup/wikimelon/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT license](https://github.com/SpeciesFileGroup/wikimelon/blob/main/LICENSE.txt). You can learn more about the MIT license on [Wikipedia](https://en.wikipedia.org/wiki/MIT_License) and compare it with other open source licenses at the [Open Source Initiative](https://opensource.org/license/mit/).

## Code of Conduct

Everyone interacting in the Wikimelon project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SpeciesFileGroup/wikimelon/blob/main/CODE_OF_CONDUCT.md).
