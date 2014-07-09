SELECT home_victories.start, 
       home_victories.nb Home, 
       away_victories.nb Away, 
       draws.nb Draws, 
       games.nb Games, 
       round((home_victories.nb::float/games.nb::float)::numeric, 2) HomeAvg, 
       round((away_victories.nb::float/games.nb::float)::numeric, 2) AwayAvg, 
       round((draws.nb::float/games.nb::float)::numeric, 2) DrawAvg
FROM
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals > g.away_goals
  GROUP BY s.id
) AS home_victories, 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals < g.away_goals
  GROUP BY s.id
) AS away_victories, 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals = g.away_goals
  GROUP BY s.id
) AS draws, 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  GROUP BY s.id
) AS games
WHERE home_victories.id = away_victories.id
AND away_victories.id = draws.id
AND draws.id = games.id
ORDER BY home_victories.start ASC