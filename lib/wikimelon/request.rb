require_relative "faraday" # !! Potential ruby 3.0 difference in module loading? relative differs from Serrano
require "faraday/follow_redirects"
require "faraday/retry"
require "json"
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
      @params = args[:params]
      @limit = args[:limit]
      @offset = args[:offset]
      @options = args[:options] # TODO: not added at wikimelon.rb
    end

    def perform

      opts = @params || {'query': @query, 'format': 'json'}.delete_if { |_k, v| v.nil? }

      Faraday::Utils.default_space_encoding = "+"

      retry_max = Wikimelon.retry_max.to_i

      conn = Faraday.new(url: @url) do |f|
              f.response :logger if verbose
              if retry_max > 0
                f.request :retry,
                          max: retry_max,
                          interval: Wikimelon.retry_interval.to_f,
                          backoff_factor: 2,
                          retry_statuses: [429, 503]
              end
              f.use Faraday::WikimelonErrors::Middleware
              f.adapter Faraday.default_adapter
             end

      conn.headers['Accept'] = 'application/json,*/*'
      conn.headers[:user_agent] = make_user_agent
      conn.headers["X-USER-AGENT"] = make_user_agent

      Wikimelon::Throttle.wait!
      res = conn.get(endpoint, opts)

      JSON.parse(res.body)
    end
  end
end
