SELECT t.short_name, 
       SUM(gae_ht.goals), 
       SUM(gae_ht.on_target), 
       ROUND((SUM(gae_ht.goals)/SUM(gae_ht.on_target) + 1-SUM(gae_at.goals)/SUM(gae_at.on_target)) * 1000)::numeric as pdo
FROM
(
	SELECT ht.id AS ht_id, 
	       at.id AS at_id, 
	       g.id  AS game_id
	FROM sqw_games g 
	INNER JOIN sqw_teams ht ON g.sqw_home_team_id = ht.id
	INNER JOIN sqw_teams at ON g.sqw_away_team_id = at.id
	INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id AND s.start = 2014
) games
INNER JOIN sqw_teams t ON games.ht_id = t.id OR games.at_id = t.id
-- Current team shots
INNER JOIN 
(
    SELECT gae.sqw_team_id as t_id, 
           gae.sqw_game_id as g_id, 
	      SUM(CASE WHEN gae.event_type = 'goal' THEN 1 
	                ELSE 0 END) AS goals, 
	      SUM(CASE WHEN gae.event_type = 'save' THEN 1 
	                WHEN gae.event_type = 'goal' THEN 1 
	                ELSE 0 END) AS on_target
    FROM sqw_goals_attempts_events gae
    GROUP BY gae.sqw_team_id, gae.sqw_game_id
) gae_ht ON games.game_id = gae_ht.g_id AND t.id = gae_ht.t_id
-- Other team shots
INNER JOIN 
(
    SELECT gae.sqw_team_id as t_id, 
           gae.sqw_game_id as g_id, 
	      SUM(CASE WHEN gae.event_type = 'goal' THEN 1 
	                ELSE 0 END) AS goals, 
	      SUM(CASE WHEN gae.event_type = 'save' THEN 1 
	                WHEN gae.event_type = 'goal' THEN 1 
	                ELSE 0 END) AS on_target
    FROM sqw_goals_attempts_events gae
    GROUP BY gae.sqw_team_id, gae.sqw_game_id
) gae_at ON games.game_id = gae_at.g_id AND t.id != gae_at.t_id
GROUP BY t.short_name 
ORDER BY t.short_name ASC