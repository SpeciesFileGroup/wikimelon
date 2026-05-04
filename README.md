# Wikimelon

Wikimelon is a lightweight Ruby wrapper on the [Wikidata](https://wikidata.org) API. Code follow the spirit/approach of the Gem [serrano](https://github.com/sckott/serrano), and indeed much of the wrapping utility is copied 1:1 from that repo, thanks [@sckott](https://github.com/sckott).

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
query = "
SELECT ?human ?humanLabel ?zoobank WHERE {
  ?human wdt:P31 wd:Q5.
  ?human wdt:P2006 ?zoobank.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
} LIMIT 100 OFFSET 0
"
Wikimelon.query(query) #  => MultiJson object
```

---
### Items
Fetch a Wikidata item (`Q…`). Returns a `Wikimelon::Item` with helpers for labels, descriptions, aliases, sitelinks, and claims:
```ruby
item = Wikimelon::Item.find("Q42")

item.id                         # => "Q42"
item.exists?                    # => true
item.label                      # => "Douglas Adams"
item.label("de")                # => "Douglas Adams"
item.description("en")          # => "English author and humourist (1952–2001)"
item.aliases("en")              # => ["Douglas Noël Adams", ...]
item.sitelink("enwiki")         # => "Douglas Adams"

# Claims are returned as Wikimelon::Statement objects.
# A property can have multiple claims (sometimes contradictory), each carrying
# a rank: "preferred", "normal", or "deprecated". The caller decides which to use.
item.claims("P31").map(&:value)            # => ["Q5"]   (instance of: human)
item.claims("P569").first.value            # => "+1952-03-11T00:00:00Z"  (date of birth)
item.claims("P106").map(&:value)           # => ["Q36180", "Q28389", ...]  (occupations)

# When a property has multi-rank statements, filter explicitly:
france = Wikimelon::Item.find("Q142")
france.claims("P35").find { |s| s.rank == "preferred" }.value  # current head of state

# Each statement carries the references that cite it.
# A reference is a bag of snaks (property → value) pointing at a source.
stmt = item.claims("P31").first
ref  = stmt.references.first
ref.properties                     # => ["P248", "P268", "P407", "P813"]
ref.snaks("P248").first.value      # => "Q19938912"  (BnF authorities)

# Escape hatch — the raw JSON Hash is still available
item.raw                        # => { "entities" => { "Q42" => {...} } }
```

Fetch a specific revision:
```ruby
Wikimelon::Item.find("Q13", revision_id: 109)
```

`item.exists?` returns `false` for missing IDs and for IDs that have been merged or redirected (in a redirect, the API returns the *target* entity, whose `id` differs from the requested string):
```ruby
Wikimelon::Item.find("Q52793654").exists?    # => false  (redirects to Q336)
Wikimelon::Item.find("Q1000000000").exists?  # => false  (well-formed but unassigned)
```

---
### Properties
Fetch a Wikidata property (`P…`). Returns a `Wikimelon::Property` with all the `Item` helpers plus `#datatype`:
```ruby
prop = Wikimelon::Property.find("P12817")

prop.label       # => "Cockroach Species File taxon ID (new)"
prop.datatype    # => "external-id"
```

---
### Low-level access
For most cases prefer `Item.find` / `Property.find` above. The raw endpoint is exposed for advanced use (custom JSON processing, pre-flighting an ID before constructing a wrapper):

```ruby
Wikimelon.entity("Q13")                           #  => raw Hash
Wikimelon.entity("Q13", revision_id: 109)         #  => raw Hash at revision

Wikimelon.exists?("Q42")          # => true
Wikimelon.exists?("Q52793654")    # => false  (redirects to Q336)
Wikimelon.exists?("Q1000000000")  # => false  (well-formed but unassigned)
```

---
### Configuration
Set a default language for `label`, `description`, and `aliases` (defaults to `"en"`):
```ruby
Wikimelon.default_language = "es"

spain = Wikimelon::Item.find("Q29")
spain.label          # => "España"   (uses the configured default)
spain.label("en")    # => "Spain"    (explicit override still works)
```

Throttle outgoing requests by setting a minimum interval between them in seconds (defaults to `0`, no throttling). Useful when running batch jobs against Wikidata to stay polite:
```ruby
Wikimelon.request_interval = 0.5   # at most 2 requests/second

# Subsequent calls will sleep as needed to enforce the gap
ids.each { |id| Wikimelon::Item.find(id) }
```

Retry on transient errors (`429 Too Many Requests`, `503 Service Unavailable`) with exponential backoff. **Disabled by default** because the sleeps can stall interactive UI requests for many seconds — opt in for batch/CLI work where latency doesn't matter:
```ruby
Wikimelon.retry_max      = 5     # number of retries (0 = disabled)
Wikimelon.retry_interval = 0.5   # base wait in seconds; doubles each retry
```
When the server provides a `Retry-After` header (Wikidata's SPARQL endpoint reliably does on 429), that value is honored instead of the exponential calculation.

Point Wikimelon at a self-hosted Wikibase instance or query service:
```ruby
Wikimelon.api_url    = "https://wikibase.example.org"          # Special:EntityData host
Wikimelon.sparql_url = "https://wdqs.example.org/sparql"       # SPARQL endpoint
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
