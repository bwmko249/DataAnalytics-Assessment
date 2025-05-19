SELECT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  -- A subquery to count distinct savings plans linked to the user
  (SELECT COUNT(DISTINCT p.id)
   FROM plans_plan p
   INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
   WHERE p.owner_id = u.id AND p.is_regular_savings = 1) AS savings_count,
   
   -- A Subquery to ount distinct investment plans linked to the user
  (SELECT COUNT(DISTINCT p.id)
   FROM plans_plan p
   INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
   WHERE p.owner_id = u.id AND p.is_fixed_investment = 1) AS investment_count,
  COALESCE(SUM(savings.amount), 0) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_savingsaccount savings ON u.id = savings.owner_id
GROUP BY u.id, u.first_name, u.last_name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;