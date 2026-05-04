# frozen_string_literal: true

module Wikimelon
  # Enforces a minimum interval between outgoing requests when
  # Wikimelon.request_interval is set (in seconds). Thread-safe.
  module Throttle
    @mutex = Mutex.new
    @last_request_at = nil

    def self.wait!
      interval = Wikimelon.request_interval.to_f
      return if interval <= 0

      @mutex.synchronize do
        if @last_request_at
          elapsed = now - @last_request_at
          sleep(interval - elapsed) if elapsed < interval
        end
        @last_request_at = now
      end
    end

    def self.reset!
      @mutex.synchronize { @last_request_at = nil }
    end

    def self.now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
