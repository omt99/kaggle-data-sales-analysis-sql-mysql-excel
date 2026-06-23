create database sales;
use sales;
select*from sales_data;
 ALTER TABLE sales_data
ADD COLUMN New_Sale_Date DATE;
 set sql_safe_updates = 0;
 update sales_data 
 set New_sale_Date = str_to_date(sale_date ,'%d-%m-%Y');
 alter table sales_data
 drop column sale_date;
 
 alter table sales_data
 rename column New_Sale_Date to Sale_Date;
 
 -- creating star scema 
 -- create dimension tables 
 
 -- create dim_product 
 
 create table dim_product (
 product_key int primary key auto_increment,
 product_Category varchar(50) not null
 );
 
 -- insert data into dim_product
 insert into dim_product ( product_Category)
 select distinct product_category 
 from sales_data;
 
 select*from dim_product;
 
 -- creat dim_date 
 
 create table dim_date(
 date_key int primary key auto_increment,
 full_date  date not null ,
 year int ,
 month int,
 quarter int,
 day int,
 month_name varchar(10),
 day_name varchar(10) 
 );
 
-- insert data into dim_date table
 
 insert into dim_date(full_date,year,month,quarter,day,month_name,day_name)
 select distinct sale_date as full_date,
 year(sale_date) as year,
 month(sale_date) as month,
 quarter(sale_date) as quarter,
 day(sale_date)as day,
 monthname(sale_date) as month_name,
 dayname( sale_date) as day_name 
 from sales_data;
 
 -- create dim_sales_rep table 
 create table dim_sales_rep(
 sales_rep_key int primary key auto_increment,
 sales_rep varchar(50)
 );
 
 -- INSERT DATA INTO DIM_SALES_REP
 INSERT INTO dim_sales_rep(sales_rep)
 select distinct 
 sales_rep 
 from sales_data;

-- create dime_region 
create table dim_region(
region_key int primary key auto_increment,
region varchar(50)
);

-- insert data into dim_region 

insert into dim_region(region)
select distinct 
region 
from sales_data;
select*from sales_data;
-- create dim_customer table 
create table dim_customer(
customer_key int primary key auto_increment,
customer_type varchar(50) not null
);

-- insert data into dim_customer 
insert into dim_customer(customer_type)
select distinct 
customer_type 
from sales_data;

-- create dim_payment table 
create table dim_payment(
payment_key int primary key auto_increment,
payment_Method varchar(50) not null
);

-- inssert data into dim_payment
insert into dim_payment( payment_Method)
select distinct 
payment_method 
from sales_data;

-- creat table dim_sales_channel

create table dim_sales_channel(
sales_channel_key int primary key auto_increment,
Sales_Channel varchar(50) not null
);

-- insert data into dim_Sales_Channel 
insert into dim_sales_channel(Sales_Channel)
select distinct 
Sales_Channel 
from sales_data;

select*from dim_sales_channel;

select*from sales_data;

-- create fact table 

create table fact_sales(
sales_key int primary key auto_increment,

product_key int,
date_key int,
region_key int ,
customer_key int ,
sales_rep_key int,
sales_channel_key int,
payment_key int ,

sales_amount decimal(10,2),
quantity_sold int,
unit_cost decimal(10,2),
unit_price decimal(10,2),
discount decimal(10,2),

-- foreign key
foreign key (product_key) references dim_product(product_key),
 foreign key (date_key) references dim_date (date_key),
foreign key (region_key) references dim_region (region_key),
foreign key (customer_key) references dim_customer (customer_key),
 foreign key (sales_rep_key) references dim_sales_rep (sales_rep_key),
foreign key (sales_channel_key) references dim_sales_channel (sales_channel_key),
 foreign key (payment_key) references dim_payment (payment_key)
 );
 
-- insert data into fact_sales table 

insert into fact_sales(product_key,date_key,region_key,customer_key,sales_rep_key,
sales_channel_key,payment_key,sales_amount,quantity_sold,unit_cost,unit_price ,discount)

select 
p.product_key,
d.date_key,
r.region_key,
c.customer_key,
sr.sales_rep_key,
sc.sales_channel_key,
py.payment_key,
s.sales_amount,
s.quantity_sold,
s.unit_cost,
s.unit_price,
s.discount
from sales_data s 
join dim_product p 
on p.product_category=s.product_category
join dim_date d
on d.full_date = s.sale_date
join dim_sales_rep sr
on sr.sales_rep = s.Sales_Rep 
join dim_region r 
on r.region = s.Region 
join dim_customer c 
on c.Customer_Type=s.Customer_Type 
join dim_payment py 
on py.Payment_Method = s.Payment_Method 
join dim_Sales_Channel sc 
on sc.Sales_Channel = s.Sales_Channel;
-- correct sales_amount value
ALTER TABLE fact_sales
ADD COLUMN calculated_sales_amount DECIMAL(10,2);
update fact_sales 
set calculated_sales_amount=(unit_price * quantity_sold) * (1 - discount);
SET SQL_SAFE_UPDATES = 0;
alter table fact_sales
rename column calculated_sales_amount to sales_amount;

