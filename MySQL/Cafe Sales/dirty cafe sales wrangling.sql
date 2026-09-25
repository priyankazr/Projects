select *
from practices.dirty_cafe_sales;

-- Data Amount
select count(*) as data_total
from practices.dirty_cafe_sales;

-- Data Unique
select distinct(item)
from practices.dirty_cafe_sales;

-- Delete null and error rows
select distinct(item)
from practices.dirty_cafe_sales
where item in ('UNKNOWN','ERROR')
or item is null or trim(item) = '';

DELETE from practices.dirty_cafe_sales
where item in ('UNKNOWN','ERROR')
or item is null or trim(item) = '';

-- Checking the Null Values
select count(*) as total_data, sum(quantity is null) as quantity_missing_value,
sum(price_per_unit is null) as price_missing_value, sum(total_spent = 'error') as 
spent_missing_value, sum(payment_method is null) as payment_missing_value, sum(location
is null) as location_missing_value, sum(transaction_date is null or transaction_date =
'error') as date_missing_value
from practices.dirty_cafe_sales;

-- Finding the duplicate data
select transaction_id, item, quantity, price_per_unit,
total_spent, payment_method, location, transaction_date, count(*) as duplicate_total
from practices.dirty_cafe_sales
group by transaction_id, item, quantity, price_per_unit,
total_spent, payment_method, location, transaction_date
having duplicate_total > 1;

-- Change the coloumn name
ALTER TABLE practices.dirty_cafe_sales
RENAME COLUMN `Price Per Unit` to `Price_Per_Unit`,
RENAME COLUMN `Total Spent` to`Total_Spent`,
RENAME COLUMN `Payment Method` to `Payment_Method`,
RENAME COLUMN `Transaction Date` to `Transaction_Date`
; 

alter table practices.dirty_cafe_sales
rename column `Transaction ID` to `Transaction_ID`;

select *
from practices.dirty_cafe_sales;