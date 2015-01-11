require 'nokogiri'
require 'open-uri'
require 'csv'
require 'capybara'
require 'capybara/poltergeist'

namespace :saf do

  # Calculate rank
  desc "Calculate ranking"
  task rank: :environment do
    cur_season = -1
    cur_day = -1
    cur_rank = 1
    ranks = Ranking3pts.order("season_id ASC, day ASC, points DESC, goals_diff DESC, goals_for DESC")
    ranks.each do |rank|
      if rank.day != cur_day || rank.season_id != cur_season
        cur_day = rank.day
        cur_season = rank.season_id
        cur_rank = 1
      end
      rank.rank = cur_rank
      rank.save
      puts "#{cur_season}/#{cur_day}: #{cur_rank} saved"
      cur_rank = cur_rank+1
    end
  end

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

  desc "Parse Sqwka"
  task parse_sqw: :environment do

      tournament = "24" # Ligue 1
      season = "2014"
      page = 1
      
      url = "http://www.squawka.com/match-results"
    
      include Capybara::DSL
      Capybara.default_driver = :poltergeist
      
      visit url
      # Choose championship
      select = page.find("#league-filter-list")
      select.find("option[value='24']").select_option
      sleep(2)
      # Choose season
      select = page.find("#league-season-list")
      select.find("option[value='#{season}']").select_option
      sleep(2)
      
      first_page_html = page.html

      while page < 1000 do
          puts "====> Page #{page}"
          first_page = Nokogiri::HTML(first_page_html, nil, "utf-8")
          # List games
          first_page.css(".match-centre a").each do |details|
              href = details.attr("href")
              puts "----"
              championship_name = href.match(/http:\/\/(.*)\.squawka.*/)[1]
              championship_name_cleaned = championship_name.gsub(/-/, "")
              puts championship_name_cleaned
              # Creates dir if not exists
              sqw_data = "data/squawka"
              Dir.mkdir(sqw_data) unless File.exists?(sqw_data)
              championship_dir = "#{sqw_data}/#{championship_name}"
              Dir.mkdir(championship_dir) unless File.exists?(championship_dir)
              season_dir = "#{championship_dir}/#{season}"
              Dir.mkdir(season_dir) unless File.exists?(season_dir)
              # Opening game
              game_page = Nokogiri::HTML(open(href), nil, "utf-8")
              game_page.inner_html.each_line do |line|
                  if /chatClient.roomID/.match(line)
                      id = line.match(/parseInt\(\'(.*)\'\)/)[1]
                      puts id
                      data_xml = "http://s3-irl-#{championship_name_cleaned}.squawka.com/dp/ingame/#{id}"
                      open("#{season_dir}/#{championship_name_cleaned}-#{id}.xml", 'wb') do |file|
                          begin
                              file << open(data_xml).read
                          rescue OpenURI::HTTPError => ex
                              puts "====> Error opening #{data_xml}"
                          end
                      end
                  end
              end
          end
      
          page.all(".pageing_text_arrow", :text => /.*Next.*/).first.click
          sleep(2)
          first_page_html = page.html
          page = page + 1
      end
      
  end
    
  desc "Analyse Sqwka"
  task analyse_sqw: :environment do
      
      # Season
      season_start = 2012
      season_end   = 2013
      season = SqwSeason.find_by(start: season_start, end: season_end)
      if season.nil?
        season = SqwSeason.new
        season.start = season_start
        season.end   = season_end
        season.save
      end
      
      # Tournament
      tournament_name    = "Ligue 1"
      tournament_country = "France"
      tournament = SqwTournament.find_by(name: tournament_name)
      if tournament.nil?
        tournament = SqwTournament.new
        tournament.name    = tournament_name
        tournament.country = tournament_country
        tournament.save
      end
      
      xml_file = "data/squawka/ligue-1/2014/ligue1-7729.xml"
      f = File.open(xml_file)
      doc = Nokogiri::XML(f)
      f.close
      
      # Teams
      home_team = nil
      away_team = nil
      doc.css("data_panel game team").each do |xml_team|
          sqw_id = xml_team["id"]
          team = SqwTeam.find_by(sqw_id: sqw_id)
          if team.nil?
              team            = SqwTeam.new
              team.sqw_id     = sqw_id
              team.long_name  = xml_team.css("long_name").text.strip
              team.short_name = xml_team.css("short_name").text.strip
              team.logo       = xml_team.css("logo").text.strip
              team.shirt_url  = xml_team.css("shirt_url").text.strip
              team.club_url   = xml_team.css("club_url").text.strip
              team.team_color = xml_team.css("team_color").text.strip
              team.save
          end
          # Home / Away
          if xml_team.css("state").text.strip == "home"
              home_team = team
          else
              away_team = team
          end
          puts xml_team
      end
      
  end

end
