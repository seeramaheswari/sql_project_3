SELECT * FROM super_store_sales_data.train;
desc train;
select * from train;

-- Data Cleaning

-- Droping the unwanted columns
alter table train drop column Country;
alter table train drop column State;
alter table train drop column `Postal Code`;
alter table train drop column `Product ID`;

-- write sql query to know the no of duplicate rows 
with Duplicate_records as(
select `Order ID`,
`Customer ID`,
`Product ID`,
city,
`Ship Mode`,
row_number() over(
partition by `Customer ID`,`Product ID`
 order by `Order ID`)
as row_no
from train
)
select * from Duplicate_records where row_no>1 order by `order ID`  ;


-- Find Missing Values 

select * from train
where sales is null
or `Order Date` is null
or `Customer Name` is null;

set SQL_SAFE_UPDATES=0;

update train set `Order Date`=STR_TO_DATE(`Order Date`, '%d/%m/%Y');

update train set `Ship Date`=STR_TO_DATE(`Ship Date`, '%d/%m/%Y');

-- Business Question

-- Write sql query to find how the business performing overall and across dimensions (time, region, category)?
/*
Business Problem Solved

Identify top-performing regions

Identitfy the top performing cities in each region

Detect underperforming regions

Decide where to increase marketing, inventory, or sales teams
*/

select year(`Order Date`)as OrderYear,month(`Order Date`) as OrderMonth,
count(*)as Total_sales,
round(sum(sales),2) as Total_Revenue,round(avg(sales),2)as avg_sales_revenue
from train
group by year(`Order Date`),month(`Order Date`) 
order by year(`Order Date`),month(`Order Date`)asc;

select region,count(*) as total_sales,round(sum(sales),2)as total_revenue,
round(avg(sales),2)as avg_sales_revenue from train group by region
order by total_revenue desc;

select category,count(*) as total_sales,round(sum(sales),2)as total_revenue,
round(avg(sales),2)as avg_sales_revenue from train group by category
order by total_revenue desc;

with cte as(
select region,city ,round(sum(sales),2)as total_revenue ,rank()
over(partition by region order by sum(sales) desc) as revenue_rank
from train group by region,city
)
select region,city,total_revenue from cte where revenue_rank<=2;

with cte as(
select Category,`Sub-Category` ,round(sum(sales),2)as total_revenue ,rank()
over(partition by Category order by sum(sales) desc) as revenue_rank
from train group by Category,`Sub-Category`
)
select Category,`Sub-Category` ,total_revenue from cte where revenue_rank<=2;

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
count(`Order ID`) as order_count,
round(sum(Sales),2) as total_sales
from train 
group by 
`Customer ID`,Region ,
Category,`Sub-Category` Having order_count>1  order by count(`Order ID`) desc;

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
order by Category,total_sales desc;

-- With this query we can know average sales  by each category and percentile contributuon of each category

select category,round(avg(sales),1) as total_revenue ,
round(sum(sales)*100/(select sum(sales) from train),1) as cate_perc
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

select `Customer ID`,round(avg(sales),1) as Avg_order_value
from train group by `Customer ID`;

-- write sql query to know the category performance by region wise

select region,Category,count(*)as sales_count,round(sum(sales),2)as total_revenue
from train group by region ,category order by total_revenue desc;

-- Write sql query to find which category generates highest revenue in each egion

select region,Category,round(total_sales,1)as max_sales
from (
select region,category,sum(sales) as total_sales,dense_rank() 
over (partition by region order  by sum(sales) desc) as cate_sale_rank
from train group by Region,Category 
) as subquery where cate_sale_rank=1;

-- write sql to count total no of orders

select count(*) from train;

-- write sql query  to calculate quantity and total_revenue of ship mode

select `Ship Mode`,count(*)total_sales,round(sum(sales),1) 
as total_revenue from train 
group by `Ship Mode`;

-- write sql query to check order  details on 2017-11-11

select * from train where date(`Order Date`) = '2017-11-08';

### Buisiness Problem
-- write sql query unique Sub-Category and their total orders and total_revenue generated
/*
Buisiness problem solved:
Investing more on top selling products
Adjust pricing strategy per products
*/
select (`Sub-Category`),count(`Sub-Category`) as quantity,
round(sum(sales),1) as total_revenue from train
group by `Sub-Category` order by quantity desc;

### Business Question

-- Write sql to find monthly trend analysis?

/*
## Buisiness Problem Solved
Forecast demand

Seasonal inventory planning

Financial planning
*/
select YEAR(`Order Date`) as order_year,monthname(`Order Date`) as month,
round(sum(sales),1) from train group by 1,2 order by 1,2 asc;

-- Rank categories by sales

select category ,round(sum(sales),1) as total_sales ,
rank() over(order by sum(sales) desc) as sales_rank
from train group by category;

select * from train;
-- what are the top 3 most purchased products within each category
with item_counts as(
select Category,`Sub-Category`,
count(`Customer ID`) as total_orders,round(sum(sales),2) as total_revenue,
ROW_NUMBER() OVER(partition by Category order by count(`Customer ID`) desc) as item_rank
from train group by Category,`Sub-Category`
)
select item_rank,Category,`Sub-Category`,total_orders,total_revenue
from item_counts where item_rank<=3;

-- write sql to display the regional revenue performance and growth over month
with yearly_sales as(
select region,year(`order date`) as order_year,round(sum(sales),2) as total_revenue
 from train group by region ,year(`Order Date`)
),
growth_cal as(
select region,order_year,total_revenue,lag(total_revenue) over(partition by region
order by order_year) as prev_revenue from yearly_sales
)
select *,round(((total_revenue-prev_revenue)/prev_revenue)* 100,2) as growth_prct from growth_cal;

-- write sql query to find the running total to display the daily trends
select date(`order date`) order_date,round(sum(sales),1)as daily_revenue,
round(sum(sum(sales)) over(order by `order date`),1) as sales_growth
from train group by `order date`;

-- write sql query to find the third highest total categorial amount using function
delimiter //
create function get_Nth_categorical_order_value(N int) 
returns decimal(10,2)
reads sql data 
begin
set N=N-1;
return(
select distinct sales from train 
where category='Furniture' order by sales desc
limit 1 offset N
);
end //
delimiter ;

select get_Nth_categorical_order_value(1);

select category,sales from train order by sales desc;





