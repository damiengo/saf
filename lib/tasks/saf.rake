require 'nokogiri'
require 'open-uri'
require 'csv'

namespace :saf do

  desc "Parse LFP"
  task parse_lfp: :environment do

    season_name = "2013-2014"
    season_id = 82
    page = 1

    CSV.open("data/french-ligue1-#{season_name}.csv", "wb") do |csv|
      csv << ["day", "home_team", "away_team", "home_score", "away_score"]
      while page > 0
        first_page = Nokogiri::HTML(open("http://www.lfp.fr/ligue1/competitionPluginCalendrierResultat/changeCalendrierSaison?sai=#{season_id}&jour=#{page}"), nil, "utf-8")
        puts "================ Day #{page} ================"
        first_page.css("table tr").each do |tr|
          home_team   = tr.css(".domicile").text.strip
          away_team   = tr.css(".exterieur").text.strip
          result      = tr.css(".stats").text.strip
          home_result = result.split("-")[0].strip
          away_result = result.split("-")[1].strip

          if( ! home_team.empty?)
            puts home_team + " - " + away_team + ": " + result
            csv << [page, home_team, away_team, home_result, away_result]
          end
        end
        next_page = first_page.css("a[name='journee_next']")[0]["href"][1..-1]
        page = next_page.to_i
      end
    end
  end

  desc "Calculate goals"
  task goals: :environment do

    ligue1_model = Tournament.find(1)

    Dir.glob("data/*").each do |file|
      season_goals      = 0
      season_home_goals = 0
      season_away_goals = 0
      season_games      = 0
      season_diff       = 0
      season_start = file.to_s[19..22]
      season_end   = file.to_s[24..27]
      # Save season
      season_model = Season.find_by(start: season_start, end: season_end)
      if season_model.nil?
        season_model = Season.new
        season_model.start = season_start
        season_model.end   = season_end
        season_model.save
      end
      CSV.foreach(file.to_s, {headers: true}) do |row|
        day             = row[0].strip.to_i
        home_team_name  = row[1].strip
        away_team_name  = row[2].strip
        home_goals      = row[3].strip.to_i
        away_goals      = row[4].strip.to_i
        # Save home team
        home_team_model = Team.find_by(name: home_team_name)
        if home_team_model.nil?
          home_team_model = Team.new
          home_team_model.name = home_team_name
          home_team_model.save
        end
        # Save away team
        away_team_model = Team.find_by(name: away_team_name)
        if away_team_model.nil?
          away_team_model = Team.new
          away_team_model.name = away_team_name
          away_team_model.save
        end
        # Saving games
        game = Game.new
        game.tournament = ligue1_model
        game.season     = season_model
        game.home_team  = home_team_model
        game.away_team  = away_team_model
        game.home_goals = home_goals
        game.away_goals = away_goals
        game.day        = day
        game.save
        #season_goals      = season_goals + home_goals + away_goals
        #season_home_goals = season_home_goals + home_goals
        #season_away_goals = season_away_goals + away_goals
        #season_games      = season_games + 1
        #season_diff       = season_diff + (home_goals - away_goals).abs
      end
      #season_goals_ratio      = (season_goals.to_f/season_games.to_f * 100).round.to_f / 100.0
      #season_home_goals_ratio = (season_home_goals.to_f/season_games.to_f * 100).round.to_f / 100.0
      #season_away_goals_ratio = (season_away_goals.to_f/season_games.to_f * 100).round.to_f / 100.0
      #season_diff_ratio       = (season_diff.to_f/season_games.to_f * 100).round.to_f / 100.0
      #puts "#{season_start};#{season_end};#{season_goals};#{season_games};#{season_goals_ratio}"
      #puts "[#{season_start}, #{season_away_goals_ratio}], "
    end

  end

end
