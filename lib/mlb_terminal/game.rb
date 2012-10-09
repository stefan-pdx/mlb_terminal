require 'date'
require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/integer/inflections'

module MLBTerminal

  class Game
    def self.list(date = Time.now.to_date)
      doc = Nokogiri::HTML(open "#{base_url_for_date date}/epg.xml")

      doc.xpath("//epg/game").map{|game|
        {:home_team => {
           :name   => game["home_team_name"],
           :wins   => game["home_win"],
           :losses => game["home_loss"]},
         :away_team => {
           :name   => game["away_team_name"],
           :wins   => game["away_win"],
           :losses => game["away_loss"]},
         :score => {
           :home => game["home_team_runs"],
           :away => game["away_team_runs"]},
         :starts => "#{game["time"]} #{game["time_zone"]}",
         :status => "#{game["status"]}" \
           "#{game["status"] == "In Progress" ? 
             ", #{game["top_inning"]=="Y" ? "Top" : "Bot"} of #{game["inning"].to_i.ordinalize}" :
             ""}",
         :game_id => game["gameday"]}}
    end

    def initialize(gameday)
      @base_url = Game.parse_gameday_id_to_url gameday
    end

    def events(delay = 2, &block)
      last_atbat = 0

      Enumerator.new do |y|
        begin
          doc = Nokogiri::HTML(open "#{@base_url}/game_events.xml")

          if doc.xpath("//game/inning/*/atbat").count == 0
            break
          end
          
          doc.xpath("//game/inning[*/atbat/@num > #{last_atbat}]").each do |inning|
            inning.xpath("*/atbat[@num > #{last_atbat}]").each do |at_bat|
              y.yield({
                :inning => inning["num"],
                :inning_loc => at_bat.xpath("..").first.name.camelcase,
                :num => at_bat["num"],
                :balls => at_bat["b"],
                :strikes => at_bat["s"],
                :outs => at_bat["o"],
                :time => Time.parse(at_bat["start_tfs_zulu"], "%Y-%m-%dT%H:%M:%SZ"),
                :desc => at_bat["des"].strip})
            end
          end

          last_atbat = doc.xpath("//game/inning/*/atbat/@num").map(&:value).map(&:to_i).max

          if game_status != "F"
            sleep delay
          end
        end while game_status != "F"
      end.each(&block)
    end

    def hits(delay = 2, &block)
      players = player_lookup
      next_hit = 0
      Enumerator.new do |y|
        begin
          doc = Nokogiri::HTML(open "#{@base_url}/inning/inning_hit.xml")
          doc.xpath("//hitchart/hip").slice(next_hit..-1).each do |hit|
            y.yield({
              :inning => hit["inning"],
              :inning_loc => (hit["team"]=="A" ? "Top" : "Bottom"),
              :batter => players[hit["batter"]],
              :pitcher => players[hit["pitcher"]],
              :type => hit["type"],
              :desc => hit["des"],
              :x => hit["x"].to_f,
              :y => hit["y"].to_f})
          end
          if game_status != "F"
            sleep delay
          end
          next_hit = doc.xpath("//hitchart/hip").count
        end while game_status != "F"
      end.each(&block)
    end

    def pitches(delay = 2, &block)
      last_pitch = 0
      players = player_lookup

      Enumerator.new do |y|
        begin
          doc = Nokogiri::HTML(open "#{@base_url}/inning/inning_all.xml")
          doc.xpath("//game/inning[*/*/pitch/@id > #{last_pitch}]").each do |inning|

            inning.xpath("*/atbat").each do |at_bat|
              pitcher = players[at_bat["pitcher"]]
              batter = players[at_bat["batter"]]

              at_bat.xpath("pitch").each do |pitch|
                y.yield({
                 :time => Time.parse(pitch["tfs_zulu"], "%Y-%m-%dT%H:%M:%SZ"),
                 :inning => inning["num"],
                 :inning_loc => at_bat.xpath("..").first.name.camelcase,
                 :pitcher => pitcher,
                 :batter => batter,
                 :type => pitch["type"],
                 :x => pitch["x"],
                 :y => pitch["y"],
                 :start_speed => pitch["start_speed"],
                 :end_speed => pitch["end_speed"],
                 :sz_top => pitch["sz_top"],
                 :sz_bot => pitch["sz_bot"],
                 :pfx_x => pitch["pfx_x"],
                 :pfx_z => pitch["pfx_z"],
                 :px => pitch["px"],
                 :pz => pitch["pz"],
                 :x0 => pitch["x0"],
                 :y0 => pitch["y0"],
                 :z0 => pitch["z0"],
                 :vx0 => pitch["vx0"],
                 :vy0 => pitch["vy0"],
                 :vz0 => pitch["vz0"],
                 :ax => pitch["ax"],
                 :ay => pitch["ay"],
                 :az => pitch["az"],
                 :break_y => pitch["break_y"],
                 :break_angle => pitch["break_angle"],
                 :break_length => pitch["break_length"],
                 :pitch_type => pitch["pitch_type"],
                 :type_confidence => pitch["type_confidence"],
                 :zone => pitch["zone"],
                 :nasty => pitch["nasty"],
                 :spin_dir => pitch["spin_dir"],
                 :spin_rate => pitch["spin_rate"],
                 :cc => pitch["cc"],
                 :mt => pitch["mt"]})
              end
            end
          end

          last_pitch = doc.xpath("//game/inning/*/*/pitch/@id").map(&:value).map(&:to_i).max

          if doc.xpath("//game").first["ind"] != "F"
            sleep delay
          end
        end while game_status != "F"
      end.each(&block)
    end

    def self.base_url_for_date(date = Time.now.to_date)
      "#{MLB_BASE_URL}/year_#{date.year}/month_#{"%02d" % date.month}/day_#{"%02d" % date.day}"
    end

    def self.parse_gameday_id_to_url(gameday)
      game_info = Game.parse_gameday_id gameday
      "#{Game.base_url_for_date(Date.new(game_info[:year].to_i, game_info[:month].to_i, game_info[:day].to_i))}/gid_" \
        "#{game_info[:year]}_" \
        "#{game_info[:month]}_" \
        "#{game_info[:day]}_" \
        "#{game_info[:away_team]}mlb_" \
        "#{game_info[:home_team]}mlb_" \
        "#{game_info[:game_number]}"
    end

    def self.parse_gameday_id(gameday)
      Hash[[:year, :month, :day, :away_team, :home_team, :game_number].zip(/[gid_]*([0-9]{4})_([0-9]{2})_([0-9]{2})_([a-z]{3})mlb_([a-z]{3})mlb_([0-9])/.match(gameday).to_a.slice(1,6))]
    end

    private

    def player_lookup
      doc = Nokogiri::HTML(open( "#{@base_url}/players.xml"))
      Hash[doc.xpath("//game/team/player").map{|x| [x["id"], "#{x["first"]} #{x["last"]}"]}]
    end

    def game_status
      doc = Nokogiri::HTML(open( "#{@base_url}/linescore.xml"))
      doc.xpath("//game").first["ind"]
    end
  end
end
