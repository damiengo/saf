SELECT CASE WHEN gae.event_type = 'goal' THEN 1 ELSE 0 END as goal,
       gae.event_type, 
       gae.mins, 
       gae.secs, 
       gae.start_x, 
       gae.start_y, 
       gae.headed
FROM sqw_goals_attempts_events gae
