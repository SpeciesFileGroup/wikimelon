# frozen_string_literal: true

module Wikimelon
  class Property < Resource
    def datatype
      @entity&.dig('datatype')
    end
  end
end
