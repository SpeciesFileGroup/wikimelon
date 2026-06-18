## [Unreleased]

## [0.1.1] - 2026-06-17
 - Allow Ruby 4.0.0:
    - Relaxed `required_ruby_version` to `>= 2.7.0, < 5.0`
    - Added Ruby 4.0.0 to the CI matrix
    - Bumped `faraday-follow_redirects` upper bound to allow 0.5+ (which lifts the Ruby < 4 cap)
    - Added `rexml` and `irb` development dependencies (no longer in stdlib on Ruby 4)
 - Fixed copy-paste residue: 503 error message said "Crossref is rate limiting your requests." (Crossref is the upstream serrano template's API) — changed to "Wikidata is rate limiting your requests."
 - Switched `test_find_and_label` and `test_item_find_many_preserves_order` from Q42 (Douglas Adams) to Q1/Q5 because Q42's English label was vandalized on Wikidata

## [0.1.0] - 2026-05-04
- Added `Wikimelon.exists?` to check whether a P/Q ID resolves to an entity at the exact requested ID (catches missing IDs and merge/redirect cases)
- Added `Wikimelon::Item` and `Wikimelon::Property` wrappers with helpers for `label`, `description`, `aliases`, `sitelink`, `claim(s)`, and `datatype`
- Added `Wikimelon::Statement` for unwrapping claim values (entity-id, time, string, external-id, monolingualtext, quantity)
- Added `Wikimelon.default_language` config (defaults to `"en"`)
- Added `Wikimelon.request_interval` config for client-side throttling between requests
- Added retry-on-429/503 with exponential backoff via `faraday-retry`, configurable through `Wikimelon.retry_max` (disabled by default) and `Wikimelon.retry_interval`; honors `Retry-After` headers
- Added `revision_id:` keyword to `Item.find` / `Property.find`
- Added `Wikimelon.api_url` and `Wikimelon.sparql_url` configs for pointing at self-hosted Wikibase instances
- Added `Item.search` / `Property.search` (fuzzy search by label/alias via `wbsearchentities`) returning `Wikimelon::SearchResult` objects
- Added `Item.find_many` / `Property.find_many` for batch entity fetch via `wbgetentities` (auto-chunks to the API's 50-per-request limit)
- Dropped the `multi_json` runtime dependency in favor of stdlib `JSON`
- Bumped the minimum Ruby version to 2.7

## [0.0.2] - 2025-03-06
- Added entity endpoint

## [0.0.1] - 2025-03-04
- Initial release wrapping the SPARQL query endpoint
