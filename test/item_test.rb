require_relative "test_helper"

class TestItem < Test::Unit::TestCase

  def test_find_and_label
    VCR.use_cassette("test_item_find_label") do
      item = Wikimelon::Item.find('Q1')
      assert_equal('Q1', item.id)
      assert_true(item.exists?)
      assert_equal('universe', item.label)
      assert_equal('universe', item.label('en'))
    end
  end

  def test_description_and_aliases
    VCR.use_cassette("test_item_find") do
      item = Wikimelon::Item.find('Q42')
      assert_kind_of(String, item.description('en'))
      assert_kind_of(Array, item.aliases('en'))
    end
  end

  def test_claims_entity_value
    VCR.use_cassette("test_item_find") do
      item = Wikimelon::Item.find('Q42')
      # P31 = "instance of"; Q5 = "human"
      assert_equal(['Q5'], item.claims('P31').map(&:value))
    end
  end

  def test_unknown_property_returns_empty
    VCR.use_cassette("test_item_find") do
      item = Wikimelon::Item.find('Q42')
      assert_equal([], item.claims('P9999999'))
    end
  end

  def test_statement_references
    VCR.use_cassette("test_item_find") do
      item = Wikimelon::Item.find('Q42')
      stmt = item.claims('P31').first  # instance of: human
      refs = stmt.references
      assert(!refs.empty?, "expected P31 to be cited")

      ref = refs.first
      # Wikidata's BnF citation: P248 "stated in" → Q19938912 (BnF authorities)
      assert_equal('Q19938912', ref.snaks('P248').first.value)
      assert(ref.properties.include?('P248'))
    end
  end

  def test_claims_carry_rank
    VCR.use_cassette("test_item_claim_rank") do
      france = Wikimelon::Item.find('Q142')
      # France has many "head of state" (P35) claims spanning history;
      # the current one carries rank=preferred. Callers can filter explicitly.
      ranks = france.claims('P35').map(&:rank).uniq
      assert(ranks.include?('preferred'), "expected at least one preferred-rank statement")
      assert(ranks.include?('normal'),    "expected at least one normal-rank statement")

      current = france.claims('P35').find { |s| s.rank == 'preferred' }
      assert_kind_of(Wikimelon::Statement, current)
      assert_match(/^Q\d+$/, current.value)
    end
  end

  def test_find_with_revision_id
    VCR.use_cassette("test_item_find_revision") do
      item = Wikimelon::Item.find('Q13', revision_id: 109)
      assert_equal('Q13', item.id)
      assert_equal(109, item.raw.dig('entities', 'Q13', 'lastrevid'))
    end
  end

  def test_redirected_item_does_not_exist
    VCR.use_cassette("test_item_redirected") do
      item = Wikimelon::Item.find('Q52793654')   # redirects to Q336
      assert_false(item.exists?)
    end
  end

  def test_default_language_config
    VCR.use_cassette("test_item_default_language") do
      original = Wikimelon.default_language
      Wikimelon.default_language = 'es'
      item = Wikimelon::Item.find('Q29')
      assert_equal('España', item.label)              # uses the configured default
      assert_equal('Spain', item.label('en'))         # explicit override still works
    ensure
      Wikimelon.default_language = original
    end
  end
end
