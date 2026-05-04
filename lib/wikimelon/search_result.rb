# frozen_string_literal: true

module Wikimelon
  # A single hit from wbsearchentities. Lighter than a full Resource —
  # only the fields the search endpoint returns. Call Item.find(result.id)
  # to hydrate the full entity.
  class SearchResult
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def id          = @raw['id']
    def label       = @raw['label']
    def description = @raw['description']
    def aliases     = @raw['aliases'] || []
    def concept_uri = @raw['concepturi']
    def url         = @raw['url']
  end
end
