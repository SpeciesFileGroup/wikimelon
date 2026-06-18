require_relative "test_helper"

class TestFindMany < Test::Unit::TestCase

  def test_item_find_many_preserves_order
    VCR.use_cassette("test_item_find_many") do
      ids = ['Q5', 'Q13', 'Q1']
      items = Wikimelon::Item.find_many(ids)
      assert_equal(ids, items.map(&:id))
      assert(items.all? { |i| i.exists? })
      labels = items.map(&:label)
      assert_equal('human', labels[0])
      assert_equal('triskaidekaphobia', labels[1])
      assert_equal('universe', labels[2])
    end
  end

  def test_property_find_many
    VCR.use_cassette("test_property_find_many") do
      props = Wikimelon::Property.find_many(['P31', 'P279'])
      assert_equal(['P31', 'P279'], props.map(&:id))
      assert(props.all? { |p| p.exists? })
      assert_equal('wikibase-item', props[0].datatype)
    end
  end

  def test_find_many_chunks_at_50
    # Build 73 IDs; expect 2 underlying requests (50 + 23) and 73 results in order.
    ids = (1..73).map { |n| "Q#{n}" }
    VCR.use_cassette("test_find_many_chunked") do
      items = Wikimelon::Item.find_many(ids)
      assert_equal(73, items.size)
      assert_equal(ids, items.map(&:id))
    end
  end
end
