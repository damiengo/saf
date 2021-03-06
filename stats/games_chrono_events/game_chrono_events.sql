﻿/**
 * 2017/04/24
 * ----------
 * All passes + corners + crosses
 *
 * 2017/04/25
 * ----------
 * Added shots + gk + headed duals
 */

SELECT 
  t.short_name, 
  p.name, 
  events.*, 
  g.id as sqw_game_id
FROM 
  sqw_games g 
INNER JOIN 
  sqw_seasons s 
  ON 
    g.sqw_season_id = s.id 
  AND 
    s.start = 2016
INNER JOIN 
  (
    SELECT 
      'pass' AS event_type, 
      3 as orderby, 
      pa.pass_type AS event_type2, 
      pa.sqw_game_id, 
      pa.minsec, 
      pa.sqw_player_id, 
      pa.sqw_team_id
    FROM
      sqw_all_passes_events pa
    UNION
    SELECT 
      'corner' AS event_type, 
      1 as orderby, 
      co.event_type AS event_type2, 
      co.sqw_game_id, 
      co.minsec, 
      co.sqw_player_id, 
      co.sqw_team_id
    FROM
      sqw_corners_events co
    UNION
    SELECT 
      'cross' AS event_type, 
      2 as orderby, 
      cr.event_type AS event_type2, 
      cr.sqw_game_id, 
      cr.minsec, 
      cr.sqw_player_id, 
      cr.sqw_team_id
    FROM
      sqw_crosses_events cr
    UNION
    SELECT
      'shot' AS event_type, 
      4 as orderby, 
      sh.event_type AS event_type2, 
      sh.sqw_game_id, 
      sh.minsec, 
      sh.sqw_player_id, 
      sh.sqw_team_id
    FROM
      sqw_goals_attempts_events sh
    UNION
    SELECT
      'gk' AS event_type, 
      5 as orderby, 
      gk.event_type AS event_type2, 
      gk.sqw_game_id, 
      gk.minsec, 
      gk.sqw_player_id, 
      gk.sqw_team_id
    FROM
      sqw_goal_keeping_events gk
    UNION
    SELECT
      'head_dual' AS event_type, 
      99 as orderby, 
      hd.action_type AS event_type2, 
      hd.sqw_game_id, 
      hd.minsec, 
      hd.sqw_player_id, 
      hd.sqw_team_id
    FROM
      sqw_headed_duals_events hd
    UNION
    SELECT
      'tackle' AS event_type, 
      99 as orderby, 
      ta.action_type AS event_type2, 
      ta.sqw_game_id, 
      ta.minsec, 
      ta.sqw_player_id, 
      ta.sqw_team_id
    FROM
      sqw_tackles_events ta
    UNION
    SELECT
      'interception' AS event_type, 
      99 as orderby, 
      i.action_type AS event_type2, 
      i.sqw_game_id, 
      i.minsec, 
      i.sqw_player_id, 
      i.sqw_team_id
    FROM
      sqw_interceptions_events i
  ) events
  ON g.id = events.sqw_game_id
INNER JOIN 
  sqw_players p 
  ON
    events.sqw_player_id = p.id
INNER JOIN 
  sqw_teams t ON events.sqw_team_id = t.id
ORDER BY
  g.id ASC, 
  events.minsec ASC, 
  events.orderby ASC