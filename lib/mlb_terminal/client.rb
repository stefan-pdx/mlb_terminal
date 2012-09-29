require 'date'
require 'nokogiri'

module MLBTerminal
  MLB_BASE_URL = 'http://gd2.mlb.com/components/game/mlb'

  class Client
    def self.list_games(date = Time.now.to_date)
      doc = Nokogiri::HTML(open "#{base_url_for_date date}/scoreboard_iphone.xml")
      doc.xpath("//games/game").map(&:attributes)
    end

    private

    def self.base_url_for_date(date = Time.now.to_date)
      "#{MLB_BASE_URL}/year_#{date.year}/month_#{"%02d" % date.month}/day_#{"%02d" % date.day}/"
    end
  end
end
