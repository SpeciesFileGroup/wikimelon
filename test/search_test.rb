require_relative "test_helper"

class TestSearch < Test::Unit::TestCase

  def test_item_search
    VCR.use_cassette("test_item_search") do
      results = Wikimelon::Item.search("Douglas Adams", limit: 3)
      assert_kind_of(Array, results)
      assert(!results.empty?)
      assert_kind_of(Wikimelon::SearchResult, results.first)
      # Q42 is the canonical Douglas Adams; should be in the top results
      assert(results.any? { |r| r.id == 'Q42' })
      hit = results.find { |r| r.id == 'Q42' }
      assert_equal('Douglas Adams', hit.label)
      assert_kind_of(String, hit.description)
    end
  end

  def test_property_search
    VCR.use_cassette("test_property_search") do
      results = Wikimelon::Property.search("taxon", limit: 5)
      assert(!results.empty?)
      # All hits should be P-IDs
      assert(results.all? { |r| r.id.start_with?('P') })
      assert(results.any? { |r| r.label == 'taxon name' })
    end
  end

  def test_search_honors_limit
    VCR.use_cassette("test_search_limit") do
      results = Wikimelon::Item.search("the", limit: 2)
      assert_operator(results.size, :<=, 2)
    end
  end
end
