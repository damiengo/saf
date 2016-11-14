
SELECT passes.*, crosses.*
FROM
(
	SELECT g.sqw_season_id, pe.* 
	FROM sqw_games g
	INNER JOIN sqw_all_passes_events pe ON g.id = pe.sqw_game_id
) passes
INNER JOIN  
(
	SELECT ce.* 
	FROM sqw_crosses_events ce
) crosses ON passes.sqw_game_id = crosses.sqw_game_id
INNER JOIN sqw_seasons s ON passes.sqw_season_id = s.id AND s.start = 2016
WHERE passes.sqw_game_id = 11777;

SELECT * FROM pg_catalog.pg_tables;