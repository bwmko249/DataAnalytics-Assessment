SELECT 
  p.id AS plan_id,
  p.owner_id,
  
-- To determine the type of plan based on criteria
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Regular Savings'
    WHEN p.is_fixed_investment = 1 THEN 'Fixed Investment'
    ELSE 'Other Plan Type'
  END AS type,
  MAX(s.created_on) AS last_transaction_date,
  
-- To Calculate the number of days since the last transaction
  DATEDIFF(CURRENT_DATE(), MAX(s.created_on)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
  ON p.id = s.plan_id 
  AND s.confirmed_amount > 0
WHERE
  -- Active account criteria 
  (p.is_deleted = 0 OR p.is_deleted IS NULL)
  AND (p.is_archived = 0 OR p.is_archived IS NULL)
  AND (p.is_goal_achieved = 0 OR p.is_goal_achieved IS NULL)
  AND (p.is_regular_savings = 1 OR p.is_fixed_investment = 1)
GROUP BY p.id, p.owner_id, type
HAVING 
  -- No valid transactions in last 365 days
  MAX(s.created_on) < CURRENT_DATE() - INTERVAL 365 DAY 
  OR MAX(s.created_on) IS NULL
ORDER BY inactivity_days DESC;