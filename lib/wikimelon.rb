# frozen_string_literal: true

require "erb"
require_relative "wikimelon/error"
require_relative "wikimelon/version"
require_relative "wikimelon/request"
require "wikimelon/helpers/configuration"

module Wikimelon
  extend Configuration

  define_setting :mailto, ENV["WIKIMELON_API_EMAIL"]

  # Run a Wikidata SPARQL query
  #
  # @param query [String] a Wikidata query
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.query(query, verbose: false)
    Request.new(
      url: "https://query.wikidata.org/sparql",
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
    url = "https://www.wikidata.org/wiki/Special:EntityData/#{entity_id}.json"
    url = "#{url}?revision=#{revision_id}" unless revision_id.nil?
    Request.new(
      url: url,
      verbose: verbose
    ).perform
  end
end
