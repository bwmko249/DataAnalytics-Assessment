-- Calculate monthly transaction counts for each user
    WITH monthly_transactions AS (
    SELECT
        u.id AS user_id,
        DATE_FORMAT(s.created_on, '%Y-%m') AS month_year,
        COUNT(*) AS transaction_count
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id -- Join users with their savings accounts
    WHERE s.confirmed_amount > 0
    GROUP BY u.id, DATE_FORMAT(s.created_on, '%Y-%m') -- Group by user and month
),
-- Calculate average transactions per user and categorize their frequency
user_metrics AS (
    SELECT
        user_id,
        AVG(transaction_count) AS avg_transactions_per_month,
        CASE 	 	-- Categorize user based on average transaction frequency
            WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transaction_count) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM monthly_transactions
    GROUP BY user_id
)
-- Aggregate and report the number of users in each frequency category
SELECT
    frequency_category,
    COUNT(user_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM user_metrics
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category -- Order results into High,  Medium, Low
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;