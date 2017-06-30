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

    season_name = "2014-2015"
    season_id = 83
    page = 1

    CSV.open("data/lfp/french-ligue1-#{season_name}.csv", "wb") do |csv|
      csv << ["day", "home_team", "away_team", "home_score", "away_score"]
      while page > 0
        first_page = Nokogiri::HTML(open("http://www.lfp.fr/ligue1/competitionPluginCalendrierResultat/changeCalendrierSaison?sai=#{season_id}&jour=#{page}"), nil, "utf-8")
        puts "================ Day #{page} ================"
        first_page.css("table tr").each do |tr|
          home_team   = tr.css(".domicile").text.strip
          away_team   = tr.css(".exterieur").text.strip
          result      = tr.css(".stats").text.strip

          if( ! home_team.empty?)
            home_result = result.split("-")[0].strip
            away_result = result.split("-")[1].strip
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

    #filter = "data/lfp/*"
    filter = "data/lfp/french-ligue1-2014-2015.*"

    Dir.glob(filter).each do |file|
      print file
      season_goals      = 0
      season_home_goals = 0
      season_away_goals = 0
      season_games      = 0
      season_diff       = 0
      season_start = file.to_s[23..26]
      season_end   = file.to_s[28..31]
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

      # 24 => Ligue 1, 8 => EPL, 22 => Bundesliga, 21 => Serie A, 23 => Liga, 9 => Eredivise
      tournament = "24"
      season = "2016"
      nb_page = 1

      url = "http://www.squawka.com/match-results"

      include Capybara::DSL
      Capybara.default_driver = :poltergeist

      visit url
      puts "----> #{page.current_url}"
      # Choose championship
      select = page.find("#league-filter-list")
      select.find("option[value='#{tournament}']").select_option
      puts page.find("#league-filter-list").value
      puts page.find("#league-season-list").value
      sleep(5)
      # Choose season
      select = page.find("#league-season-list")
      select.find("option[value='#{season}']").select_option
      sleep(5)
      puts page.find("#league-filter-list").value
      puts page.find("#league-season-list").value
      puts "----> #{page.current_url}"

      first_page_html = page.html

      while nb_page < 1000 do
          puts "====> Page #{nb_page}"
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
                      data_xml = "http://s3-irl-#{championship_name_cleaned}.squawka.com/dp/ingame/#{id}"
                      dest_file = "#{season_dir}/#{championship_name_cleaned}-#{id}.xml"
                      puts dest_file
                      if not File.exists?(dest_file)
                          open(dest_file, 'wb') do |file|
                              begin
                                  file << open(data_xml).read
                              rescue OpenURI::HTTPError => ex
                                  puts "====> Error opening #{data_xml}"
                              end
                          end
                      end
                  end
              end
          end

          next_page = page.all(".pageing_text_arrow", :text => /.*Next.*/)
          if next_page.length > 0
              next_page.first.click
          else
              # Quit
              nb_page = 9999
          end
          sleep(4)
          first_page_html = page.html
          nb_page = nb_page + 1
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

      #xml_file = "data/squawka/ligue-1/2014/ligue1-7729.xml"
      #Sqw::parse_xml_file(xml_file, season, tournament)

      files = Dir.glob("data/squawka/ligue-1/#{season_start}/*").sort
      files.each do |xml_file|
          puts DateTime.now.strftime('%H:%M:%S') + ' - ' + xml_file
          Sqw::parse_xml_file(xml_file, season, tournament)
      end

  end

  desc "Test analyse Sqwka"
  task test_analyse_sqw: :environment do

    season = SqwSeason.find_by(start: 2014, end: 2015)
    tournament = SqwTournament.find_by(name: "Ligue 1")

    xml_file = "data/squawka/ligue-1/2014/ligue1-7729.xml"
    puts DateTime.now.strftime('%H:%M:%S') + ' - ' + xml_file
    Sqw::parse_xml_file(xml_file, season, tournament)
  end

  desc "Update ELO"
  task update_elo: :environment do
    puts "======== Start updating ELO ========"

    last_update = EloRating.maximum("date_of_update")
    now = Date.today

    # If no date found
    if not last_update
      last_update = Date.new(1959, 12, 31)
    end

    # Set current date
    current_update = last_update + 1.day

    while current_update <= now

      url = URI.parse("http://api.clubelo.com/#{current_update.to_s(:db)}")
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }

      CSV.parse(res.body, :headers => true) do |row|
        date_of_update = current_update
        team    = row[1]
        country = row[2]
        level   = row[3]
        elo     = row[4]
        from    = row[5]
        to      = row[6]
        if team
          puts "#{date_of_update.to_s(:db)} #{team} (#{country}): #{elo} from #{from} to #{to}"
          # Delete old elo rating if exists
          #old_elo = EloRating.find_by(team: team, country: country, date_of_update: date_of_update)
          #if old_elo
            #old_elo.destroy
          #end
          # Save new
          elo_rating                = EloRating.new
          elo_rating.team           = team
          elo_rating.country        = country
          elo_rating.level          = level
          elo_rating.elo            = elo
          elo_rating.from           = from
          elo_rating.to             = to
          elo_rating.date_of_update = current_update
          elo_rating.save
        end
      end

      current_update = current_update + 1.day

    end

    puts "======== End updating ELO ========"
  end

end
