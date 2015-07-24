SELECT s.start, 
       t.short_name, 
       CASE WHEN gae.event_type = 'goal' THEN 1 ELSE 0 END AS goal,
       atan2(100-gae.start_x, 50-gae.start_y) * (180 / pi()) AS degree, 
       sqrt((100-gae.start_x)^2+(50-gae.start_y)^2) AS distance, 
       CASE WHEN gae.headed THEN 1 ELSE 0 END AS shot_headed, 
       CASE WHEN crosses.id IS NOT NULL THEN 1 ELSE 0 END AS crosses, 
       CASE WHEN corners.id IS NOT NULL THEN 1 ELSE 0 END AS corner, 
       CASE WHEN passes.throw_in THEN 1 ELSE 0 END AS pass_throw_in, 
       CASE WHEN passes.long_ball THEN 1 ELSE 0 END AS pass_long_ball, 
       CASE WHEN passes.through_ball THEN 1 ELSE 0 END AS pass_through_ball, 
       CASE WHEN passes.headed THEN 1 ELSE 0 END AS pass_headed
FROM sqw_goals_attempts_events gae
INNER JOIN sqw_teams t ON gae.sqw_team_id = t.id
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
LEFT JOIN LATERAL (SELECT * 
           FROM sqw_crosses_events c
           WHERE c.sqw_game_id = g.id
           AND c.minsec <= gae.minsec
           AND (gae.minsec - c.minsec) < 15
           ORDER BY c.created_at DESC
           LIMIT 1) crosses ON true
LEFT JOIN LATERAL (SELECT * 
           FROM sqw_corners_events c
           WHERE c.sqw_game_id = g.id
           AND c.minsec <= gae.minsec
           AND (gae.minsec - c.minsec) < 15
           ORDER BY c.created_at DESC
           LIMIT 1) corners ON true
LEFT JOIN LATERAL (SELECT * 
           FROM sqw_all_passes_events ap
           WHERE ap.sqw_game_id = g.id
           AND (ap.minsec = gae.minsec-1 OR 
                ap.minsec = gae.minsec-2 OR 
                ap.minsec = gae.minsec-3)
           ORDER BY ap.created_at DESC
           LIMIT 1) passes ON true
WHERE NOT ((gae.start_x >= 88.4 AND gae.start_x <= 88.6) AND (gae.start_y >= 49.8 AND gae.start_y <= 50.4))
AND s.start IN (2013, 2014)
AND gae.start_x >= 50