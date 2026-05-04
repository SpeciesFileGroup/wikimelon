# frozen_string_literal: true

module Wikimelon
  class Resource
    attr_reader :id, :raw

    def self.find(id, revision_id: nil)
      new(id, Wikimelon.entity(id, revision_id: revision_id))
    end

    # Fetch multiple resources by ID in batches of up to 50 (the wbgetentities
    # hard limit). Returns wrapped resources in the same order as the input.
    def self.find_many(ids)
      ids.each_slice(50).flat_map do |batch|
        data = Wikimelon.entities(batch)
        batch.map { |id| new(id, data) }
      end
    end

    # Fuzzy-search by label or alias. Returns Array<SearchResult>.
    def self.search(query, language: nil, limit: 10)
      type = self == Property ? 'property' : 'item'
      res = Wikimelon.search(query, type: type, language: language, limit: limit)
      (res['search'] || []).map { |hit| SearchResult.new(hit) }
    end

    def initialize(id, data)
      @id     = id
      @raw    = data
      @entity = data.dig('entities', id)
    end

    def exists?
      !@entity.nil? && @entity['id'] == @id
    end

    def label(lang = nil)
      @entity&.dig('labels', lang || Wikimelon.default_language, 'value')
    end

    def description(lang = nil)
      @entity&.dig('descriptions', lang || Wikimelon.default_language, 'value')
    end

    def aliases(lang = nil)
      (@entity&.dig('aliases', lang || Wikimelon.default_language) || []).map { |a| a['value'] }
    end

    def claims(property_id)
      (@entity&.dig('claims', property_id) || []).map { |c| Statement.new(c) }
    end
  end
end
