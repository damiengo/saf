SELECT CASE WHEN gae.event_type = 'goal' THEN 1 ELSE 0 END AS goal,
       gae.start_x, 
       gae.start_y, 
       CASE WHEN gae.headed THEN 1 ELSE 0 END AS headed/*,
       CASE WHEN gp.penalty_goal THEN 1 ELSE 0 END AS penalty*/
FROM sqw_goals_attempts_events gae
INNER JOIN sqw_teams t ON gae.sqw_team_id = t.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
LEFT JOIN sqw_goal_passlinks gp ON gae.id = gp.sqw_goals_attempts_event_id 
      AND gp.type = 'goal' 
-- WHERE (gp.penalty_goal IS NULL OR gp.penalty_goal = false)
-- WHERE (gp.penalty_goal IS NOT NULL AND gp.penalty_goal = true)
-- excluding pks
WHERE NOT ((gae.start_x >= 88.4 AND gae.start_x <= 88.6) AND (gae.start_y >= 49.8 AND gae.start_y <= 50.4))
AND s.start IN (2013, 2014)
