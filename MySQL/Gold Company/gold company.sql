#What columns in dim products contains null values?
select product_key, product_id, product_number, product_name, category_id, category, 
subcategory, maintenance, cost, product_line, start_date
from gold.dim_products
where product_key IS NULL
OR product_id IS NULL
OR product_number IS NULL
OR product_name IS NULL
OR category_id IS NULL
OR category IS NULL
OR subcategory IS NULL
OR maintenance IS NULL
OR cost IS NULL
OR product_line IS NULL
OR start_date IS NULL;

#What columns in dim customers contains null values?
select customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, 
gender, birthdate, create_date
from gold.dim_customers
where  customer_key IS NULL
OR customer_id IS NULL
OR customer_number IS NULL
OR first_name IS NULL
OR last_name IS NULL
OR country IS NULL
OR marital_status IS NULL
OR gender IS NULL
OR birthdate IS NULL
OR create_date IS NULL;

#What type of category do exist?
select distinct category
from gold.dim_products;

#How's the products average price and total customers based on the category?
select category, round(avg(price),2) as average_price, count(customer_key) as total_customer
from gold.dim_products p
	join gold.fact_sales f
    on p.product_key = f.product_key
group by category
order by average_price desc;

#How much the product total in this company?
select distinct count(*) as product_total
from gold.dim_products;

#What type of the categories, sub categories, and the product?
select category, subcategory, product_name
from gold.dim_products
order by 1,2,3;

#Where are the customers come from?
select distinct country
from gold.dim_customers;

#How the unique customers and overall customers comparison?
select distinct count(*) as customer_total_distinct, count(customer_key) as customers_total
from gold.dim_customers;

#Date Register Detail
select 'Date Register' as detail , min(create_date) as start_date, 
max(create_date) as latest_date
from gold.dim_customers;

#What period does the company's data cover?
select 'create_timeline' as detail , min(create_date) as start_date,
max(create_date) as latest_date, datediff(max(create_date),min(create_date)) as 
gap
from gold.dim_customers
union
select 'shipping_timeline' as detail, min(shipping_date),
max(shipping_date),
datediff(max(shipping_date), min(shipping_date)) as gap
from gold.fact_sales
union
select 'starting_timeline' as detail, min(start_date), max(start_date),
datediff(max(start_date),min(start_date))
from gold.dim_products;

#What is the age distribution of the company's customers?
select min(birthdate) as the_oldest_customer, max(birthdate) as the_youngest_customer,
timestampdiff(year,min(birthdate),max(birthdate)) as gap
from gold.dim_customers
where birthdate is not null and birthdate <> '';

#How is the company order timeline? and determine the range!
select min(order_date) as first_date, max(order_date) as latest_date,
datediff(max(order_date),min(order_date)) as order_range
from gold.fact_sales
where order_date  <> '';

#Join Table dim products and Fact Sales
select *
from gold.fact_sales f
	left join gold.dim_products p
    on f.product_key = p.product_key;

#How much the profit per Products?
select product_name, cost, sales_amount, (sales_amount-cost) as profit,
round((sales_amount-cost)/cost,2) as profit_percentage
from gold.fact_sales f
	left join gold.dim_products p
    on f.product_key = p.product_key;

#How about the overall profit percentage average?
with cte as (
select product_name, cost, sales_amount, (sales_amount-cost) as profit,
round((sales_amount-cost)/cost,2) as profit_percentage
from gold.fact_sales f
	left join gold.dim_products p
    on f.product_key = p.product_key)
    
select round(avg(profit_percentage),2) as avg_profit_percentage,
sum(profit) as profit_total
from cte;
    
#What is the average revenue among all products?
select avg(sales_amount) as avg_revenue
from gold.fact_sales;

#What is the total sales across all items?
select 'amount' as 'details', sum(sales_amount) as total_sales
from gold.fact_sales;

#How many items are sold?
select sum(quantity) as item_sold
from gold.fact_sales;

#How much the date gap between order and shipping timeline?
#And how is the total customers ranking?
select order_date, shipping_date, datediff(shipping_date, order_date) as date_gap,
count(*) as total_orders, dense_rank() over (order by count(*) desc) as total_orders_ranking
from gold.fact_sales
group by order_date, shipping_date
order by total_orders_ranking asc
LIMIT 15;

