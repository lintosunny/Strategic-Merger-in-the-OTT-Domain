WITH content_mapped AS (
	SELECT a.user_id, a.device_type, a.total_watch_time_mins, a.platform, b.age_group, b.city_tier, b.subscription_plan
	FROM (
		SELECT *, 'jotstar' AS platform
		FROM jotstar_db.content_consumption
		UNION ALL
		SELECT *, 'liocinema' AS platform
		FROM liocinema_db.content_consumption) a
	LEFT JOIN (
		SELECT user_id, age_group, city_tier, subscription_plan, 'jotstar' AS platform
		FROM jotstar_db.subscribers
		UNION ALL
		SELECT user_id, age_group, city_tier, subscription_plan, 'liocinema' AS platform
		FROM liocinema_db.subscribers) b
		ON a.user_id = b.user_id
)

SELECT user_id, platform, age_group, city_tier, subscription_plan, ROUND(AVG(total_watch_time_mins)/60, 1) AS total_watch_time_hrs
FROM content_mapped
GROUP BY user_id, platform, age_group, city_tier, subscription_plan