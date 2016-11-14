SELECT home_day1.start,
       home_day1.day,
       home_day1.name,
       (home_day1.result+home_day2.result)::float/2 AS home_avg,
       (away_day1.result+away_day2.result)::float/2 AS away_avg
FROM
(
SELECT s.start,
       t.id,
       t.name,
       g.day,
       CASE
       WHEN g.home_goals > g.away_goals THEN 3
       WHEN g.home_goals = g.away_goals THEN 1
       WHEN g.home_goals < g.away_goals THEN 0
       END AS result
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams t ON g.home_team_id = t.id
) home_day1,
(
SELECT s.start,
       t.id,
       t.name,
       g.day,
       CASE
       WHEN g.home_goals > g.away_goals THEN 3
       WHEN g.home_goals = g.away_goals THEN 1
       WHEN g.home_goals < g.away_goals THEN 0
       END AS result
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams t ON g.home_team_id = t.id
) home_day2,
(
SELECT s.start,
       t.id,
       t.name,
       g.day,
       CASE
       WHEN g.home_goals > g.away_goals THEN 0
       WHEN g.home_goals = g.away_goals THEN 1
       WHEN g.home_goals < g.away_goals THEN 3
       END AS result
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams t ON g.away_team_id = t.id
) away_day1,
(
SELECT s.start,
       t.id,
       t.name,
       g.day,
       CASE
       WHEN g.home_goals > g.away_goals THEN 0
       WHEN g.home_goals = g.away_goals THEN 1
       WHEN g.home_goals < g.away_goals THEN 3
       END AS result
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams t ON g.away_team_id = t.id
) away_day2
WHERE home_day1.start = home_day2.start
AND home_day1.id = home_day2.id
AND home_day1.day+1 = home_day2.day
AND home_day1.id = away_day1.id
AND home_day1.start = away_day1.start
AND away_day1.start = away_day2.start
AND away_day1.id    = away_day2.id
AND away_day1.day+1 = away_day2.day
ORDER BY home_day1.start ASC, home_day1.day ASC
