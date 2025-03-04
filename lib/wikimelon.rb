# frozen_string_literal: true

require "erb"
require_relative "wikimelon/error"
require_relative "wikimelon/version"
require_relative "wikimelon/request"
require "wikimelon/helpers/configuration"

module Wikimelon
  extend Configuration

  define_setting :base_url, "https://query.wikidata.org/sparql"
  define_setting :mailto, ENV["WIKIMELON_API_EMAIL"]

  # Run a Wikidata query
  #
  # @param query [String] a Wikidata query
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.query(query, verbose: false)
    Request.new(
      endpoint: "",
      query: query,
      verbose: verbose
    ).perform
  end
end
