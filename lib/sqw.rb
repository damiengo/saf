class Sqw

  def self.parse_xml_file(xml_file, season, tournament)
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
      end

      # Game
      full_result = doc.css("data_panel system headline").text.strip
      matched_result = full_result.match(/.*([0-9]+)\ -\ ([0-9]+).*/)

      # Deleting existing game
      SqwGame.where(sqw_season_id: season.id, sqw_tournament_id: tournament.id, sqw_home_team_id: home_team.id, sqw_away_team_id: away_team.id).each do |one_game|
          SqwPlayerGame.where(sqw_game_id: one_game.id).destroy_all
          SqwPlayerSwap.where(sqw_game_id: one_game.id).destroy_all
          SqwGoalKeepingEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwGoalsAttemptsEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwHeadedDualsEvent.where(sqw_game_id: one_game.id).destroy_all
          one_game.destroy
      end
      game                = SqwGame.new
      game.sqw_season     = season
      game.sqw_tournament = tournament
      game.sqw_home_team  = home_team
      game.sqw_away_team  = away_team
      game.home_goals     = matched_result[1]
      game.away_goals     = matched_result[2]
      game.venue          = doc.css("data_panel game venue").text.strip
      game.kickoff        = doc.css("data_panel game kickoff").text.strip
      game.save

      # Players
      doc.css("data_panel players player").each do |xml_player|
          p_team = SqwTeam.find_by(sqw_id: xml_player["team_id"])
          # Base player
          player = SqwPlayer.find_by(sqw_id: xml_player["id"])
          if player.nil?
              player = SqwPlayer.new
              player.sqw_id      = xml_player["id"]
              player.sqw_team_id = p_team.id
              player.first_name  = xml_player.css("first_name").text.strip
              player.last_name   = xml_player.css("last_name").text.strip
              player.name        = xml_player.css("name").text.strip
              player.surname     = xml_player.css("surname").text.strip
              player.photo       = xml_player.css("photo").text.strip
              player.dob         = xml_player.css("dob").text.strip
              player.country     = xml_player.css("country").text.strip
              player.save
          end
          # Game player
          player_game = SqwPlayerGame.new
          player_game.sqw_player_id   = player.id
          player_game.sqw_game_id     = game.id
          player_game.position        = xml_player.css("position").text.strip
          player_game.weight          = xml_player.css("weight").text.strip
          player_game.height          = xml_player.css("height").text.strip
          player_game.shirt_num       = xml_player.css("shirt_num").text.strip
          player_game.total_influence = xml_player.css("total_influence").text.strip
          player_game.x_loc           = xml_player.css("x_loc").text.strip
          player_game.y_loc           = xml_player.css("y_loc").text.strip
          player_game.state           = xml_player.css("state").text.strip

          player_game.save
      end

      # Substitution
      doc.css("data_panel possession period time_slice swap_players").each do |xml_swap|
          swap_team          = SqwTeam.find_by(sqw_id: xml_swap["team_id"])
          swap_sub_to_player = SqwPlayer.find_by(sqw_id: xml_swap.css("sub_to_player")[0]["player_id"])
          swap_player_to_sub = SqwPlayer.find_by(sqw_id: xml_swap.css("player_to_sub")[0]["player_id"])

          player_swap                  = SqwPlayerSwap.new
          player_swap.sqw_game_id      = game.id
          player_swap.sqw_team_id      = swap_team.id
          if not swap_sub_to_player.nil?
              player_swap.sub_to_player_id = swap_sub_to_player.id
          end
          if not swap_player_to_sub.nil? 
              player_swap.player_to_sub_id = swap_player_to_sub.id 
          end
          player_swap.min              = xml_swap["min"]
          player_swap.minsec           = xml_swap["minsec"]

          player_swap.save
      end

      # Goal keeping event
      doc.css("data_panel filters goal_keeping event").each do |xml_gk_event|
          gk_player                  = SqwPlayer.find_by(sqw_id: xml_gk_event["player_id"])
          locs                       = xml_gk_event.text.strip.match(/^(.*),(.*)$/)

          sqw_gk_event               = SqwGoalKeepingEvent.new
          sqw_gk_event.sqw_game_id   = game.id
          sqw_gk_event.sqw_player_id = gk_player.id
          sqw_gk_event.event_type    = xml_gk_event["type"]
          sqw_gk_event.action_type   = xml_gk_event["action_type"]
          sqw_gk_event.mins          = xml_gk_event["mins"]
          sqw_gk_event.secs          = xml_gk_event["secs"]
          sqw_gk_event.minsec        = xml_gk_event["minsec"]
          sqw_gk_event.headed        = xml_gk_event["headed"]
          sqw_gk_event.loc_x         = locs[1]
          sqw_gk_event.loc_y         = locs[2]

          sqw_gk_event.save
      end

      # Goal attempts event
      doc.css("data_panel filters goals_attempts event").each do |xml_ga_event|
          ga_player                  = SqwPlayer.find_by(sqw_id: xml_ga_event["player_id"])

          sqw_ga_event               = SqwGoalsAttemptsEvent.new
          sqw_ga_event.sqw_game_id   = game.id
          sqw_ga_event.sqw_player_id = ga_player.id
          sqw_ga_event.event_type    = xml_ga_event["type"]
          sqw_ga_event.action_type   = xml_ga_event["action_type"]
          sqw_ga_event.mins          = xml_ga_event["mins"]
          sqw_ga_event.secs          = xml_ga_event["secs"]
          sqw_ga_event.minsec        = xml_ga_event["minsec"]
          sqw_ga_event.headed        = xml_ga_event["headed"]
          sqw_ga_event.start_x       = xml_ga_event.css("coordinates")[0]["start_x"]
          sqw_ga_event.start_y       = xml_ga_event.css("coordinates")[0]["start_y"]
          sqw_ga_event.end_x         = xml_ga_event.css("coordinates")[0]["end_x"]
          sqw_ga_event.end_y         = xml_ga_event.css("coordinates")[0]["end_y"]
          sqw_ga_event.gmouth_y      = xml_ga_event.css("coordinates")[0]["gmouth_y"]
          sqw_ga_event.gmouth_z      = xml_ga_event.css("coordinates")[0]["gmouth_z"]

          sqw_ga_event.save           
      end

      # Headed dual event
      doc.css("data_panel filters headed_duals event").each do |xml_hd_event|
          hd_player                   = SqwPlayer.find_by(sqw_id: xml_hd_event["player_id"])
          hd_other_player             = SqwPlayer.find_by(sqw_id: xml_hd_event.css("otherplayer")[0].text.strip)
          locs                        = xml_hd_event.css("loc")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_hd_event                = SqwHeadedDualsEvent.new
          sqw_hd_event.sqw_game_id    = game.id
          if not hd_player.nil?
              sqw_hd_event.sqw_player_id  = hd_player.id
          end
          if not hd_other_player.nil?
              sqw_hd_event.otherplayer_id = hd_other_player.id
          end
          sqw_hd_event.event_type    = xml_hd_event["type"]
          sqw_hd_event.action_type   = xml_hd_event["action_type"]
          sqw_hd_event.mins          = xml_hd_event["mins"]
          sqw_hd_event.secs          = xml_hd_event["secs"]
          sqw_hd_event.minsec        = xml_hd_event["minsec"]
          sqw_hd_event.loc_x         = locs[1]
          sqw_hd_event.loc_y         = locs[2]

          sqw_hd_event.save          
      end

      #puts doc.css("data_panel filters interceptions")
      #puts doc.css("data_panel filters clearances")
      #puts doc.css("data_panel filters all_passes")
      #puts doc.css("data_panel filters tackles")
      #puts doc.css("data_panel filters crosses")
      #puts doc.css("data_panel filters corners")
      #puts doc.css("data_panel filters offside")
      #puts doc.css("data_panel filters keepersweeper")
      #puts doc.css("data_panel filters oneonones")
      #puts doc.css("data_panel filters setpieces")
      #puts doc.css("data_panel filters takeons")
      #puts doc.css("data_panel filters fouls")
      #puts doc.css("data_panel filters cards")
      #puts doc.css("data_panel filters blocked_events")
      #puts doc.css("data_panel filters balls_out")
      #puts doc.css("data_panel filters balls_out")
  end
end