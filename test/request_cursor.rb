# require "faraday"
# require "faraday_middleware"
# require "multi_json"

##
# Wikimelon::RequestCursor
#
## Class to perform HTTP requests to the Catalog of Life API
module Wikimelon
  class RequestCursor
    attr_accessor :endpoint
    attr_accessor :engine
    attr_accessor :q

    def initialize(endpoint, engine, q)
    end
  end
end
