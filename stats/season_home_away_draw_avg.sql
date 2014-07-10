SELECT home_victories.start, 
       home_victories.nb Home, 
       away_victories.nb Away, 
       draws.nb Draws, 
       draws_first_quart.nb "Draws first quart",
       draws_second_quart.nb "Draws second quart",
       draws_third_quart.nb "Draws third quart",
       draws_fourth_quart.nb "Draws fourth quart",
       games.nb Games, 
       days.nb Days,
       round((home_victories.nb::float/games.nb::float)::numeric, 2) HomeAvg, 
       round((away_victories.nb::float/games.nb::float)::numeric, 2) AwayAvg, 
       round((draws.nb::float/games.nb::float)::numeric, 2) DrawAvg, 
       round((draws_first_quart.nb::float/draws.nb::float)::numeric, 2) "Draw First Quart Avg", 
       round((draws_second_quart.nb::float/draws.nb::float)::numeric, 2) "Draw Second Quart Avg", 
       round((draws_third_quart.nb::float/draws.nb::float)::numeric, 2) "Draw Third Quart Avg", 
       round((draws_fourth_quart.nb::float/draws.nb::float)::numeric, 2) "Draw Fourth Quart Avg"
FROM
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals > g.away_goals
  GROUP BY s.id
) AS home_victories 
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals < g.away_goals
  GROUP BY s.id
) AS away_victories ON home_victories.id = away_victories.id
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals = g.away_goals
  GROUP BY s.id
) AS draws ON home_victories.id = draws.id
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals = g.away_goals
  AND g.day <= 9
  GROUP BY s.id
) AS draws_first_quart ON home_victories.id = draws_first_quart.id
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals = g.away_goals
  AND g.day > 9
  AND g.day <= 19
  GROUP BY s.id
) AS draws_second_quart ON home_victories.id = draws_second_quart.id
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals = g.away_goals
  AND g.day > 19
  AND g.day <= 28
  GROUP BY s.id
) AS draws_third_quart ON home_victories.id = draws_third_quart.id
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  WHERE g.home_goals = g.away_goals
  AND g.day > 28
  GROUP BY s.id
) AS draws_fourth_quart ON home_victories.id = draws_fourth_quart.id
INNER JOIN 
(
  SELECT s.id, s.start, COUNT(*) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  GROUP BY s.id
) AS games ON home_victories.id = games.id
INNER JOIN 
(
  SELECT s.id, s.start, MAX(g.day) AS nb
  FROM games g
  INNER JOIN seasons s ON g.season_id = s.id
  GROUP BY s.id
) AS days ON home_victories.id = days.id
ORDER BY home_victories.start ASC