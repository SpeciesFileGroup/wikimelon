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

  def test_exists_true
    VCR.use_cassette("test_exists_true") do
      assert_equal(true, Wikimelon.exists?('Q13'))
    end
  end

  def test_exists_false_not_found
    VCR.use_cassette("test_exists_false_not_found") do
      assert_equal(false, Wikimelon.exists?('Q1000000000'))
    end
  end

  def test_exists_false_redirected
    VCR.use_cassette("test_exists_false_redirected") do
      assert_equal(false, Wikimelon.exists?('Q52793654'))
    end
  end

  def test_api_url_is_configurable
    original = Wikimelon.api_url
    Wikimelon.api_url = 'https://wikibase.example.invalid'
    VCR.turned_off do
      stub = WebMock.stub_request(:get, %r{wikibase\.example\.invalid/wiki/Special:EntityData/Q13\.json})
                    .to_return(status: 200, body: '{"entities":{"Q13":{"id":"Q13"}}}',
                               headers: { 'Content-Type' => 'application/json' })
      Wikimelon.entity('Q13')
      assert_requested(stub)
    end
  ensure
    Wikimelon.api_url = original
    WebMock.reset!
  end

  def test_sparql_url_is_configurable
    original = Wikimelon.sparql_url
    Wikimelon.sparql_url = 'https://wdqs.example.invalid/sparql'
    VCR.turned_off do
      stub = WebMock.stub_request(:get, %r{wdqs\.example\.invalid/sparql})
                    .to_return(status: 200, body: '{"head":{},"results":{"bindings":[]}}',
                               headers: { 'Content-Type' => 'application/json' })
      Wikimelon.query('SELECT * WHERE { ?s ?p ?o } LIMIT 1')
      assert_requested(stub)
    end
  ensure
    Wikimelon.sparql_url = original
    WebMock.reset!
  end
end