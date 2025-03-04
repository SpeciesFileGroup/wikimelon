# frozen_string_literal: true

module Wikimelon
    # Custom error class for rescuing from all Wikidata errors
    class Error < StandardError; end
  
    # Raised when Wikidata returns the HTTP status code 400
    class BadRequest < Error; end
  
    # Raised when Wikidata returns the HTTP status code 404
    class NotFound < Error; end
  
    # Raised when Wikidata returns the HTTP status code 500
    class InternalServerError < Error; end
  
    # Raised when Wikidata returns the HTTP status code 502
    class BadGateway < Error; end
  
    # Raised when Wikidata returns the HTTP status code 503
    class ServiceUnavailable < Error; end
  
    # Raised when Wikidata returns the HTTP status code 504
    class GatewayTimeout < Error; end
end