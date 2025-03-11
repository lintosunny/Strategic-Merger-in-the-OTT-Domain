SELECT *, 'jotstar' AS platform
FROM jotstar_db.content_consumption
UNION ALL
SELECT *, 'liocinema' AS platform
FROM liocinema_db.content_consumption