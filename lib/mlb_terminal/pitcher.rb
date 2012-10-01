require 'nokogiri'
require 'open-uri'

module MLBTerminal
  class Pitcher

    def self.list(gameday)
      base_url = MLBTerminal::Game.parse_gameday_id_to_url gameday
      doc = Nokogiri::HTML(open( "#{base_url}/players.xml"))
      Hash[doc.xpath("//game/team/player[@position='P']").map{|x| [x["id"], {:team => x.xpath("..").first["name"], :name => "#{x["first"]} #{x["last"]}"}]}]
    end

    def initialize(gameday, pitcher_id)
      @base_url = "#{MLBTerminal::Game.parse_gameday_id_to_url gameday}/premium/pitchers/#{pitcher_id}"
      pitcher = Pitcher.list(gameday)[pitcher_id]
      @team = pitcher[:team]
      @name = pitcher[:name]
    end

    def pitch_tendency_history(&block)
      doc = Nokogiri::HTML(open( "#{@base_url}/pitchtendencies_history.xml"))

      Enumerator.new do |y|
        doc.xpath("//pitchtendencies/games/game").each do |game|
          game.xpath("types/type").each do |type|
            y.yield({
              :pitcher_name => @name,
              :pitcher_team => @team,
              :gameday_id => game["id"],
              :pitch_count => game["num"],
              :avg_speed => game["vel"],
              :pitch_type => PITCH_TYPES[type["id"]],
              :pitch_number => type["num"],
              :movement => type["movement"],
              :pfx => type["pfx"],
              :vel => type["vel"],
              :avg_x0 => type["avg_x0"],
              :avg_z0 => type["avg_z0"] })
          end
        end
      end.each(&block)
    end
  end
end
