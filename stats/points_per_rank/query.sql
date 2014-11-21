SELECT s.start, t.name, final_rank.rank as final_rank, r.day, r.rank as day_rank
FROM
-- Team final rank
(
    SELECT r.season_id, r.team_id, r.rank 
    FROM ranking3pts r 
    INNER JOIN seasons s ON r.season_id = s.id
    WHERE s.start > 2002
    AND r.day = 38
) final_rank
INNER JOIN ranking3pts r ON final_rank.season_id = r.season_id 
                        AND final_rank.team_id = r.team_id
INNER JOIN seasons s ON final_rank.season_id = s.id
INNER JOIN teams t ON final_rank.team_id = t.id
ORDER BY s.start ASC, final_rank.rank ASC, r.day ASC