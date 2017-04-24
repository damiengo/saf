/**
 * 2017/04/24
 * ----------
 * All passes + corners + crosses
 */

SELECT 
  * 
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
      pa.sqw_game_id, 
      pa.minsec
    FROM
      sqw_all_passes_events pa
    UNION
    SELECT 
      'corner' AS event_type, 
      co.sqw_game_id, 
      co.minsec
    FROM
      sqw_corners_events co
    UNION
    SELECT 
      'cross' AS event_type, 
      cr.sqw_game_id, 
      cr.minsec
    FROM
      sqw_crosses_events cr
  ) events
  ON g.id = events.sqw_game_id
ORDER BY
  events.minsec ASC