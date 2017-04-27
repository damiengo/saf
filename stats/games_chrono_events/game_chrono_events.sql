/**
 * 2017/04/24
 * ----------
 * All passes + corners + crosses
 *
 * 2017/04/25
 * ----------
 * Added shots + gk + headed duals
 */

SELECT 
  p.name, 
  events.*
FROM 
  sqw_games g 
INNER JOIN 
  sqw_seasons s 
  ON 
    g.sqw_season_id = s.id 
  AND 
    s.start = 2016
INNER JOIN 
  sqw_teams ht ON g.sqw_home_team_id = ht.id AND ht.short_name = 'Nantes'
INNER JOIN 
  sqw_teams at ON g.sqw_away_team_id = at.id AND at.short_name = 'Rennes'
INNER JOIN 
  (
    SELECT 
      'pass' AS event_type, 
      pa.pass_type AS event_type2, 
      pa.sqw_game_id, 
      pa.minsec, 
      pa.sqw_player_id
    FROM
      sqw_all_passes_events pa
    UNION
    SELECT 
      'corner' AS event_type, 
      co.event_type AS event_type2, 
      co.sqw_game_id, 
      co.minsec, 
      co.sqw_player_id
    FROM
      sqw_corners_events co
    UNION
    SELECT 
      'cross' AS event_type, 
      cr.event_type AS event_type2, 
      cr.sqw_game_id, 
      cr.minsec, 
      cr.sqw_player_id
    FROM
      sqw_crosses_events cr
    UNION
    SELECT
      'shot' AS event_type, 
      sh.event_type AS event_type2, 
      sh.sqw_game_id, 
      sh.minsec, 
      sh.sqw_player_id
    FROM
      sqw_goals_attempts_events sh
    UNION
    SELECT
      'gk' AS event_type, 
      gk.event_type AS event_type2, 
      gk.sqw_game_id, 
      gk.minsec, 
      gk.sqw_player_id
    FROM
      sqw_goal_keeping_events gk
    UNION
    SELECT
      'head_dual' AS event_type, 
      hd.action_type AS event_type2, 
      hd.sqw_game_id, 
      hd.minsec, 
      hd.sqw_player_id
    FROM
      sqw_headed_duals_events hd
  ) events
  ON g.id = events.sqw_game_id
INNER JOIN 
  sqw_players p 
  ON
    events.sqw_player_id = p.id
ORDER BY
  events.minsec ASC