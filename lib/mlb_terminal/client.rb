require 'date'
require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/integer/inflections'

module MLBTerminal
  MLB_BASE_URL = 'http://gd2.mlb.com/components/game/mlb'

  class Client
    def self.list_games(date = Time.now.to_date)
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
      @gameday = gameday
      year, month, day, game_name = /([0-9]{4})_([0-9]{2})_([0-9]{2})_(.*)/.match(@gameday).to_a.slice(1,4)
      @base_url = "#{Client.base_url_for_date(Date.new(year.to_i, month.to_i, day.to_i))}/gid_#{@gameday}"
    end

    def events(start_inning = 1, end_inning = 9, delay = 5, &block)
      current_inning = start_inning
      current_inning_loc= "top"

      innings = ["top", "bottom"]

      Enumerator.new do |y|
        while current_inning <= end_inning and not current_inning_loc.nil?
          doc = Nokogiri::HTML(open "#{@base_url}/game_events.xml")
          
          doc.xpath("//game/inning[@num >= #{current_inning}]").each do |inning|

            current_inning_loc ||= "top"

            innings.slice(innings.index(current_inning_loc), 2).each do |inning_loc|
              if inning.xpath(inning_loc).nil?
                break
              else
                inning.xpath("#{inning_loc}/atbat").each do |atbat|
                  y.yield({:inning => current_inning,
                   :num => atbat["num"],
                   :balls => atbat["b"],
                   :strikes => atbat["s"],
                   :outs => atbat["o"],
                   :time => Time.parse(atbat["start_tfs_zulu"], "%Y-%m-%dT%H:%M:%SZ"),
                   :desc => atbat["des"]})
                end
                         
                current_inning_loc = innings[innings.index(current_inning_loc) + 1]
              end
            end
            current_inning += 1
          end

          # If we had to break early, wait before trying again.
          if current_inning != end_inning and not current_inning_loc.nil?
            sleep delay
          end

        end
      end.each(&block)
    end

    def self.base_url_for_date(date = Time.now.to_date)
      "#{MLB_BASE_URL}/year_#{date.year}/month_#{"%02d" % date.month}/day_#{"%02d" % date.day}"
    end
  end
end
