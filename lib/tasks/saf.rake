require 'nokogiri'
require 'open-uri'
require 'csv'

namespace :saf do
  desc "Parse LFP"
  task parse_lfp: :environment do

    season_name = "1969-1970"
    season_id = 38
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
        home_result = result.split("-")[0]
        away_result = result.split("-")[1]

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

end
