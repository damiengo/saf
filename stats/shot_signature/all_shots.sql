SELECT s.start AS season,
       CONCAT(SUBSTRING(p.first_name FROM 1 FOR 1), '.', ' ', p.last_name) AS player_name,
       ROUND(sqrt((100-gae.start_x)^2+(50-gae.start_y)^2)) AS distance,
       COUNT(*) AS nb,
       SUM(CASE WHEN gae.headed = true THEN 1 ELSE 0 END) AS headed,
       SUM(CASE WHEN gae.event_type IN ('goal', 'save') THEN 1 ELSE 0 END) AS on_target,
       SUM(CASE WHEN gae.event_type IN ('goal') THEN 1 ELSE 0 END) AS goal
FROM sqw_goals_attempts_events gae
INNER JOIN sqw_players p ON gae.sqw_player_id = p.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
WHERE s.start = 2015
AND (ROUND(sqrt((100-gae.start_x)^2+(50-gae.start_y)^2))) < 51
GROUP BY s.start, player_name, distance
ORDER BY s.start ASC, player_name ASC, distance ASC
