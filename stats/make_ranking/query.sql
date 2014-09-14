SELECT * 
FROM
(
SELECT DISTINCT g.home_team_id, g.day
FROM games g 
INNER JOIN seasons s ON g.season_id = s.id
WHERE s.start = 2013
ORDER BY g.day ASC
) teams_days


SELECT SUM(
       CASE
       WHEN g.home_team_id = 30 THEN
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
        END)
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
WHERE s.start = 2013
AND (g.home_team_id = 30 OR g.away_team_id = 30)
AND g.day <= 8


SELECT s.start, 
       teams_day.day,
       t.name,
       SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.home_team_id THEN
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
	)
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN
(
	SELECT DISTINCT g.home_team_id, g.day
	FROM games g 
	INNER JOIN seasons s ON g.season_id = s.id
	WHERE s.start = 2013
	ORDER BY g.day ASC
) teams_day ON (g.home_team_id = teams_day.home_team_id OR g.away_team_id = teams_day.home_team_id)
INNER JOIN teams t ON teams_day.home_team_id = t.id
WHERE s.start = 2013 
AND g.day <= teams_day.day
GROUP BY s.start, teams_day.day, t.name
ORDER BY s.start, teams_day.day
