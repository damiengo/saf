SELECT first.start, 
       first.day, 
       first.home, 
       first.away, 
       first.home_goals AS first_t1, 
       first.away_goals AS first_t2, 
       second.away_goals AS second_t1, 
       second.home_goals AS second_t2, 
       first_team_rank.rank AS t1_rank, 
       second_team_rank.rank AS t2_rank, 
       CASE 
       WHEN first.home_goals > first.away_goals THEN 3
       WHEN first.home_goals = first.away_goals THEN 1
       WHEN first.home_goals < first.away_goals THEN 0
       END AS result_first_t1, 
       CASE 
       WHEN first.home_goals < first.away_goals THEN 3
       WHEN first.home_goals = first.away_goals THEN 1
       WHEN first.home_goals > first.away_goals THEN 0
       END AS result_first_t2, 
       CASE 
       WHEN second.home_goals < second.away_goals THEN 3
       WHEN second.home_goals = second.away_goals THEN 1
       WHEN second.home_goals > second.away_goals THEN 0
       END AS result_second_t1, 
       CASE 
       WHEN second.home_goals > second.away_goals THEN 3
       WHEN second.home_goals = second.away_goals THEN 1
       WHEN second.home_goals < second.away_goals THEN 0
       END AS result_second_t2, 
       CASE 
       WHEN first.home_goals > first.away_goals THEN 1.14
       WHEN first.home_goals = first.away_goals THEN 1
       WHEN first.home_goals < first.away_goals THEN 0.9
       END AS result_projection_second_t1, 
       CASE 
       WHEN first.home_goals < first.away_goals THEN 1.81
       WHEN first.home_goals = first.away_goals THEN 1.67
       WHEN first.home_goals > first.away_goals THEN 1.16
       END AS result_projection_second_t2
FROM
(
SELECT s.id AS season_id,  s.start, g.day, ht.id AS home_team_id, ht.name as home, at.id AS away_team_id, at.name as away, g.home_goals, g.away_goals
FROM games g 
INNER JOIN seasons s ON g.season_id = s.id AND s.start >= 2002
INNER JOIN teams ht ON g.home_team_id = ht.id
INNER JOIN teams at ON g.away_team_id = at.id
WHERE g.day <= 19
) first, 
(
SELECT s.id AS season_id, s.start, g.day, ht.id AS home_team_id, ht.name as home, at.name as away, g.home_goals, g.away_goals
FROM games g 
INNER JOIN seasons s ON g.season_id = s.id AND s.start >= 2002
INNER JOIN teams ht ON g.home_team_id = ht.id
INNER JOIN teams at ON g.away_team_id = at.id
WHERE g.day > 19
) second, 
(
SELECT r.season_id, r.day, r.team_id, r.rank
FROM ranking3pts r
WHERE r.day = 19
) first_team_rank, 
(
SELECT r.season_id, r.day, r.team_id, r.rank
FROM ranking3pts r
WHERE r.day = 19
) second_team_rank
WHERE first.start = second.start
AND first.home = second.away
AND first.away = second.home
AND first.season_id    = first_team_rank.season_id
AND first.home_team_id = first_team_rank.team_id
AND first.season_id    = second_team_rank.season_id
AND first.away_team_id = second_team_rank.team_id
ORDER BY first.start ASC, first.day ASC