SELECT p.first_name || ' - ' || p.last_name AS name, 
       COUNT(*) AS nb
FROM sqw_goals_attempts_events gae 
INNER JOIN sqw_players p ON gae.sqw_player_id = p.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
AND s.start = 2014
GROUP BY p.first_name || ' - ' || p.last_name
ORDER BY nb DESC