SELECT s.start AS season, 
       SUM(g.home_goals+g.away_goals) AS goals, 
       COUNT(g.*) AS games, 
       ROUND((SUM(g.home_goals+g.away_goals)::float/COUNT(g.*)::float)::numeric, 2) AS average
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
GROUP BY s.start
ORDER BY s.start ASC;
