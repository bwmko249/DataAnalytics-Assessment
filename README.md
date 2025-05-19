
# README

## SQL Interview Preparation: Query Approaches

### Table of Contents
1. [Question 1: Customer Plans & Deposits](#question-1-customer-plans--deposits)
2. [Question 2: Monthly Transaction Frequency](#question-2-monthly-transaction-frequency)
3. [Question 3: Plan Inactivity Analysis](#question-3-plan-inactivity-analysis)
4. [Question 4: Customer Lifetime Value Estimation](#question-4-customer-lifetime-value-estimation)

---

## Question 1: Customer Plans & Deposits

**Approach:**
- Use `users_customuser` as the primary table to list all customers.
- Calculate `savings_count`: A distinct count of regular savings plans (`is_regular_savings = 1`) by joining `plans_plan` with `savings_savingsaccount`.
- Calculate `investment_count`: similarly count fixed investment plans (`is_fixed_investment = 1`).
- **Summing Deposits:** aggregate total deposit amounts from `savings_savingsaccount.amount`, using `COALESCE` to handle nulls.
- **Filtering:** A `HAVING` clause was used to ensure each customer has at least one savings plan and one investment plan.

**Challenges:**
- Customers without deposits will yield null sums. The `COALESCE` or `LEFT JOIN` to include customers with zero deposits.

---

## Question 2: Monthly Transaction Frequency

**Approach:**
- **Monthly Aggregation:** A CTE (`monthly_transactions`) was used to count each user’s deposit count per month.
- **User Metrics:** in `user_metrics`, compute each user’s average monthly transactions and assign a frequency category via a `CASE` statement.
- **Summary:** Group by category was used to get `customer_count` and overall `avg_transactions_per_month`.

---

## Question 3: Plan Inactivity Analysis

**Approach:**
- **Select Base Table:** use `plans_plan` for all savings/investment plans.
- **Join Transactions:** A `LEFT JOIN` was used with `savings_savingsaccount` filtering on `confirmed_amount > 0` to include plans without deposits.
- **Type Classification:** `CASE` statement was used to map flag fields (`is_regular_savings`, `is_fixed_investment`) to human-readable plan types.
- **Last Activity:** the most recent transaction was retrieved with `MAX(s.created_on)` and calculate `inactivity_days` via `DATEDIFF`.
- **Active Plan Filters:** exclude deleted, archived, or achieved plans by checking their respective flag columns.
- **Inactivity Criteria:** `HAVING` was used to filter plans inactive over 365 days or with no transactions.
- **Ordering:** `inactivity_days` was sorted in descending order to prioritize the most inactive plans.

---

## Question 4: Customer Lifetime Value Estimation

**Approach:**
- **Customer Tenure:** The months since account creation were calculated using `TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE())`.
- **Transaction Volume:** The deposit records were counted with `COUNT(s.id)`.
- **Annualization:** Total transactions was divided by tenure (in months) multiplied by 12 to annualize frequency.
- **Profit Factor:** Annualized transaction frequency was multiplied by average `book_returns` to estimate CLV.
- **Filtering:** `HAVING` statement was used to exclude customers with zero or negative CLV.