#How is the table information?
select 'orders_total' as detail, count(order_number) as amount
from gold.fact_sales
union
select 'customers_total' as detail, count(customer_key) 
from gold.dim_customers
union 
select 'purchasing_customers' as detail, 
count(distinct customer_key) 
from gold.fact_sales
union
select 'total_products' as detail ,count(product_name) 
from gold.dim_products
union 
select 'cost_average' as detail, round(avg(cost),2)
from gold.dim_products;

#What is the customers life span and their purchasing average?
select lifespan, 
avg(total_sales)  as purchasing_average,
rank () over(order by avg(total_sales) desc) as purchasing_average_ranking
from gold.report_customers r
	left join gold.dim_customers c 
    on r.customer_key=c.customer_key
group by lifespan
order by lifespan asc;

#How are customers distributed across purchasing rankings?
select lifespan, count(customer_name) as total_customers, 
avg(total_sales)  as purchasing_average
from gold.report_customers
group by lifespan
order by purchasing_average desc
limit 5;

#How does average customer spending comparisson among membership classification?
select customer_segment, round(avg(total_sales),2) as sales_avg
from gold.report_customers
group by customer_segment
order by sales_avg desc;

select *
from gold.report_customers;

select *
from gold.dim_customers;

select *
from gold.report_customers r
	left join gold.dim_customers c 
    on r.customer_key=c.customer_key;
    
#What segments are consisted in customers?
select 'VIP' as detail, count(customer_segment) as amount
from gold.report_customers
where customer_segment LIKE 'VIP'
union
select 'New', count(customer_segment)
from gold.report_customers
where customer_segment = 'New'
union
select 'Regular', count(customer_segment)
from gold.report_customers
where customer_segment = 'Regular';

with cte as (
select 'VIP' as detail, count(customer_segment) as amount
from gold.report_customers
where customer_segment LIKE 'VIP'
union
select 'New', count(customer_segment)
from gold.report_customers
where customer_segment = 'New'
union
select 'Regular', count(customer_segment)
from gold.report_customers
where customer_segment = 'Regular')

select *
from cte
order by amount desc;

#Where are the customer country overall?
select country, count(*) as customer_total
from gold.dim_customers
group by country
order by customer_total desc;

#which the birth years account for the largest share customers?
select year(birthdate) as birth_year, age, count(*) as customer_total
from gold.dim_customers c
	JOIN gold.report_customers r
    on c.customer_key = r.customer_key
group by birth_year, age
order by customer_total desc
LIMIT 5;

#What is total revenue based on each customers?
select r.customer_key, customer_name, sum(sales_amount) as total_sales
from gold.fact_sales f
	join gold.report_customers r
    on f.customer_key = r.customer_key
group by r.customer_key, customer_name
order by total_sales desc
LIMIT 5;

#What is the distribution of sold items based on country?
select country, sum(quantity) as sold_items
from gold.dim_customers c
	join gold.fact_sales f
	on c.customer_key=f.customer_key
group by country
order by sold_items desc;

#What percentage of total revenue comes from each category?
select category, sum(sales_amount) as total_revenue
from gold.fact_sales f
	join gold.dim_products p
    on f.product_key = p.product_key
group by category
order by total_revenue desc;

with cte as (
select category,sum(sales_amount) as total_revenue
from gold.fact_sales f
	join gold.dim_products p
    on f.product_key = p.product_key
group by category),
cte2 as (
select sum(total_revenue) as revenue
from cte)

select *, round(total_revenue/revenue*100,2) as revenue_percentage
from cte c1
	cross join cte2 c2
order by revenue_percentage desc;

#What is the sold item based on the categories?
select category, sum(total_quantity) as sold_items,
sum(total_customers) as total_customers
from gold.report_products
group by category
order by sold_items desc;

#How is the total_cost numbers based on product categories?
select r.category, sum(f.cost) as total_cost
from gold.dim_products f
	join gold.report_products r
    on f.product_key = r.product_key
group by category
order by total_cost desc;
