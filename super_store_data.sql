SELECT * FROM super_store_sales_data.train;
desc train;
select * from train;
-- Data Cleaning
-- Find Missing Values 

select * from train
where sales is null
or `Order Date` is null
or `Customer Name` is null;

-- DATE COLUMN → Time-based Analysis

set SQL_SAFE_UPDATES=0;

update train set `Order Date`=STR_TO_DATE(`Order Date`, '%d/%m/%Y');

update train set `Ship Date`=STR_TO_DATE(`Ship Date`, '%d/%m/%Y');

-- Business Question

-- Write sql query to find how the business performing overall and across dimensions (time, region, category)?
/*
Business Problem Solved

Identify top-performing regions

Detect underperforming regions

Decide where to increase marketing, inventory, or sales teams
*/

select MONTH(`Order Date`) as Month,Region,Category,
round(sum(sales),2) as Total_sales 
from train
group by MONTH(`Order Date`) ,Region, Category
order by MONTH(`Order Date`),Total_sales desc;

-- Business Question

-- Write sql query to find Who are our valuable customers and how loyal are they?
/*
Business Problem Solved

Identify loyal customers

Create retention programs

Reduce customer acquisition cost
*/
select 
`Customer ID` ,
Region,Category,
`Sub-Category`,
count(`Order ID`) as order_count,
round(sum(Sales),2) as total_sales
from train 
group by 
`Customer ID`,Region ,
Category,`Sub-Category` Having order_count>1 ;

-- Business Question

-- Write sql query to find Which products/categories should we push or discontinue?
/*
Business Problem Solved

Inventory optimization

Product portfolio decisions

Supplier negotiations
*/

select Category,
`Sub-Category`,
count(*) as order_count,
round(sum(sales),2) as total_sales
from train 
group by Category,`Sub-Category`
order by order_count desc;

-- With this query we can know average sales  by each category

select category,round(avg(sales),1) as total_revenue 
from train group by category order by total_revenue desc;

select distinct(category) from train;

-- Checking unique product names and their total sales

select distinct(`Product Name`),round(sum(sales),1) as total_sales
from train group by `Product Name`;

-- Write query to get which customer buys most frequently and what his total sales

select distinct(`Customer Name`),count(`Customer Name`) as freq,
round(sum(sales),1) as total_sales from train
group by `Customer Name` order by freq desc limit 1;

-- Top 3 sales from the train dataset

select * from train
order by sales desc limit 3;	

-- Calculate the average order value per customer

select `Customer ID`,avg(sales) as Avg_order_value
from train group by `Customer ID`;

-- Calculate the max orders by region and category

select region,Category,round(max(total_sales),1)as max_sales
from (
select region,category,sum(sales) as total_sales
from train group by Region,Category
) as subquery group by Region,Category;

-- calculate count and total sales of each category in each month

select extract(month from `Order Date`) as month,category,
count(`Customer ID`) as cust_count,round(sum(sales),1)
from train group by month,category order by month;

-- write sql to count total no of orders

select count(*) from train;

-- write sql query  to calculate quantity and total_revenue of ship mode

select `Ship Mode`,count(*),round(sum(sales),1) 
as total_revenue from train 
group by `Ship Mode`;

-- write sql query to check order  details on 2017-11-11

select * from train where date(`Order Date`) = '2017-11-08';

-- write sql query unique Sub-Category and their total orders and total_revenue generated

select distinct(`Sub-Category`),count(`Sub-Category`) as quantity,
round(sum(sales),1) as total_revenue from train
group by `Sub-Category` order by quantity desc;

-- Montly trend analysis

select YEAR(`Order Date`) as year,MONTH(`Order Date`) as month,
round(sum(sales),1) from train group by 1,2 order by 1,2 asc;
-- Rank categories by sales

select category ,round(sum(sales),1) as total_sales ,
rank() over(order by sum(sales) desc) as sales_rank
from train group by category;




