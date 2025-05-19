-- Estimate Customer Lifetime Value (CLV) based on transaction behavior
SELECT
  u.id AS customer_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  
-- Calculate how many months the customer has been active
  TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) AS tenure_months,
  COUNT(s.id) AS total_transactions,
  ROUND(
    (COUNT(s.id) / 
    GREATEST(TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()), 1)) * 12 * 
    COALESCE(AVG(s.book_returns), 0),
    2
  ) AS estimated_clv
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id

-- Group by customer details and creation date
GROUP BY u.id, u.first_name, u.last_name, u.created_on
HAVING estimated_clv > 0  -- Exclude customers with no transaction history
ORDER BY estimated_clv DESC;