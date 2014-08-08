SELECT g.day, ht.id, ht.name, g.home_goals, g.away_goals, at.id, at.name,
       CASE 
           WHEN ht.id = 31 THEN
               CASE WHEN g.home_goals > g.away_goals THEN 'G'
                    WHEN g.home_goals < g.away_goals THEN 'P'
                    ELSE 'N'
               END
           WHEN at.id = 31 THEN
               CASE WHEN g.home_goals < g.away_goals THEN 'G'
                    WHEN g.home_goals > g.away_goals THEN 'P'
                    ELSE 'N'
               END
       END
FROM games g
INNER JOIN seasons s ON g.season_id = s.id
INNER JOIN teams ht ON g.home_team_id = ht.id
INNER JOIN teams at ON g.away_team_id = at.id
WHERE s.start = '2013'
AND (ht.id = 31 OR at.id = 31)
ORDER BY g.day DESC