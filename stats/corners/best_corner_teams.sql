SELECT t.short_name AS team, COUNT(*) AS nb_goals
FROM sqw_goal_passlinks gp
INNER JOIN sqw_goals_attempts_events ga ON gp.sqw_goals_attempts_event_id = ga.id
INNER JOIN sqw_games g ON ga.sqw_game_id = g.id
INNER JOIN sqw_teams t ON ga.sqw_team_id = t.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id AND s.start = 2016
WHERE gp.sub_type = 'corner'
-- AND gp.type = 'assists_pass'
GROUP BY t.short_name
ORDER BY nb_goals DESC;