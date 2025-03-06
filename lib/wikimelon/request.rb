require_relative "faraday" # !! Potential ruby 3.0 difference in module loading? relative differs from Serrano
require "faraday/follow_redirects"
require_relative "utils"

module Wikimelon

  class Request
    attr_accessor :endpoint
    attr_accessor :q
    attr_accessor :verbose

    attr_accessor :options

    def initialize(**args)
      @url = args[:url]
      @verbose = args[:verbose]
      @query = args[:query]
      @limit = args[:limit]
      @offset = args[:offset]
      @options = args[:options] # TODO: not added at wikimelon.rb
    end

    def perform

      args = {'query': @query, 'format': 'json'}
      opts = args.delete_if { |_k, v| v.nil? }

      Faraday::Utils.default_space_encoding = "+"

      conn = Faraday.new(url: @url) do |f|
              f.response :logger if verbose
              f.use Faraday::WikimelonErrors::Middleware
              f.adapter Faraday.default_adapter
             end

      conn.headers['Accept'] = 'application/json,*/*'
      conn.headers[:user_agent] = make_user_agent
      conn.headers["X-USER-AGENT"] = make_user_agent

      res = conn.get(endpoint, opts)

      MultiJson.load(res.body)      
    end
  end
end
