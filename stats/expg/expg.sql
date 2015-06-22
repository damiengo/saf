SELECT CASE WHEN gae.event_type = 'goal' THEN 1 ELSE 0 END AS goal,
       gae.mins, 
       gae.secs, 
       gae.start_x, 
       gae.start_y, 
       CASE WHEN gae.headed THEN 1 ELSE 0 END AS headed
FROM sqw_goals_attempts_events gae
