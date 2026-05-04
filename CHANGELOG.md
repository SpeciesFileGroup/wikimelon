## [Unreleased]

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
