class Sqw

  def self.parse_xml_file(xml_file, season, tournament)
      #puts DateTime.now.strftime('%H:%M:%S') + ' - START'
      f = File.open(xml_file)
      doc = Nokogiri::XML(f)
      f.close

      # Teams
      home_team = nil
      away_team = nil
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Teams'
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
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Deleting datas'
      SqwGame.where(sqw_season_id: season.id, sqw_tournament_id: tournament.id, sqw_home_team_id: home_team.id, sqw_away_team_id: away_team.id).each do |one_game|
          SqwPlayerGame.where(sqw_game_id: one_game.id).destroy_all
          SqwPlayerSwap.where(sqw_game_id: one_game.id).destroy_all
          SqwGoalKeepingEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwGoalsAttemptsEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwHeadedDualsEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwAllPassesEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwCrossesEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwCornersEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwInterceptionsEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwTacklesEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwTakeonsEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwFoulsEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwOffsidesEvent.where(sqw_game_id: one_game.id).destroy_all
          SqwGoalPasslink.joins(:sqw_goals_attempts_event).where("sqw_goals_attempts_events.sqw_game_id = ?", one_game.id).destroy_all
          one_game.destroy
      end
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Game'
      game                = SqwGame.new
      game.sqw_season     = season
      game.sqw_tournament = tournament
      game.sqw_home_team  = home_team
      game.sqw_away_team  = away_team
      game.home_goals     = matched_result[1]
      game.away_goals     = matched_result[2]
      game.venue          = doc.css("data_panel game venue").text.strip
      game.kickoff        = Date.strptime(doc.css("data_panel game kickoff").text.strip, "%a, %d %b %Y %H:%M:%S")
      game.save

      # Players
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Players'
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
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Substitution'
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
      #puts DateTime.now.strftime('%H:%M:%S') + ' - GK'
      doc.css("data_panel filters goal_keeping event").each do |xml_gk_event|
          gk_player                  = SqwPlayer.find_by(sqw_id: xml_gk_event["player_id"])
          gk_team                    = SqwTeam.find_by(sqw_id: xml_gk_event["team_id"])
          locs                       = xml_gk_event.text.strip.match(/^(.*),(.*)$/)

          sqw_gk_event               = SqwGoalKeepingEvent.new
          sqw_gk_event.sqw_game_id   = game.id
          sqw_gk_event.sqw_player_id = gk_player.id
          sqw_gk_event.sqw_team_id   = gk_team.id
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
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Shots'
      doc.css("data_panel filters goals_attempts event").each do |xml_ga_event|
          ga_player                  = SqwPlayer.find_by(sqw_id: xml_ga_event["player_id"])
          ga_team                    = SqwTeam.find_by(sqw_id: xml_ga_event["team_id"])

          sqw_ga_event               = SqwGoalsAttemptsEvent.new
          sqw_ga_event.sqw_game_id   = game.id
          sqw_ga_event.sqw_player_id = ( not ga_player.nil?)? ga_player.id : nil
          sqw_ga_event.sqw_team_id   = ga_team.id
          sqw_ga_event.event_type    = xml_ga_event["type"]
          sqw_ga_event.action_type   = xml_ga_event["action_type"]
          sqw_ga_event.mins          = xml_ga_event["mins"]
          sqw_ga_event.secs          = xml_ga_event["secs"]
          sqw_ga_event.minsec        = xml_ga_event["minsec"]
          sqw_ga_event.headed = false
          if( ! xml_ga_event.css("headed")[0].nil?)
              sqw_ga_event.headed = true
          end
          # Coordinates
          if( ! xml_ga_event.css("coordinates")[0].nil?)
              sqw_ga_event.start_x       = xml_ga_event.css("coordinates")[0]["start_x"]
              sqw_ga_event.start_y       = xml_ga_event.css("coordinates")[0]["start_y"]
              sqw_ga_event.end_x         = xml_ga_event.css("coordinates")[0]["end_x"]
              sqw_ga_event.end_y         = xml_ga_event.css("coordinates")[0]["end_y"]
              sqw_ga_event.gmouth_y      = xml_ga_event.css("coordinates")[0]["gmouth_y"]
              sqw_ga_event.gmouth_z      = xml_ga_event.css("coordinates")[0]["gmouth_z"]
          end

          sqw_ga_event.save

          # Passlink
          if( ! xml_ga_event.css("passlinks")[0].nil?)
              json_passlink = JSON.parse(xml_ga_event.css("passlinks")[0])
              json_passlink.each do |pass|
                  sqw_goal_passlink = SqwGoalPasslink.new
                  sqw_goal_passlink.sqw_goals_attempts_event_id = sqw_ga_event.id
                  sqw_goal_passlink.type =                 (pass["type"].nil?)?                 "" : pass["type"].to_s
                  sqw_goal_passlink.sub_type =             (pass["sub_type"].nil?)?             "" : pass["sub_type"].to_s
                  sqw_goal_passlink.period =               (pass["period"].nil?)?               0  : pass["period"].to_i
                  sqw_goal_passlink.player_id =            (pass["player_id"].nil?)?            0  : pass["player_id"].to_i
                  sqw_goal_passlink.goal_min =             (pass["goal_min"].nil?)?             0  : pass["goal_min"].to_i
                  sqw_goal_passlink.start_x =              (pass["start_x"].nil?)?              0  : pass["start_x"].to_f
                  sqw_goal_passlink.start_y =              (pass["start_y"].nil?)?              0  : pass["start_y"].to_f
                  sqw_goal_passlink.is_own =               (pass["is_own"].nil?)?               false : pass["is_own"].to_i
                  sqw_goal_passlink.end_x =                (pass["end_x"].nil?)?                0  : pass["end_x"].to_f
                  sqw_goal_passlink.end_y =                (pass["end_y"].nil?)?                0  : pass["end_y"].to_f
                  #sqw_goal_passlink.gmouth_x =             (pass["gmouth_x"].nil?)?             0  : pass["gmouth_x"].to_f
                  #sqw_goal_passlink.gmouth_y =             (pass["gmouth_y"].nil?)?             0  : pass["gmouth_y"].to_f
                  #sqw_goal_passlink.gmouth_z =             (pass["gmouth_z"].nil?)?             0  : pass["gmouth_z"].to_f
                  sqw_goal_passlink.swere =                (pass["swere"].nil?)?                "" : pass["swere"]
                  sqw_goal_passlink.penalty_goal =         (pass["penalty_goal"].nil?)?         false : pass["penalty_goal"].to_i
                  sqw_goal_passlink.club_id =              (pass["club_id"].nil?)?              0 : pass["club_id"].to_i
                  sqw_goal_passlink.side =                 (pass["side"].nil?)?                 "" : pass["side"]
                  sqw_goal_passlink.min =                  (pass["min"].nil?)?                  0  : pass["min"].to_i
                  sqw_goal_passlink.sec =                  (pass["sec"].nil?)?                  0  : pass["sec"].to_i
                  sqw_goal_passlink.minsec =               (pass["minsec"].nil?)?               0  : pass["minsec"].to_i
                  sqw_goal_passlink.other_event_playerid = (pass["other_event_playerid"].nil?)? 0  : pass["other_event_playerid"].to_i
                  sqw_goal_passlink.headed =               (pass["headed"].nil?)?               false : pass["headed"].to_i
                  sqw_goal_passlink.reason =               (pass["reason"].nil?)?               "" : pass["reason"]
                  sqw_goal_passlink.foulcommitted_player = (pass["foulcommitted_player"].nil?)? "" : pass["foulcommitted_player"]
                  sqw_goal_passlink.foulsuffured_player =  (pass["foulsuffered_player"].nil?)?   "" : pass["foulsuffered_player"]

                  sqw_goal_passlink.save
              end
          end
      end

      # Headed dual event
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Headed'
      doc.css("data_panel filters headed_duals event").each do |xml_hd_event|
          hd_player                   = SqwPlayer.find_by(sqw_id: xml_hd_event["player_id"])
          hd_team                     = SqwTeam.find_by(sqw_id: xml_hd_event["team_id"])
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
          sqw_hd_event.sqw_team_id   = (not hd_team.nil?)? hd_team.id : nil
          sqw_hd_event.event_type    = xml_hd_event["type"]
          sqw_hd_event.action_type   = xml_hd_event["action_type"]
          sqw_hd_event.mins          = xml_hd_event["mins"]
          sqw_hd_event.secs          = xml_hd_event["secs"]
          sqw_hd_event.minsec        = xml_hd_event["minsec"]
          sqw_hd_event.loc_x         = locs[1]
          sqw_hd_event.loc_y         = locs[2]

          sqw_hd_event.save
      end

      # All passes events
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Passes'
      doc.css("data_panel filters all_passes event").each do |xml_ap_event|
          ga_player                  = SqwPlayer.find_by(sqw_id: xml_ap_event["player_id"])
          ga_team                    = SqwTeam.find_by(sqw_id: xml_ap_event["team_id"])

          start_pos = xml_ap_event.css("start")[0].text.strip.match(/^(.*),(.*)$/)
          end_pos   = xml_ap_event.css("end")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_ap_event               = SqwAllPassesEvent.new
          sqw_ap_event.sqw_game_id   = game.id
          sqw_ap_event.sqw_player_id = (not ga_player.nil?)? ga_player.id : nil
          sqw_ap_event.sqw_team_id   = (not ga_team.nil?)? ga_team.id : nil
          sqw_ap_event.start_x       = start_pos[1]
          sqw_ap_event.start_y       = start_pos[2]
          sqw_ap_event.end_x         = end_pos[1]
          sqw_ap_event.end_y         = end_pos[2]
          sqw_ap_event.pass_type     = xml_ap_event["type"]
          sqw_ap_event.mins          = xml_ap_event["mins"]
          sqw_ap_event.secs          = xml_ap_event["secs"]
          sqw_ap_event.minsec        = xml_ap_event["minsec"]
          sqw_ap_event.throw_in      = (xml_ap_event["throw_ins"] == "1")? true : false;
          sqw_ap_event.assist        = (not xml_ap_event.css("assists")[0].nil?)? true : false;
          sqw_ap_event.long_ball     = (not xml_ap_event.css("long_ball")[0].nil?)? true : false;
          sqw_ap_event.through_ball  = (not xml_ap_event.css("through_ball")[0].nil?)? true : false;
          sqw_ap_event.headed        = (not xml_ap_event.css("headed")[0].nil?)? true : false;

          sqw_ap_event.save
      end

      # Crosses events
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Crosses'
      doc.css("data_panel filters crosses event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event["team"])

          start_pos = xml_c_event.css("start")[0].text.strip.match(/^(.*),(.*)$/)
          end_pos   = xml_c_event.css("end")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_c_event               = SqwCrossesEvent.new
          sqw_c_event.sqw_game_id   = game.id
          sqw_c_event.sqw_player_id = ( not c_player.nil?)? c_player.id : nil
          sqw_c_event.sqw_team_id   = ( not c_team.nil?)? c_team.id : nil
          sqw_c_event.start_x       = start_pos[1]
          sqw_c_event.start_y       = start_pos[2]
          sqw_c_event.end_x         = end_pos[1]
          sqw_c_event.end_y         = end_pos[2]
          sqw_c_event.mins          = xml_c_event["mins"]
          sqw_c_event.secs          = xml_c_event["secs"]
          sqw_c_event.minsec        = xml_c_event["minsec"]
          sqw_c_event.event_type    = xml_c_event["type"]

          sqw_c_event.save
      end

      # Corners events
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Corners'
      doc.css("data_panel filters corners event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event["team"])

          start_pos = xml_c_event.css("start")[0].text.strip.match(/^(.*),(.*)$/)
          end_pos   = xml_c_event.css("end")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_c_event               = SqwCornersEvent.new
          sqw_c_event.sqw_game_id   = game.id
          sqw_c_event.sqw_player_id = ( not c_player.nil?)? c_player.id : nil
          sqw_c_event.sqw_team_id   = ( not c_team.nil?)? c_team.id : nil
          sqw_c_event.start_x       = start_pos[1]
          sqw_c_event.start_y       = start_pos[2]
          sqw_c_event.end_x         = end_pos[1]
          sqw_c_event.end_y         = end_pos[2]
          sqw_c_event.mins          = xml_c_event["mins"]
          sqw_c_event.secs          = xml_c_event["secs"]
          sqw_c_event.minsec        = xml_c_event["minsec"]
          sqw_c_event.event_type    = xml_c_event["type"]
          sqw_c_event.swere         = xml_c_event.css("swere").text

          sqw_c_event.save
      end

      # Interceptions
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Interceptions'
      doc.css("data_panel filters interceptions event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event["team_id"])

          loc = xml_c_event.css("loc")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_i_event               = SqwInterceptionsEvent.new
          sqw_i_event.sqw_game_id   = game.id
          sqw_i_event.sqw_player_id = ( not c_player.nil?)? c_player.id : nil
          sqw_i_event.sqw_team_id   = ( not c_team.nil?)? c_team.id : nil
          sqw_i_event.loc_x         = loc[1]
          sqw_i_event.loc_y         = loc[2]
          sqw_i_event.mins          = xml_c_event["mins"]
          sqw_i_event.secs          = xml_c_event["secs"]
          sqw_i_event.minsec        = xml_c_event["minsec"]
          sqw_i_event.action_type    = xml_c_event["action_type"]

          sqw_i_event.save
      end

      # Tackles
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Tackles'
      doc.css("data_panel filters tackles event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event.css("tackler")[0].text.strip)
          c_player_tackled          = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event.css("tackler_team")[0].text.strip)

          loc = xml_c_event.css("loc")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_i_event               = SqwTacklesEvent.new
          sqw_i_event.sqw_game_id   = game.id
          sqw_i_event.sqw_player_id = ( not c_player.nil?)? c_player.id : nil
          sqw_i_event.sqw_player_tackled_id = ( not c_player_tackled.nil?)? c_player_tackled.id : nil
          sqw_i_event.sqw_team_id   = ( not c_team.nil?)? c_team.id : nil
          sqw_i_event.loc_x         = loc[1]
          sqw_i_event.loc_y         = loc[2]
          sqw_i_event.mins          = xml_c_event["mins"]
          sqw_i_event.secs          = xml_c_event["secs"]
          sqw_i_event.minsec        = xml_c_event["minsec"]
          sqw_i_event.action_type   = xml_c_event["action_type"]
          sqw_i_event.event_type    = xml_c_event["type"]

          sqw_i_event.save
      end

      # Takeons
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Takeons'
      doc.css("data_panel filters takeons event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_other_player            = SqwPlayer.find_by(sqw_id: xml_c_event["other_player"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event.css("team_id")[0].text.strip)
          c_other_team              = SqwTeam.find_by(sqw_id: xml_c_event["other_team"])

          loc = xml_c_event.css("loc")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_i_event                     = SqwTakeonsEvent.new
          sqw_i_event.sqw_game_id         = game.id
          sqw_i_event.sqw_player_id       = ( not c_player.nil?)? c_player.id : nil
          sqw_i_event.sqw_other_player_id = ( not c_other_player.nil?)? c_other_player.id : nil
          sqw_i_event.sqw_team_id         = ( not c_team.nil?)? c_team.id : nil
          sqw_i_event.sqw_other_team_id   = ( not c_other_team.nil?)? c_other_team.id : nil
          sqw_i_event.loc_x               = loc[1]
          sqw_i_event.loc_y               = loc[2]
          sqw_i_event.mins                = xml_c_event["mins"]
          sqw_i_event.secs                = xml_c_event["secs"]
          sqw_i_event.minsec              = xml_c_event["minsec"]
          sqw_i_event.action_type         = xml_c_event["action_type"]
          sqw_i_event.event_type          = xml_c_event["type"]

          sqw_i_event.save
      end

      # Fouls
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Fouls'
      doc.css("data_panel filters fouls event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event["team"])
          c_other_player            = SqwPlayer.find_by(sqw_id: xml_c_event.css("otherplayer")[0].text.strip)
          c_other_team              = SqwTeam.find_by(sqw_id: xml_c_event.css("otherplayer")[0]["team"])

          loc = xml_c_event.css("loc")[0].text.strip.match(/^(.*),(.*)$/)

          sqw_i_event                     = SqwFoulsEvent.new
          sqw_i_event.sqw_game_id         = game.id
          sqw_i_event.sqw_player_id       = ( not c_player.nil?)? c_player.id : nil
          sqw_i_event.sqw_other_player_id = ( not c_other_player.nil?)? c_other_player.id : nil
          sqw_i_event.sqw_team_id         = ( not c_team.nil?)? c_team.id : nil
          sqw_i_event.sqw_other_team_id   = ( not c_other_team.nil?)? c_other_team.id : nil
          sqw_i_event.loc_x               = loc[1]
          sqw_i_event.loc_y               = loc[2]
          sqw_i_event.mins                = xml_c_event["mins"]
          sqw_i_event.secs                = xml_c_event["secs"]
          sqw_i_event.minsec              = xml_c_event["minsec"]

          sqw_i_event.save
      end

      # Offside
      #puts DateTime.now.strftime('%H:%M:%S') + ' - Offsides'
      doc.css("data_panel filters offside event").each do |xml_c_event|
          c_player                  = SqwPlayer.find_by(sqw_id: xml_c_event["player_id"])
          c_team                    = SqwTeam.find_by(sqw_id: xml_c_event["team"])

          sqw_i_event                     = SqwOffsidesEvent.new
          sqw_i_event.sqw_game_id         = game.id
          sqw_i_event.sqw_player_id       = ( not c_player.nil?)? c_player.id : nil
          sqw_i_event.sqw_team_id         = ( not c_team.nil?)? c_team.id : nil
          sqw_i_event.mins                = xml_c_event["mins"]
          sqw_i_event.secs                = xml_c_event["secs"]
          sqw_i_event.minsec              = xml_c_event["minsec"]

          sqw_i_event.save
      end

      #puts DateTime.now.strftime('%H:%M:%S') + ' - END'

      #puts doc.css("data_panel filters clearances")
      #puts doc.css("data_panel filters keepersweeper")
      #puts doc.css("data_panel filters oneonones")
      #puts doc.css("data_panel filters setpieces")
      #puts doc.css("data_panel filters cards")
      #puts doc.css("data_panel filters blocked_events")
      #puts doc.css("data_panel filters balls_out")
  end
end
