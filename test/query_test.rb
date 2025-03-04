require_relative "test_helper"

class TestParse < Test::Unit::TestCase

  def test_query
    VCR.use_cassette("test_query") do
      query = "
        SELECT ?human ?humanLabel ?zoobank WHERE {
          ?human wdt:P31 wd:Q5.
          ?human wdt:P2006 ?zoobank.
          SERVICE wikibase:label { bd:serviceParam wikibase:language \"[AUTO_LANGUAGE],en\". }
        } LIMIT 1 OFFSET 0"
      res = Wikimelon.query(query)
      assert_equal("human", res['head']["vars"][0])
    end
  end
end