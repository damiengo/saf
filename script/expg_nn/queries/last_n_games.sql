SELECT
    g.id,
    g.kickoff,
    ht.short_name AS home_team,
    at.short_name AS away_team,
    ht.team_color AS home_color,
    at.team_color AS away_color
FROM
    sqw_games g
INNER JOIN
    sqw_teams ht ON g.sqw_home_team_id = ht.id
INNER JOIN
    sqw_teams at ON g.sqw_away_team_id = at.id
ORDER BY
    g.kickoff DESC
LIMIT
    %s
;
