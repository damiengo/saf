SELECT 
  l.name AS league, 
  m.season, 
  m.stage, 
  m.date, 
  ht.team_long_name AS 'home_team', 
  at.team_long_name AS 'away_team', 
  CASE
    WHEN m.home_team_goal > m.away_team_goal THEN '1'
    WHEN m.home_team_goal = m.away_team_goal THEN '2'
    WHEN m.home_team_goal < m.away_team_goal THEN '3'
	ELSE NULL 
  END AS 'result', 
  m.B365H, 
  m.B365D, 
  m.B365A, 
  1/(m.B365H*1.0) AS 'home_proba', 
  1/(m.B365D*1.0) AS 'draw_proba',
  1/(m.B365A*1.0) AS 'away_proba', 
  1/(m.B365H*1.0)+1/(m.B365D*1.0)+1/(m.B365A*1.0) AS 'sum_proba_b365', 
  CASE
    WHEN mm1.home_team_goal == m.home_team_api_id THEN
	    CASE 
	    WHEN mm1.home_team_goal > mm1.away_team_goal THEN '1'
        WHEN mm1.home_team_goal = mm1.away_team_goal THEN '2'
        WHEN mm1.home_team_goal < mm1.away_team_goal THEN '3'
	    ELSE NULL
		END
	ELSE 
	    CASE
	    WHEN mm1.home_team_goal < mm1.away_team_goal THEN '1'
        WHEN mm1.home_team_goal = mm1.away_team_goal THEN '2'
        WHEN mm1.home_team_goal > mm1.away_team_goal THEN '3'
	    ELSE NULL
	    END
  END AS 'mm1_home_result'
FROM 
  Match m
INNER JOIN
  Team ht ON m.home_team_api_id = ht.team_api_id
INNER JOIN
  Team at ON m.away_team_api_id = at.team_api_id
INNER JOIN
  League l ON m.league_id = l.id
LEFT JOIN 
  Match mm1 ON (m.home_team_api_id = mm1.home_team_api_id OR m.home_team_api_id = mm1.away_team_api_id)
  AND m.season = mm1.season
  AND m.stage = mm1.stage+1
ORDER BY
  m.season ASC, 
  m.stage ASC
;
