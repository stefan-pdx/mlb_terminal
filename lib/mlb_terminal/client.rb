require 'date'
require 'nokogiri'
require 'open-uri'

module MLBTerminal
  MLB_BASE_URL = 'http://gd2.mlb.com/components/game/mlb'

  class Client
    def self.list_games(date = Time.now.to_date)
      doc = Nokogiri::HTML(open "#{base_url_for_date date}/scoreboard_iphone.xml")
      doc.xpath("//games/game").map{|game|
        {:home_team => {
            :name   => game["home_team_name"],
            :wins   => game["home_win"],
            :losses => game["home_loss"]},
         :away_team => {
            :name   => game["away_team_name"],
            :wins   => game["away_win"],
            :losses => game["away_loss"]},
         :score => {
          :home => (game.xpath("linescore/r").first["home"] rescue nil),
          :away => (game.xpath("linescore/r").first["away"] rescue nil)},
         :starts => "#{game["time"]} #{game["time_zone"]}",
         :status => game.xpath("status").first["ind"]}}
    end

    private

    def self.base_url_for_date(date = Time.now.to_date)
      "#{MLB_BASE_URL}/year_#{date.year}/month_#{"%02d" % date.month}/day_#{"%02d" % date.day}/"
    end
  end
end
