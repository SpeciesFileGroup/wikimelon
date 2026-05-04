# frozen_string_literal: true

module Wikimelon
  class Item < Resource
    def sitelink(site)
      @entity&.dig('sitelinks', site, 'title')
    end
  end
end
