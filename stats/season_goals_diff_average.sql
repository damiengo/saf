SELECT s.start, ROUND((SUM(GREATEST(g.home_goals, g.away_goals)::float - LEAST(g.home_goals, g.away_goals)::float)/COUNT(g.*))::numeric, 2) AS diff_avg
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
GROUP BY s.start
ORDER BY s.start