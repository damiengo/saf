SELECT s.start, 
       teams_day.day,
       t.name,
       SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.team_id THEN
		   CASE 
		       WHEN g.home_goals > g.away_goals THEN 3
		       WHEN g.home_goals = g.away_goals THEN 1
		       WHEN g.home_goals < g.away_goals THEN 0
		   END
	       ELSE
		   CASE 
		       WHEN g.home_goals > g.away_goals THEN 0
		       WHEN g.home_goals = g.away_goals THEN 1
		       WHEN g.home_goals < g.away_goals THEN 3
		   END
		END
	) AS points,
        SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.team_id THEN
		   CASE 
		       WHEN g.home_goals > g.away_goals THEN 1
		       ELSE 0
		   END
	       ELSE
		   CASE 
		       WHEN g.home_goals < g.away_goals THEN 1
		       ELSE 0
		   END
		END
	) AS wins,
        SUM(
	       CASE
	       WHEN g.home_goals = g.away_goals THEN 1
	       ELSE 0		   
	       END
	) AS draws,
        SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.team_id THEN
		   CASE 
		       WHEN g.home_goals < g.away_goals THEN 1
		       ELSE 0
		   END
	       ELSE
		   CASE 
		       WHEN g.home_goals > g.away_goals THEN 1
		       ELSE 0
		   END
		END
	) AS losts,
        SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.team_id THEN g.home_goals
	       ELSE g.away_goals
	       END
	) AS goals_for,
        SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.team_id THEN g.away_goals
	       ELSE g.home_goals
	       END
	) AS goals_against
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN
(
	SELECT DISTINCT g.home_team_id AS team_id, g.day
	FROM games g 
	INNER JOIN seasons s ON g.season_id = s.id
	WHERE s.start = 2013
	UNION
	SELECT DISTINCT g.away_team_id AS team_id, g.day
	FROM games g 
	INNER JOIN seasons s ON g.season_id = s.id
	WHERE s.start = 2013
) teams_day ON (g.home_team_id = teams_day.team_id OR g.away_team_id = teams_day.team_id)
INNER JOIN teams t ON teams_day.team_id = t.id
WHERE s.start = 2013 
AND g.day <= teams_day.day
GROUP BY s.start, teams_day.day, t.name
ORDER BY s.start ASC, teams_day.day ASC, points DESC