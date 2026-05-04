# frozen_string_literal: true

require "erb"
require_relative "wikimelon/error"
require_relative "wikimelon/version"
require_relative "wikimelon/request"
require "wikimelon/helpers/configuration"

module Wikimelon
  extend Configuration

  define_setting :mailto, ENV["WIKIMELON_API_EMAIL"]
  define_setting :default_language, 'en'
  define_setting :request_interval, 0
  define_setting :retry_max, 0
  define_setting :retry_interval, 0.5
  define_setting :api_url, 'https://www.wikidata.org'
  define_setting :sparql_url, 'https://query.wikidata.org/sparql'

  # Run a Wikidata SPARQL query
  #
  # @param query [String] a Wikidata query
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.query(query, verbose: false)
    Request.new(
      url: sparql_url,
      query: query,
      verbose: verbose
    ).perform
  end


  # Get Wikidata entity data
  #
  # @param entity_id [String] a Wikidata entity ID
  # @param revision_id [int] a revision ID
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.entity(entity_id, revision_id: nil, verbose: false)
    url = "#{api_url}/wiki/Special:EntityData/#{entity_id}.json"
    url = "#{url}?revision=#{revision_id}" unless revision_id.nil?
    Request.new(
      url: url,
      verbose: verbose
    ).perform
  end

  # Check whether a Wikidata entity exists at the exact ID requested.
  # Returns false for missing IDs and for IDs that have been merged or
  # redirected (the API returns the target entity, whose id differs from
  # the requested string).
  #
  # @param entity_id [String] a Wikidata entity ID
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Boolean]
  def self.exists?(entity_id, verbose: false)
    res = entity(entity_id, verbose: verbose)
    res.dig('entities', entity_id, 'id') == entity_id
  rescue Wikimelon::NotFound
    false
  end

  # Fetch multiple Wikidata entities in a single request via wbgetentities.
  # Up to 50 IDs per call (the API hard limit). Use Item.find_many or
  # Property.find_many for the wrapped-object form.
  #
  # @param ids [Array<String>]
  # @return [Hash] the raw {"entities" => {...}} response
  def self.entities(ids, verbose: false)
    Request.new(
      url: "#{api_url}/w/api.php",
      params: { action: 'wbgetentities', ids: ids.join('|'), format: 'json' },
      verbose: verbose
    ).perform
  end

  # Fuzzy-search Wikidata for an item, property, or other entity type
  # via wbsearchentities. Returns the raw response hash; use
  # Item.search / Property.search for the wrapped form.
  #
  # @param query [String] free-text search
  # @param type [String] "item", "property", "lexeme", "form", "sense"
  # @param language [String] language code; defaults to Wikimelon.default_language
  # @param limit [Integer] 1-50
  def self.search(query, type: 'item', language: nil, limit: 10, verbose: false)
    Request.new(
      url: "#{api_url}/w/api.php",
      params: {
        action: 'wbsearchentities',
        search: query,
        language: language || default_language,
        type: type,
        limit: limit,
        format: 'json'
      },
      verbose: verbose
    ).perform
  end
end

require_relative "wikimelon/throttle"
require_relative "wikimelon/reference"
require_relative "wikimelon/statement"
require_relative "wikimelon/search_result"
require_relative "wikimelon/resource"
require_relative "wikimelon/item"
require_relative "wikimelon/property"
