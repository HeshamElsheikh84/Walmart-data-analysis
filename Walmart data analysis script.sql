create database if not exists walmart;
use walmart;
create table Sales (Invoice_ID Varchar(30) Not Null Primary Key,
Branch Varchar(5) Not Null,
City Varchar(30) Not Null,
Customer_type Varchar(30) Not Null,
Gender Varchar(10) Not Null,
Product_line Varchar(100) Not Null,
Unit_price Decimal Not Null,
Quantity int Not Null,
VAT Float(6,4) Not Null,
Total Decimal(12,4) Not Null,
Date DateTime Not Null,
Time Time Not Null,
Payment Varchar(15) Not Null,
cogs Decimal(10,2) Not Null,
gross_margin_impact float(11,9),
gross_income Decimal(12,4) Not Null,
Rating float(2,1) Not Null
);

select
	 Time,
     (case
		when `Time` between "00:00:00" and "12:00:00" then "Morning"
        when `Time` between "12:00:01" and "16:00:00" then "Afternoon"
        else "Evening"
	end) as Time_of_day
from Sales;

Alter table Sales add column Time_of_day varchar(20);

update Sales
set Time_of_day= (case
					when `Time` between "00:00:00" and "12:00:00" then "Morning"
					when `Time` between "12:00:01" and "16:00:00" then "Afternoon"
					else "Evening"
				end);

Alter table Sales add column Day_name varchar(20);

update Sales
set Day_name=  dayname(`Date`);

Alter table Sales add column Month_name varchar(20);

update Sales
set Month_name=  monthname(`Date`);

-- How many unique cities?

select distinct City, count(*) from Sales
Group by City;

-- In which city is each branch?

select distinct Branch, City from Sales;

-- What are the product lines?

select distinct Product_line from Sales;

-- What are the payment methods?

select distinct Payment from Sales;

-- What is the most selling product?

Select distinct Product_line, count(Product_line) as `count` from Sales
Group by Product_line order by `count` desc;

-- Which month has highest revenue?

select Month_name as Month, sum(Total)as 'Total revenue' from Sales
group by Month order by 2 desc;

-- Which months has highest COGS?

select Month_name as Month, sum(cogs) as 'Total cogs' from Sales
group by Month order by 2 desc;

-- Which product line has highest revenue?

select Product_line as 'Product line', sum(Total) as 'Total revenue' from Sales
group by 1 order by 2 desc;

-- Which city has highest revenue?

Select City, Branch, sum(Total) as 'Total revenue' from Sales
group by 1,2 order by 3 desc;

-- Which product line has largest VAT?

select Product_line as `Product line`, avg(VAT) as VAT from Sales
group by `Product line` order by 2 Desc;

-- Which branch sold more products than average product sold?

with xyz as
	(select Branch, sum(Quantity) as QTY from Sales 
    group by Branch
    )
select Branch, QTY from xyz 
where QTY > (select avg(QTY) from xyz);

-- what is the most common product line by gender?

select Gender, Product_line, count(Product_line) as 'Most Common' from Sales
group by Gender, Product_line order by 3 desc;

-- What is the average rating of the product line?

select Product_line, round(avg(Rating), 2) as 'average rating' from Sales
group by Product_line order by 2 desc;

-- Number of sales made in each time of day per week?

select Time_of_day, count(*) as 'Total' from Sales
where Day_name= 'Sunday'
group by Time_of_day order by 2 desc;

-- Which of the customer types brings the most revenue?

select Customer_type, sum(Total) as 'Total revenue' from Sales
group by Customer_type
order by 2 desc;

-- Which city has largest VAT?

select City, avg(VAT) as VAT from Sales
group by City order by 2 desc;

-- Which customer type pay more VAT?

select Customer_type, avg(VAT) as VAT from Sales
group by 1 order by 2 desc;

-- How many unique customer types does the data have?

select distinct Customer_type, count(*) from Sales
group by 1
order by 2 desc;

-- How many unique payment does the data have?

select distinct Payment from Sales;

-- What is the most common gender of the customers?

select Gender, count(*) from Sales
group by 1;

-- What is the gender distribution per branch?

select Gender,Branch,City, count(Gender) from Sales
group by 1,2,3;

-- Which time of the day do customers give highest rate?

select Time_of_day, avg(Rating) as 'Average rating' from Sales
group by 1 order by 2 desc;

-- Which time of the day do customers give highest rate per branch?

select Time_of_day,Branch, avg(Rating) as 'Average rating' from Sales
group by 1,2 order by 3 desc;

-- Which day of the week has the best avg rating?

select Day_name, avg(Rating) from Sales
group by 1 order by 2 desc;

-- Which day of the week has the best avg rating per branch?

select Day_name,Branch, avg(Rating) from Sales
group by 1,2 order by 2,3 desc;









