WITH users AS (
	SELECT 
		*,
        MONTH(subscription_date) AS sub_month_no,
		DATE_FORMAT(subscription_date, '%b') AS sub_month_name,
        MONTH(last_active_date) AS chrn_month_no,
		DATE_FORMAT(last_active_date, '%b') AS chrn_month_name
	FROM (
		SELECT *, 'jotstar' AS platform
		FROM jotstar_db.subscribers
		UNION ALL
		SELECT *, 'liocinema' AS platform
		FROM liocinema_db.subscribers) a
)
SELECT platform, age_group, city_tier, subscription_plan,
	SUM(CASE WHEN last_active_date IS NULL THEN 1 ELSE 0 END) AS active_users,
    SUM(CASE WHEN last_active_date IS NOT NULL THEN 1 ELSE 0 END) AS chrn_users,
    COUNT(user_id) AS total_users
FROM users
GROUP BY platform, age_group, city_tier, subscription_plan 