select*from fact_sales;
-- kpi's for the business_requriment 

-- 1.Total Sales Revenue in million
select format(sum(sales_amount)/1000000,2)as total_revenue_million from fact_sales;

-- 2.Total Quantity Sold
select sum(quantity_sold) as total_quantity from fact_sales;

-- 3.Average Sales Amount
select round(avg(sales_amount),2) as avg_sales from fact_sales;

-- Total Number of Transactions 
select count(*) as total_transaction from fact_sales;

-- Highest Sale 
select max(sales_amount) as Highest_Sale from fact_sales;

-- lowest_sale
select min(sales_amount) as lowest_sale from fact_sales;

-- total_profit 
SELECT
    ROUND(SUM((unit_price - unit_cost) * quantity_sold), 2) AS total_profit
FROM fact_sales;

-- profit_margin

select  ROUND(SUM((unit_price - unit_cost) * quantity_sold)/sum(sales_amount)*100,2) 
as profit_margin from fact_sales;

-- product_category performance 

select p.product_category, sum(f.sales_amount) as total_revenue,
sum(quantity_sold)as total_quantity_sold,
round(avg(f.sales_amount),2)as avg_sales_amount 
from fact_sales f 
join dim_product p 
on p.product_key = f.product_key 
group by p.product_category
order by total_revenue desc;

-- Regional Performance
select r.region,sum(f.sales_amount)as total_revenue,count(f.sales_key)as total_transactions,
round(sum((f.unit_price-f.unit_cost)*f.quantity_sold),2) as total_profit,
round(sum((f.unit_price-f.unit_cost)*f.quantity_sold)/sum(f.sales_amount)*100,2) as profit_margin_percentage
from fact_sales f 
join dim_region r 
on f.region_key = r.region_key
group by r.region 
order by total_revenue desc;

-- Top 5 Sales Representatives
select*from dim_sales_rep;
select sr.sales_rep,format(sum(f.sales_amount)/1000000,2) total_revenue_million,
round(sum((f.unit_price-f.unit_cost)*f.quantity_sold),2) as total_profit,
round(sum((f.unit_price-f.unit_cost)*f.quantity_sold)/sum(f.sales_amount)*100,2) as profit_margin_percentage,
count(f.sales_key) as total_trans,
sum(f.quantity_sold) as total_quantity_sold
from fact_sales f 
join dim_sales_rep sr 
on sr.sales_rep_key = f.Sales_rep_key
group by sr.sales_rep
order by total_revenue_million desc;

-- Monthly Sales Trend Analysis
select d.year,d.month,d.month_name,
format(sum(f.sales_amount)/1000000,2) total_revenue_million,
round(sum((f.unit_price-f.unit_cost)*f.quantity_sold),2) as total_profit,
round(sum((f.unit_price-f.unit_cost)*f.quantity_sold)/sum(f.sales_amount)*100,2) as profit_margin_percentage,
count(f.sales_key) as total_trans,
sum(f.quantity_sold) as total_quantity_sold 
from fact_sales f 
join dim_date d 
on d.date_key = f.date_key 
group by d.year,d.month,d.month_name 
ORDER BY d.year, d.month;

-- Which Region Contributes the Most to Total Revenue 
with  total_revenue as( select sum(sales_amount)as  total_rev from fact_sales)
select r.region,tr.total_re,
round(sum(f.sales_amount)/tr.total_re*100,2)as revenue_contribution
from fact_sales f 
join 
dim_region r 
on 
r.region_key = f.region_key 
cross join total_revenue tr
group by r.region,tr.total_re 
ORDER BY revenue_contribution DESC;

-- Top Product Category in Each Region
with revenue_contribution as(select r.region,p.product_category,format(sum(f.sales_amount)/1000000,2)as total_revenue_million,
dense_rank()over(partition by r.region order by format(sum(f.sales_amount)/1000000,2) desc) as revenue_contribution_rnk
from fact_sales f 
join dim_region r 
on r.region_key = f.region_key 
join dim_product p
on p.product_key = f.product_key 
group by r.region , p.product_category) 
select*from revenue_contribution 
where revenue_contribution_rnk=1;

-- Month-over-Month Revenue Growth
 with prev_revenue as(select d.year,d.month,round(sum(f.sales_amount)/1000000,2)as total_revenue_million,
lag(round(sum(f.sales_amount)/1000000,2))over( partition by d.year order by d.month)as prev_month_revenue
from fact_sales f 
join dim_date d 
on d.date_key = f.date_key 
group by d.year,d.month)
select 
year,month,total_revenue_million,prev_month_revenue ,
(total_revenue_million-prev_month_revenue) as revenue_growth,
round(((total_revenue_million-prev_month_revenue)/prev_month_revenue)*100,2) as revenue_growth_percentage
from prev_revenue;









