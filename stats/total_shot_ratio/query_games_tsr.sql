SELECT g.id, 
       g.sqw_home_team_id, 
       g.sqw_away_team_id, 
       home.short_name, 
       away.short_name, 
       home.shots AS home_shots, 
       away.shots AS away_shots, 
       home.shots + away.shots AS total_shots, 
       ROUND((home.shots / (home.shots + away.shots)::float)::numeric, 2) AS home_tsr, 
       ROUND((away.shots / (home.shots + away.shots)::float)::numeric, 2) AS away_tsr, 
       g.home_goals,
       g.away_goals
FROM sqw_games g 
INNER JOIN 
(
	SELECT t.id AS sqw_team_id, t.short_name, gae.sqw_game_id AS sqw_game_id, COUNT(gae.*) AS shots
	FROM sqw_teams t
	INNER JOIN sqw_players p ON t.id = p.sqw_team_id
	INNER JOIN sqw_goals_attempts_events gae ON gae.sqw_player_id = p.id
	GROUP BY t.id, gae.sqw_game_id
) home ON g.sqw_home_team_id = home.sqw_team_id AND g.id = home.sqw_game_id
INNER JOIN 
(
	SELECT t.id AS sqw_team_id, t.short_name, gae.sqw_game_id AS sqw_game_id, COUNT(gae.*) AS shots
	FROM sqw_teams t
	INNER JOIN sqw_players p ON t.id = p.sqw_team_id
	INNER JOIN sqw_goals_attempts_events gae ON gae.sqw_player_id = p.id
	GROUP BY t.id, gae.sqw_game_id
) away ON g.sqw_away_team_id = away.sqw_team_id AND g.id = away.sqw_game_id
ORDER BY g.kickoff ASC