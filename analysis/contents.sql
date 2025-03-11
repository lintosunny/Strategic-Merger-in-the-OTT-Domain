SELECT *, 'jotstar' AS platform
FROM jotstar_db.contents
UNION ALL
SELECT *, 'liocinema' AS platform
FROM liocinema_db.contents