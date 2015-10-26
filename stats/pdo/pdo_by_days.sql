SELECT t.short_name, 
       g.kickoff, 
       COUNT(*) as day,
       (CASE 
           WHEN SUM(pdos.ht_on_target) = 0 THEN 0
           ELSE ROUND((SUM(pdos.ht_goals)/SUM(pdos.ht_on_target)) * 1000)::numeric
       END)
       +
       1000 - (CASE 
           WHEN SUM(pdos.at_on_target) = 0 THEN 0
           ELSE ROUND((SUM(pdos.at_goals)/SUM(pdos.at_on_target)) * 1000)::numeric
       END) AS pdo_int, 
       REPLACE(((CASE 
           WHEN SUM(pdos.ht_on_target) = 0 THEN 0
           ELSE ROUND((SUM(pdos.ht_goals)/SUM(pdos.ht_on_target)) * 1000)::numeric
       END)
       +
       1000 - (CASE 
           WHEN SUM(pdos.at_on_target) = 0 THEN 0
           ELSE ROUND((SUM(pdos.at_goals)/SUM(pdos.at_on_target)) * 1000)::numeric
       END))::text, ',', '') AS pdo
FROM sqw_teams t 
INNER JOIN sqw_games g ON (g.sqw_home_team_id = t.id OR g.sqw_away_team_id = t.id)
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id AND s.start = '2015'
INNER JOIN 
(
	SELECT t.short_name, 
	       t.id as team_id, 
	       games.game_id, 
	       games.kickoff, 
	       SUM(gae_ht.goals) as ht_goals, 
	       SUM(gae_ht.on_target) as ht_on_target, 
	       SUM(gae_at.goals) as at_goals, 
	       SUM(gae_at.on_target) as at_on_target, 
	       CASE WHEN SUM(gae_ht.on_target) = 0 THEN 0
	           ELSE ROUND((SUM(gae_ht.goals)/SUM(gae_ht.on_target)) * 1000)::numeric
	       END as sh_per,
	       CASE WHEN SUM(gae_at.on_target) = 0 THEN 0
	           ELSE ROUND((SUM(gae_at.goals)/SUM(gae_at.on_target)) * 1000)::numeric
	       END as sv_per,
	       CASE WHEN SUM(gae_ht.on_target) = 0 THEN 0
	           ELSE ROUND((SUM(gae_ht.goals)/SUM(gae_ht.on_target)) * 1000)::numeric
	       END
	       +
	       1-
	       CASE WHEN SUM(gae_at.on_target) = 0 THEN 0
	           ELSE ROUND((SUM(gae_at.goals)/SUM(gae_at.on_target)) * 1000)::numeric
	       END AS pdo
	FROM
	(
		SELECT ht.id AS ht_id, 
		       at.id AS at_id, 
		       g.id  AS game_id, 
		       g.kickoff
		FROM sqw_games g 
		INNER JOIN sqw_teams ht ON g.sqw_home_team_id = ht.id
		INNER JOIN sqw_teams at ON g.sqw_away_team_id = at.id
		INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id AND s.start = 2015
	) games
	INNER JOIN sqw_teams t ON (games.ht_id = t.id OR games.at_id = t.id)
	-- Current team shots
	INNER JOIN 
	(
	    SELECT gae.sqw_team_id as t_id, 
	           gae.sqw_game_id as g_id, 
		      SUM(CASE WHEN gae.event_type = 'goal' THEN 1 
		                ELSE 0 END) AS goals, 
		      SUM(CASE WHEN gae.event_type = 'save' THEN 1 
		               WHEN gae.event_type = 'goal' THEN 1 
	                    WHEN gae.event_type = 'blocked' THEN 1 
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
	                    WHEN gae.event_type = 'blocked' THEN 1 
		                ELSE 0 END) AS on_target
	    FROM sqw_goals_attempts_events gae
	    GROUP BY gae.sqw_team_id, gae.sqw_game_id
	) gae_at ON games.game_id = gae_at.g_id AND t.id != gae_at.t_id
	GROUP BY t.short_name, t.id, games.game_id, games.kickoff
	ORDER BY t.short_name ASC
) pdos ON t.id = pdos.team_id AND g.kickoff >= pdos.kickoff
GROUP BY t.short_name, g.kickoff
ORDER BY t.short_name ASC, g.kickoff ASC