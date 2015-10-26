SELECT g.kickoff::date, 
       g.venue, 
       ht.short_name AS home_team, 
       at.short_name AS away_team, 
       CONCAT(g.home_goals, ' - ', g.away_goals) AS score, 
       g.home_goals, 
       g.away_goals, 
       CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS result_1, 
       CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS result_N, 
       CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS result_2, 
       CASE WHEN home_goals > away_goals THEN 1 
            WHEN home_goals = away_goals THEN 2
            ELSE 3 END AS result,
       CAST(erh.elo AS integer) AS home_elo, 
       CAST(era.elo AS integer) AS away_elo, 
       ABS(CAST(erh.elo AS integer) - CAST(era.elo AS integer)::integer) AS elo_diff, 
       ROUND(ABS(CASE 
         WHEN home_goals > away_goals 
           THEN (1 -  1/(1+POWER(10, -(CAST(erh.elo AS integer) - CAST(era.elo AS integer)::integer)/400::float))) * 20
         WHEN home_goals = away_goals 
           THEN (0.5 -  1/(1+POWER(10, -(CAST(erh.elo AS integer) - CAST(era.elo AS integer)::integer)/400::float))) * 20
         WHEN home_goals < away_goals 
           THEN (0 -  1/(1+POWER(10, -(CAST(erh.elo AS integer) - CAST(era.elo AS integer)::integer)/400::float))) * 20
       END)::numeric, 1) AS elo_swap
FROM sqw_games g 
INNER JOIN sqw_teams ht ON g.sqw_home_team_id = ht.id
INNER JOIN sqw_teams at ON g.sqw_away_team_id = at.id
INNER JOIN team_names htn ON ht.short_name = htn.sqw
INNER JOIN team_names atn ON at.short_name = atn.sqw
INNER JOIN elo_ratings erh ON htn.elo = erh.team AND erh.date_of_update::date = (g.kickoff - interval '1 day')::date AND erh.country = 'FRA' AND erh.level = 1
INNER JOIN elo_ratings era ON atn.elo = era.team AND era.date_of_update::date = (g.kickoff - interval '1 day')::date AND era.country = 'FRA' AND era.level = 1
WHERE g.kickoff > '2012-08-01 00:00:00'
AND   g.kickoff < '2015-07-01 00:00:00'
ORDER BY g.kickoff ASC