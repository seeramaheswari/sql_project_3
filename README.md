# sql_project_3

## Data Cleaning

### Find Missing Values 
```
select * from train
where sales is null
or `Order Date` is null
or `Customer Name` is null;
```
**Write sql query to change the date format from'dd-mm-yyyy' to dd-mm-yyyy' by using STR_TO_DATE function**

```
update train set `Order Date`=STR_TO_DATE(`Order Date`, '%d/%m/%Y');

update train set `Ship Date`=STR_TO_DATE(`Ship Date`, '%d/%m/%Y');

```
## Super Store Analysis and Insights

**Viewing Super store dataset**

>SELECT * FROM super_store_sales_data.train;

**Desribing the Columns names and datatype of the dataset**

>desc train;

### Business Question

**Write sql query to find how the business performing overall and across dimensions (time, region, category)?**

### Business Problem Solved
***
**Identify top-performing regions**

**Detect underperforming regions**

**Decide where to increase marketing, inventory, or sales teams**
***
```
select MONTH(`Order Date`) as Month,Region,Category,
round(sum(sales),2) as Total_sales 
from train
group by MONTH(`Order Date`) ,Region, Category
order by MONTH(`Order Date`),Total_sales desc;
```
### Business Question

**Write sql query to find Who are our valuable customers and how loyal are they?**
***
**Business Problem Solved**

**Identify loyal customers**

**Create retention programs**

**Reduce customer acquisition cost**
***
```
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
```
### Business Question

**Write sql query to find Which products/categories should we push or discontinue?**

### Business Problem Solved
***
**Inventory optimization**

**Product portfolio decisions**

**Supplier negotiations**
***
```
select Category,
`Sub-Category`,
count(*) as order_count,
round(sum(sales),2) as total_sales
from train 
group by Category,`Sub-Category`
order by order_count desc;
```
**Write Sql query to check top 5 orders**

>select * from train order by sales desc limit 5;

**Write sql query to calculate average sales by each category**

```
select category,round(avg(sales),1) as total_revenue 
from train group by category order by total_revenue desc;
```
**Write sql query to retrieve unique category names**

>select distinct(category) from train;

**Write sql query to check quantity and total sales of categories by region wise**

```
select region,category,count(*) as cust_count,
round(sum(sales),1) as total_sales
from train group by region,category;
```
**Calculate the max orders by region and category**
```
select region,Category,round(max(total_sales),1)as max_sales
from (
select region,category,sum(sales) as total_sales
from train group by Region,Category
) as subquery group by Region,Category;
```
**write sql query  to calculate quantity and total_revenue of ship mode**
```
select `Ship Mode`,count(*),round(sum(sales),1) 
as total_revenue from train 
group by `Ship Mode`;
```
**write sql query to check order  details on 2017-11-08**

>select * from train where date(`Order Date`) = '2017-11-08';

### Buisiness Problem

 **write sql query unique Sub-Category and their total orders and total_revenue generated**
***
### Buisiness problem solved:
**Investing more  on top selling products**

**Adjust pricing strategy per products**
***
```
select (`Sub-Category`),count(`Sub-Category`) as quantity,
round(sum(sales),1) as total_revenue from train
group by `Sub-Category` order by quantity desc;
```
### Business Question

**Write sql to find monthly trend analysis?**
***
### Buisiness Problem Solved:

**Forecast demand**

**Seasonal inventory planning**

**Financial planning**
***
```
select YEAR(`Order Date`) as year,MONTH(`Order Date`) as month,
round(sum(sales),1) from train group by 1,2 order by 1,2 asc;
```
**Rank categories by sales**
```
select category ,round(sum(sales),1) as total_sales ,
rank() over(order by sum(sales) desc) as sales_rank
from train group by category;
```






