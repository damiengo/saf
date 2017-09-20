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
  s.start,
  tn.country,
  tn.name,
  ht.short_name AS home_team_name,
  at.short_name AS away_team_name,
  t.short_name AS event_team_name,
  p.name AS event_player_name,
  events.*,
  g.id as sqw_game_id
FROM
  sqw_games g
INNER JOIN
  sqw_seasons s
  ON
    g.sqw_season_id = s.id
  AND
    s.start IN ({seasons})
INNER JOIN
  sqw_teams ht
  ON
    g.sqw_home_team_id = ht.id
INNER JOIN
  sqw_teams at
  ON
    g.sqw_away_team_id = at.id
INNER JOIN
  sqw_tournaments tn
  ON
    g.sqw_tournament_id = tn.id
INNER JOIN
  (
    SELECT
      'pass' AS event_type,
      3 as orderby,
      pa.pass_type AS event_type2,
      pa.assist AS assist,
      pa.long_ball AS long_ball,
      pa.through_ball AS through_ball,
      pa.headed AS headed,
      pa.sqw_game_id,
      pa.minsec,
      pa.sqw_player_id,
      pa.sqw_team_id,
      pa.start_x,
      pa.start_y ,
      pa.end_x,
      pa.end_y
    FROM
      sqw_all_passes_events pa
    UNION
    SELECT
      'corner' AS event_type,
      1 as orderby,
      co.event_type AS event_type2,
      CASE WHEN co.event_type = 'Assist' THEN true ELSE false END AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      co.sqw_game_id,
      co.minsec,
      co.sqw_player_id,
      co.sqw_team_id,
      co.start_x,
      co.start_y,
      co.end_x,
      co.end_y
    FROM
      sqw_corners_events co
    UNION
    SELECT
      'cross' AS event_type,
      2 as orderby,
      cr.event_type AS event_type2,
      CASE WHEN cr.event_type = 'Assist' THEN true ELSE false END AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      cr.sqw_game_id,
      cr.minsec,
      cr.sqw_player_id,
      cr.sqw_team_id,
      cr.start_x,
      cr.start_y,
      cr.end_x,
      cr.end_y
    FROM
      sqw_crosses_events cr
    UNION
    SELECT
      'shot' AS event_type,
      4 as orderby,
      sh.event_type AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      sh.headed AS headed,
      sh.sqw_game_id,
      sh.minsec,
      sh.sqw_player_id,
      sh.sqw_team_id,
      sh.start_x,
      sh.start_y,
      sh.end_x,
      sh.end_y
    FROM
      sqw_goals_attempts_events sh
    UNION
    SELECT
      'gk' AS event_type,
      5 as orderby,
      gk.event_type AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      gk.sqw_game_id,
      gk.minsec,
      gk.sqw_player_id,
      gk.sqw_team_id,
      gk.loc_x AS start_x,
      gk.loc_y AS start_y,
      NULL AS end_x,
      NULL AS end_y
    FROM
      sqw_goal_keeping_events gk
    /*UNION
    SELECT
      'head_dual' AS event_type,
      99 as orderby,
      hd.action_type AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      hd.sqw_game_id,
      hd.minsec,
      hd.sqw_player_id,
      hd.sqw_team_id,
      hd.loc_x AS start_x,
      hd.loc_y AS start_y,
      NULL AS end_x,
      NULL AS end_y
    FROM
      sqw_headed_duals_events hd*/
    UNION
    SELECT
      'tackle' AS event_type,
      10 as orderby,
      ta.action_type AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      ta.sqw_game_id,
      ta.minsec,
      ta.sqw_player_id,
      ta.sqw_team_id,
      ta.loc_x AS start_x,
      ta.loc_y AS start_y,
      NULL AS end_x,
      NULL AS end_y
    FROM
      sqw_tackles_events ta
    UNION
    SELECT
      'interception' AS event_type,
      11 as orderby,
      i.action_type AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      i.sqw_game_id,
      i.minsec,
      i.sqw_player_id,
      i.sqw_team_id,
      i.loc_x AS start_x,
      i.loc_y AS start_y,
      NULL AS end_x,
      NULL AS end_y
    FROM
      sqw_interceptions_events i
    UNION
    SELECT
      'foul' AS event_type,
      20 as orderby,
      '' AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      e.sqw_game_id,
      e.minsec,
      e.sqw_player_id,
      e.sqw_team_id,
      e.loc_x AS start_x,
      e.loc_y AS start_y,
      NULL AS end_x,
      NULL AS end_y
    FROM
      sqw_fouls_events e
    UNION
    SELECT
      'offside' AS event_type,
      30 as orderby,
      '' AS event_type2,
      false AS assist,
      false AS long_ball,
      false AS through_ball,
      false AS headed,
      e.sqw_game_id,
      e.minsec,
      e.sqw_player_id,
      e.sqw_team_id,
      NULL AS start_x,
      NULL AS start_y,
      NULL AS end_x,
      NULL AS end_y
    FROM
      sqw_offsides_events e
  ) events
  ON g.id = events.sqw_game_id
  AND
    events.minsec IS NOT NULL
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
