# frozen_string_literal: true

module Wikimelon
  # A citation attached to a Statement. Holds a bag of snaks keyed by property,
  # commonly P248 ("stated in"), P854 ("reference URL"), P813 ("retrieved"),
  # P1476 ("title"), P143 ("imported from").
  class Reference
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def snaks(property_id)
      (@raw.dig('snaks', property_id) || []).map { |s| Statement.new('mainsnak' => s) }
    end

    def properties
      @raw['snaks-order'] || (@raw['snaks'] || {}).keys
    end
  end
end
