SELECT hn.start season_n, hnp1.start season_np1, hn.name, 
       hn.win+an.win n_win, hn.draw+an.draw n_draw, hn.lose+an.lose an_lose, 
       hnp1.win+anp1.win np1_win, hnp1.draw+anp1.draw np1_draw, hnp1.lose+anp1.lose np1_lose
FROM
(
SELECT s.start, 
       t.name, 
       SUM(CASE WHEN g.home_goals > g.away_goals THEN 1 ELSE 0 END) win, 
       SUM(CASE WHEN g.home_goals = g.away_goals THEN 1 ELSE 0 END) draw, 
       SUM(CASE WHEN g.home_goals < g.away_goals THEN 1 ELSE 0 END) lose
FROM games g
INNER JOIN seasons s   ON g.season_id = s.id
INNER JOIN teams t     ON g.home_team_id = t.id
GROUP BY s.start, t.name
ORDER BY s.start ASC, t.name ASC
) hn, 
(
SELECT s.start, 
       t.name, 
       SUM(CASE WHEN g.home_goals > g.away_goals THEN 1 ELSE 0 END) win, 
       SUM(CASE WHEN g.home_goals = g.away_goals THEN 1 ELSE 0 END) draw, 
       SUM(CASE WHEN g.home_goals < g.away_goals THEN 1 ELSE 0 END) lose
FROM games g
INNER JOIN seasons s   ON g.season_id = s.id
INNER JOIN teams t     ON g.home_team_id = t.id
GROUP BY s.start, t.name
ORDER BY s.start ASC, t.name ASC
) hnp1, 
(
SELECT s.start, 
       t.name, 
       SUM(CASE WHEN g.home_goals < g.away_goals THEN 1 ELSE 0 END) win, 
       SUM(CASE WHEN g.home_goals = g.away_goals THEN 1 ELSE 0 END) draw, 
       SUM(CASE WHEN g.home_goals > g.away_goals THEN 1 ELSE 0 END) lose
FROM games g
INNER JOIN seasons s   ON g.season_id = s.id
INNER JOIN teams t     ON g.away_team_id = t.id
GROUP BY s.start, t.name
ORDER BY s.start ASC, t.name ASC
) an, 
(
SELECT s.start, 
       t.name, 
       SUM(CASE WHEN g.home_goals < g.away_goals THEN 1 ELSE 0 END) win, 
       SUM(CASE WHEN g.home_goals = g.away_goals THEN 1 ELSE 0 END) draw, 
       SUM(CASE WHEN g.home_goals > g.away_goals THEN 1 ELSE 0 END) lose
FROM games g
INNER JOIN seasons s   ON g.season_id = s.id
INNER JOIN teams t     ON g.away_team_id = t.id
GROUP BY s.start, t.name
ORDER BY s.start ASC, t.name ASC
) anp1
WHERE hn.start = hnp1.start-1
AND hn.start = an.start
AND an.start = anp1.start-1
AND hn.name = hnp1.name
AND hn.name = an.name
AND an.name = anp1.name
