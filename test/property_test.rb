require_relative "test_helper"

class TestProperty < Test::Unit::TestCase

  def test_find_and_metadata
    VCR.use_cassette("test_property_find") do
      prop = Wikimelon::Property.find('P12817')
      assert_equal('P12817', prop.id)
      assert_true(prop.exists?)
      assert_equal('external-id', prop.datatype)
      assert_equal('Cockroach Species File taxon ID (new)', prop.label)
    end
  end
end
