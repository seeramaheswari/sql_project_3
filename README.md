# Retail Sales Analysis Using SQL

## Data Cleaning

 **Droping the unwanted columns**

**Find Missing Values**

>There is no missing values in the data**

**Changed the date format from'dd-mm-yyyy' to dd-mm-yyyy' by using STR_TO_DATE function**

## Super Store Analysis and Insights

**Viewing cleaned Super store sales  dataset**

<img width="600" height="300" alt="Image" src="https://github.com/user-attachments/assets/f6c78949-d62b-4ddd-84f7-491daab80ff6" />

**Desribing the Columns names and datatype of the dataset**

<img width="600" height="300" alt="Image" src="https://github.com/user-attachments/assets/c8497df4-1f5d-4cdd-9a09-9270e86fe3e2" />

### Business Question

**Write sql query to find how the business performing overall and across dimensions (time, region, category)?**

<img width="500" height="300" alt="Image" src="https://github.com/user-attachments/assets/3114c05e-dd0c-4940-97de-64f24af1585c" />

<img width="500" height="300" alt="Image" src="https://github.com/user-attachments/assets/c19f3f76-c22b-46e0-aa0b-458be44f3e35" />

<img width="500" height="300" alt="Image" src="https://github.com/user-attachments/assets/eb9aedf6-3323-4cff-adf7-223be00975fe" />

### Business Problem Solved
***
**Identitfy the top performing cities in each region**

**Detect underperforming regions**

**Decide where to increase marketing, inventory, or sales teams**

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






