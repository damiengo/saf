SELECT p.name,
       SUM(CASE WHEN gae.event_type = 'save' THEN 1 
                WHEN gae.event_type = 'goal' THEN 1 
                ELSE 0 END) AS on_target, 
       COUNT(*) AS shots, 
       SUM(CASE WHEN gae.event_type = 'goal' THEN 1 ELSE 0 END) AS goals, 
       ROUND(
           (
               SUM(CASE WHEN gae.event_type = 'save' THEN 1 
                        WHEN gae.event_type = 'goal' THEN 1 
                        ELSE 0 END)::float / COUNT(*)::float
               )::numeric, 2
       ) AS sot_ratio
FROM sqw_players p 
INNER JOIN sqw_goals_attempts_events gae ON gae.sqw_player_id = p.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id AND s.start = 2014
GROUP BY p.name
HAVING COUNT(*) > 30
ORDER BY sot_ratio DESC