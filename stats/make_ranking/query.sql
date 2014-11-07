TRUNCATE TABLE ranking3pts;
INSERT INTO ranking3pts (season_id, day, rank, team_id, points, wins, draws, losts, goals_for, goals_against, goals_diff)
SELECT s.id, 
       teams_day.day,
       0 as rank,
       t.id,
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
	) AS goals_against,
        SUM(
	       CASE
	       WHEN g.home_team_id = teams_day.team_id THEN g.home_goals-g.away_goals
	       ELSE g.away_goals-g.home_goals
	       END
	) AS goals_diff
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN
(
	SELECT t.id AS team_id, g.day, g.season_id
	FROM games g 
	INNER JOIN teams t ON (g.away_team_id = t.id OR g.home_team_id = t.id)
) teams_day ON (g.home_team_id = teams_day.team_id OR g.away_team_id = teams_day.team_id)
INNER JOIN teams t ON teams_day.team_id = t.id
-- WHERE s.start = 2013 
WHERE g.day <= teams_day.day
AND s.id = teams_day.season_id
GROUP BY s.id, teams_day.day, t.id
ORDER BY s.id ASC, teams_day.day ASC, points DESC, goals_diff DESC, goals_for DESC, t.name ASC
