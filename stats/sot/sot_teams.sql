SELECT t.short_name,
       SUM(CASE WHEN gae.event_type = 'save' THEN 1 
                WHEN gae.event_type = 'goal' THEN 1 
                ELSE 0 END) AS on_target, 
       COUNT(*) AS shots, 
       ROUND((SUM(CASE WHEN gae.event_type = 'save' THEN 1 
                WHEN gae.event_type = 'goal' THEN 1 
                ELSE 0 END)::float / COUNT(*)::float)::numeric, 2) AS percentage
FROM sqw_teams t
INNER JOIN sqw_goals_attempts_events gae ON gae.sqw_team_id = t.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id AND s.start = 2014
GROUP BY t.short_name
ORDER BY percentage DESC