require_relative "test_helper"

class TestThrottle < Test::Unit::TestCase

  def teardown
    Wikimelon.request_interval = 0
    Wikimelon::Throttle.reset!
  end

  def test_no_throttle_by_default
    assert_equal(0, Wikimelon.request_interval)
    elapsed = measure do
      5.times { Wikimelon::Throttle.wait! }
    end
    assert(elapsed < 0.05, "expected no throttling, got #{elapsed}s")
  end

  def test_enforces_minimum_interval
    Wikimelon.request_interval = 0.1
    Wikimelon::Throttle.reset!
    elapsed = measure do
      3.times { Wikimelon::Throttle.wait! }
    end
    # First call has no wait; calls 2 and 3 each wait ~0.1s → ~0.2s total.
    assert(elapsed >= 0.18, "expected >= 0.18s, got #{elapsed}s")
  end

  private

  def measure
    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0
  end
end
