SELECT *, 'jotstar' AS platform
FROM jotstar_db.subscribers
UNION ALL
SELECT *, 'liocinema' AS platform
FROM liocinema_db.subscribers