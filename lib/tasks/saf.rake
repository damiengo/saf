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

    Dir.glob("data/*").each do |file|
      season_goals = 0
      season_games = 0
      CSV.foreach(file.to_s, {headers: true}) do |row|
        home_goals = row[3].strip.to_i
        away_goals = row[4].strip.to_i
        season_goals = season_goals + home_goals + away_goals
        season_games = season_games + 1
      end
      season_start = file.to_s[19..22]
      season_end   = file.to_s[24..27]
      season_ratio = (season_goals.to_f/season_games.to_f * 100).round.to_f / 100.0
      #puts "#{season_start};#{season_end};#{season_goals};#{season_games};#{season_ratio}"
      puts "[#{season_start}, #{season_ratio}], "
    end

  end

end
