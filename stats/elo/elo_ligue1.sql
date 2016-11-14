SELECT e.team, CAST(e.elo AS int), CAST(e.elo AS int) - CAST(es.elo AS int) AS elo_start
FROM elo_ratings e
INNER JOIN elo_ratings es ON e.team = es.team AND es.date_of_update = '2016-08-01'
WHERE e.date_of_update = '2016-09-23'
AND e.country = 'FRA'
AND e.level = 1
ORDER BY e.elo DESC
