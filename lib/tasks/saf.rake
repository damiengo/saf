require 'nokogiri'
require 'open-uri'

namespace :saf do
  desc "Parse LFP"
  task parse_lfp: :environment do

    page = 1

    while page > 0
      first_page = Nokogiri::HTML(open("http://www.lfp.fr/ligue1/competitionPluginCalendrierResultat/changeCalendrierSaison?sai=16&jour=#{page}"), nil, "utf-8")

      puts "================ Day #{page} ================"
      first_page.css("table tr").each do |tr|
        home_team = tr.css(".domicile").text.strip
        away_team = tr.css(".exterieur").text.strip
        result    = tr.css(".stats").text.strip

        if( ! home_team.empty?)
          puts home_team + " - " + away_team + ": " + result
        end
      end

      next_page = first_page.css("a[name='journee_next']")[0]["href"][1..-1]

      page = next_page.to_i
    end

  end

end
