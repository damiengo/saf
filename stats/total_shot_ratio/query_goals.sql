SELECT p.id, p.name, max(pos.position) AS position, COUNT(*) AS nb_goals
FROM sqw_goals_attempts_events g 
INNER JOIN sqw_players p ON g.sqw_player_id = p.id
INNER JOIN 
(
    SELECT pg.sqw_player_id, max(pg.position) AS position
    FROM sqw_player_games pg
    GROUP BY pg.sqw_player_id
) pos ON p.id = pos.sqw_player_id
WHERE g.event_type = 'goal'
GROUP BY p.id
ORDER BY nb_goals DESC