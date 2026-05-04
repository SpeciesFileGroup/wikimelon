# frozen_string_literal: true

module Wikimelon
  class Statement
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def rank
      @raw['rank']
    end

    def property
      @raw.dig('mainsnak', 'property')
    end

    def value
      snak_value(@raw['mainsnak'])
    end

    def qualifiers(property_id)
      (@raw.dig('qualifiers', property_id) || []).map { |q| Statement.new('mainsnak' => q) }
    end

    def references
      (@raw['references'] || []).map { |r| Reference.new(r) }
    end

    private

    def snak_value(snak)
      return nil if snak.nil? || snak['snaktype'] != 'value'
      dv = snak['datavalue'] or return nil
      case dv['type']
      when 'wikibase-entityid'     then dv.dig('value', 'id')
      when 'time'                  then dv.dig('value', 'time')
      when 'monolingualtext'       then dv.dig('value', 'text')
      when 'quantity'              then dv.dig('value', 'amount')
      when 'string', 'external-id' then dv['value']
      else dv['value']
      end
    end
  end
end
