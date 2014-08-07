SELECT home_draws.start, home_draws.name, home_draws.nb+away_draws.nb
FROM
(
SELECT s.start, ht.name, COUNT(g.*) nb
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams  ht ON g.home_team_id = ht.id
WHERE home_goals = away_goals
GROUP BY s.start, ht.name
) home_draws,
(
SELECT s.start, at.name, COUNT(g.*) nb
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams  at ON g.away_team_id = at.id
WHERE home_goals = away_goals
GROUP BY s.start, at.name
) away_draws
WHERE home_draws.name = away_draws.name
AND home_draws.start = away_draws.start
ORDER BY home_draws.start ASC, home_draws.nb+away_draws.nb DESC