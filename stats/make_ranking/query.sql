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
