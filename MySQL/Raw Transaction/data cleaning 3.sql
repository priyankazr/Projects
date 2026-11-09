SELECT *
FROM project.raw_transactions_final;

-- amount fixing
SELECT category ,year(transaction_date) as year_date,
replace(replace(amount,'$',''),'.','') as amount
FROM project.raw_transactions_final;

-- total amount calculation
WITH YEARLY AS (
SELECT category ,year(transaction_date) as year_date,
replace(replace(amount,'$',''),'.','') as amount
FROM project.raw_transactions_final)

SELECT category, year_date, SUM(amount) as total_amount
FROM YEARLY
group by category, year_date;

-- Data Cleaning Table
WITH YEARLY AS (
SELECT category, year(transaction_date) as year_transaction
, replace(replace(amount,'$',''),'.','') as amount
FROM project.raw_transactions_final),

YEAR_SPEND AS (
SELECT category, year_transaction, sum(amount) as total_amount
from yearly
group by category, year_transaction),

PREV_SPEND AS (
SELECT category, year_transaction, total_amount,
LAG(total_amount) over(partition by category order by year_transaction) as prev_spend
FROM YEAR_SPEND),

PERCENTAGE_SPEND AS (
SELECT category, year_transaction, total_amount, prev_spend,
round((total_amount-prev_spend)/prev_spend*100,2) as percentage_yearly_spend
FROM PREV_SPEND)

SELECT category, year_transaction, total_amount, prev_spend, percentage_yearly_spend,
round(avg(percentage_yearly_spend) over(partition by category
order by year_transaction),2) 
as avg_percentage_yearly_spend
FROM PERCENTAGE_SPEND;