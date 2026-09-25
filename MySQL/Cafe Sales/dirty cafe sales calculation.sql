select *
from practices.dirty_cafe_sales;

-- Summation Total
select sum(quantity) as quantity_total, sum(Total_spent) as spent_bruto
from practices.dirty_cafe_sales;

-- Average Revenue
select round(avg(total_spent),2) as average_spent
from practices.dirty_cafe_sales;

-- sales total based on items
select item, count(*) as order_total, sum(quantity) as quantity_total, 
sum(total_spent) as spent_total
from practices.dirty_cafe_sales
group by item;

-- selling performance based on date
select transaction_date, sum(quantity) as order_sold
from practices.dirty_cafe_sales
group by transaction_date
order by transaction_date asc;

-- selling market based on month
select month(transaction_date) as selling_month, sum(quantity) as order_sold,
round(avg(total_spent),2) as avg_spent_$
from practices.dirty_cafe_sales
where month(transaction_date) is not null
group by month(transaction_date)
order by selling_month asc;

-- favorite payment method
select payment_method, count(*) as amount
from practices.dirty_cafe_sales
where payment_method not in ('unknown', 'error', trim(''))
group by payment_method;

-- revenue total
select sum(quantity*price_per_unit) as revenue_total
from practices.dirty_cafe_sales;

-- item with biggest revenue amount
select item, sum(quantity*price_per_unit) as revenue
from practices.dirty_cafe_sales
group by item
order by revenue desc;

-- Take Away and In-Store Comparisson
select location, count(*) as amount
from practices.dirty_cafe_sales
where location not in ('unknown','error', trim(''))
group by location;

-- Revenue based on Each Month
select CASE
WHEN transaction_date = 'Uknown' or 
month(transaction_date) = 'error'or 
transaction_date IS NULL or 
transaction_date = trim(' ') 
then "Others" else month(transaction_date) end as transaction_month, 
sum(quantity*price_per_unit) as
revenue
from practices.dirty_cafe_sales
group by transaction_month
order by revenue desc; 

-- Shop Selling Total based on Date
select 
CASE 
	WHEN transaction_date = 'UNKNOWN' OR transaction_date = TRIM('') OR 
    transaction_date = 'ERROR' THEN 'Others'
    ELSE transaction_date END AS selling_date, 
count(*) as selling_count
from practices.dirty_cafe_sales 
group by transaction_date
order by selling_count desc;

-- total revenue above the average revenue based on item
select sum(quantity*price_per_unit) as revenue
from practices.dirty_cafe_sales;

select item, sum(quantity*price_per_unit) as revenue
from practices.dirty_cafe_sales
group by item
order by revenue desc;

select item, sum(quantity*price_per_unit) as revenue
from practices.dirty_cafe_sales
group by item;

with cte as (
select item, sum(quantity*price_per_unit) as revenue
from practices.dirty_cafe_sales
group by item)
select item, revenue, round(revenue/sum(revenue) over()*100,2) as revenue_percentage
from cte
group by item 
order by revenue_percentage desc;

select item, sum(price_per_unit*quantity) as revenue
from practices.dirty_cafe_sales
group by item;

with item_revenue as (
select item, sum(price_per_unit*quantity) as revenue
from practices.dirty_cafe_sales
group by item)

select item, revenue
from item_revenue
where revenue > (select avg(revenue)
from item_revenue)
order by revenue desc;

select *
from practices.dirty_cafe_sales;