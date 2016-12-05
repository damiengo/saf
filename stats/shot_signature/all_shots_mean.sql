SELECT ROUND(sqrt((100-gae.start_x)^2+(50-gae.start_y)^2)) AS distance,
       COUNT(*) AS nb,
       SUM(CASE WHEN gae.headed = true THEN 1 ELSE 0 END) AS headed,
       SUM(CASE WHEN gae.event_type IN ('goal', 'save') THEN 1 ELSE 0 END) AS on_target,
       SUM(CASE WHEN gae.event_type IN ('goal') THEN 1 ELSE 0 END) AS goal
FROM sqw_goals_attempts_events gae
INNER JOIN sqw_players p ON gae.sqw_player_id = p.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
AND s.start = 2015
GROUP BY distance
ORDER BY distance ASC
