SELECT CASE WHEN gae.event_type = 'goal' THEN 1 ELSE 0 END AS goal,
       gae.start_x, 
       gae.start_y, 
       CASE WHEN gae.headed THEN 1 ELSE 0 END AS headed/*,
       CASE WHEN gp.penalty_goal THEN 1 ELSE 0 END AS penalty*/
FROM sqw_goals_attempts_events gae
LEFT JOIN sqw_goal_passlinks gp ON gae.id = gp.sqw_goals_attempts_event_id 
      AND gp.type = 'goal' 
      AND (gp.penalty_goal IS NULL OR gp.penalty_goal = false)
