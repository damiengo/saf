SELECT s.start,
       t.id, 
       t.short_name,
       ROUND(AVG(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.home_tsr
                ELSE 
                    tsr.away_tsr
	          END
       )::numeric, 3) AS tsr_for,
       ROUND(AVG(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.away_tsr
                ELSE 
                    tsr.home_tsr
	          END
       )::numeric, 3) AS tsr_against,
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.home_goals
                ELSE 
                    tsr.away_goals
	          END
       ) AS goals_for,
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.away_goals
                ELSE 
                    tsr.home_goals
	          END
       ) AS goals_against,
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.home_goals-tsr.away_goals
                ELSE 
                    tsr.away_goals-tsr.home_goals
	          END
       ) AS goals_diff, 
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.home_shots
                ELSE 
                    tsr.away_shots
	          END
       ) AS shots_for, 
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.away_shots
                ELSE 
                    tsr.home_shots
	          END
       ) AS shots_against, 
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.home_points
                ELSE 
                    tsr.away_points
	          END
       ) AS points_for, 
       SUM(
           CASE WHEN tsr.sqw_home_team_id = t.id THEN
                    tsr.away_points
                ELSE 
                    tsr.home_points
	          END
       ) AS points_against
FROM
(
	SELECT g.id, 
	       g.sqw_home_team_id, 
	       g.sqw_away_team_id, 
	       home.short_name, 
	       away.short_name, 
	       home.shots AS home_shots, 
	       away.shots AS away_shots, 
	       home.shots + away.shots AS total_shots, 
	       ROUND((home.shots / (home.shots + away.shots)::float)::numeric, 3) AS home_tsr, 
	       ROUND((away.shots / (home.shots + away.shots)::float)::numeric, 3) AS away_tsr, 
	       g.home_goals,
	       g.away_goals, 
	       s.id AS season_id, 
	       CASE WHEN g.home_goals > g.away_goals THEN 3
	            WHEN g.home_goals = g.away_goals THEN 1
                 ELSE 
                    0
	            END AS home_points, 
	       CASE WHEN g.home_goals < g.away_goals THEN 3
	            WHEN g.home_goals = g.away_goals THEN 1
                 ELSE 
                    0
	            END AS away_points
	FROM sqw_games g 
	INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
	INNER JOIN sqw_tournaments t ON g.sqw_tournament_id = t.id AND t.name = 'Ligue 1'
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
) tsr
INNER JOIN sqw_teams t ON (tsr.sqw_home_team_id = t.id OR tsr.sqw_away_team_id = t.id)
INNER JOIN sqw_seasons s ON tsr.season_id = s.id
WHERE s.start < 2014
GROUP BY s.start, t.id
ORDER BY s.start ASC, tsr_for DESC