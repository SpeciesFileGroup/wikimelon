require_relative "test_helper"

class TestParse < Test::Unit::TestCase

  def test_entity
    VCR.use_cassette("test_entity") do
      res = Wikimelon.entity('Q13')
      assert_equal("triskaidekaphobia", res['entities']["Q13"]["labels"]["en"]["value"])
    end
  end

  def test_entity_revision
    VCR.use_cassette("test_entity_revision") do
      res = Wikimelon.entity('Q13', revision_id: 109)
      assert_equal(109, res['entities']["Q13"]["lastrevid"])
    end
  end
end