WITH sub_details AS (
	SELECT
		*,
		MONTH(subscription_date) AS month_no,
		DATE_FORMAT(subscription_date, '%b') AS month_name,
		CONCAT(subscription_plan, " -> ", new_subscription_plan) AS plan_change_diag,
		CASE 
			WHEN last_active_date IS NULL THEN 'active'
			ELSE 'inactive'
		END AS is_active,
		CASE
			WHEN new_subscription_plan IS NULL THEN 'no_change'
			WHEN subscription_plan = 'Free' AND new_subscription_plan IS NOT NULL THEN 'upgrade'
			WHEN subscription_plan = 'Basic' AND new_subscription_plan IN ('Premium', 'VIP') THEN 'upgrade'
			WHEN subscription_plan = 'Basic' AND new_subscription_plan = 'Free' THEN 'downgrade'
			WHEN subscription_plan = 'VIP' AND new_subscription_plan IN ('Premium') THEN 'upgrade'
			WHEN subscription_plan = 'VIP' AND new_subscription_plan IN ('Basic', 'Free') THEN 'downgrade'
			WHEN subscription_plan = 'Premium' AND new_subscription_plan IS NOT NULL THEN 'downgrade'
			ELSE 'no_change'
		END AS subscription_change,
		CASE
			WHEN platform = 'jotstar' AND subscription_plan = 'VIP' THEN 159
			WHEN platform = 'jotstar' AND subscription_plan = 'Premium' THEN 359
			WHEN platform = 'liocinema' AND subscription_plan = 'Basic' THEN 69
			WHEN platform = 'liocinema' AND subscription_plan = 'Premium' THEN 129
			ELSE 0
		END AS subscription_price,
        CASE 
			WHEN platform = 'jotstar' AND subscription_plan IN ('VIP', 'Premium') THEN 'paid'
            WHEN platform = 'liocinema' AND subscription_plan IN ('Basic', 'Premium') THEN 'paid'
            ELSE 'free'
		END AS subscription_type
	FROM (
		SELECT *, 'jotstar' AS platform
		FROM jotstar_db.subscribers
		UNION ALL
		SELECT *, 'liocinema' AS platform
		FROM liocinema_db.subscribers) sub
)

SELECT *
FROM sub_details sd
LEFT JOIN (
	SELECT platform, user_id, ROUND(SUM(total_watch_time_mins)/60, 0) AS total_watch_time_hrs
		, ROUND(AVG(total_watch_time_mins)/60, 0) AS avg_watch_time_hrs
    FROM (
		SELECT *, 'jotstar' AS platform
		FROM jotstar_db.content_consumption
		UNION ALL
		SELECT *, 'liocinema' AS platform
		FROM liocinema_db.content_consumption) b
	GROUP BY platform, user_id) c
    ON c.platform = sd.platform
		AND c.user_id = sd.user_id
	
