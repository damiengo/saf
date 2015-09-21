SELECT DISTINCT ON(gae.id) gae.id, cp.name AS cross_player, pp.name AS pass_player, sp.name AS shot_player, ap.id, ap.minsec, gae.minsec, gae.event_type, g.kickoff, ht.short_name, at.short_name, gae.mins, gae.secs
FROM sqw_goals_attempts_events gae
INNER JOIN sqw_games g ON gae.sqw_game_id = g.id
INNER JOIN sqw_teams ht ON g.sqw_home_team_id = ht.id
INNER JOIN sqw_teams at ON g.sqw_away_team_id = at.id
INNER JOIN sqw_seasons s ON g.sqw_season_id = s.id
INNER JOIN sqw_players sp ON gae.sqw_player_id = sp.id
INNER JOIN sqw_all_passes_events ap ON gae.sqw_game_id = ap.sqw_game_id AND ap.sqw_team_id = gae.sqw_team_id AND ap.pass_type = 'completed' AND ap.minsec < gae.minsec AND ap.minsec > gae.minsec-10
LEFT JOIN sqw_corners_events ce ON gae.sqw_game_id = ce.sqw_game_id AND ce.sqw_team_id = gae.sqw_team_id AND ce.minsec < gae.minsec AND ce.minsec > gae.minsec-10
INNER JOIN sqw_players pp ON ap.sqw_player_id = pp.id
LEFT JOIN sqw_players cp ON ce.sqw_player_id = cp.id
WHERE s.start = 2015
ORDER BY gae.id ASC, ap.minsec DESC
