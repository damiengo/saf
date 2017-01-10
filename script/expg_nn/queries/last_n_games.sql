SELECT
    g.id,
    g.kickoff,
    ht.id AS home_team_id,
    at.id AS away_team_id,
    ht.short_name AS home_team,
    at.short_name AS away_team,
    ht.team_color AS home_color,
    at.team_color AS away_color,
    g.home_goals,
    g.away_goals,
    COUNT(gaeh.*) AS home_p_goals,
    COUNT(gaea.*) AS away_p_goals
FROM
    sqw_games g
INNER JOIN
    sqw_teams ht ON g.sqw_home_team_id = ht.id
INNER JOIN
    sqw_teams at ON g.sqw_away_team_id = at.id
LEFT JOIN
    sqw_goals_attempts_events gaeh ON g.id = gaeh.sqw_game_id
AND
    ht.id = gaeh.sqw_team_id
AND
    ((gaeh.start_x >= 88.4 AND gaeh.start_x <= 88.6) AND (gaeh.start_y >= 49.8 AND gaeh.start_y <= 50.4))
LEFT JOIN
    sqw_goals_attempts_events gaea ON g.id = gaea.sqw_game_id
AND
    at.id = gaea.sqw_team_id
AND
    ((gaea.start_x >= 88.4 AND gaea.start_x <= 88.6) AND (gaea.start_y >= 49.8 AND gaea.start_y <= 50.4))
GROUP BY
    g.id, ht.id, at.id, ht.short_name, at.short_name, ht.team_color, at.team_color
ORDER BY
    g.kickoff DESC
LIMIT
    %s
;
