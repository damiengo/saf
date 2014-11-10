SELECT t.name, 
       SUM(1) AS nb_games, 
       SUM(
       CASE WHEN g.home_goals > g.away_goals THEN 3 
            WHEN g.home_goals < g.away_goals THEN 0
            ELSE 1
       END
       ) AS points
FROM games g 
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN ranking3pts r ON g.away_team_id = r.team_id AND g.season_id = r.season_id AND r.day = r.days
INNER JOIN teams t ON g.away_team_id = t.id
INNER JOIN 
(
    SELECT r.team_id, r.season_id
    FROM ranking3pts r 
    WHERE r.day = r.days
    AND r.rank = 1
) leader ON g.home_team_id = leader.team_id AND s.id = leader.season_id
WHERE s.start >= 2002
GROUP BY t.id
ORDER BY nb_games DESC