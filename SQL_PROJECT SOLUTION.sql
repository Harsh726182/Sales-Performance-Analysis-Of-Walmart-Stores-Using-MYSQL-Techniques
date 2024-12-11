Use project_sql;
select * from walmartsales_dataset;
#Question-1
with 
Branchsales as (select branch,sum(total) as total_sales from walmartsales_dataset group by Branch)
select Branch,total_sales,lag(total_sales) over (order by total_sales) as prev_sales ,(total_sales-lag(total_sales) 
over (order by total_sales))/(lag(total_sales) over(order by total_sales))* 100 as growth_rate from Branchsales;
#Question-2
select Branch,Product_line,sum(gross_income-cogs) as max_profit from walmartsales_dataset
group by Branch,Product_line having sum(gross_income-cogs)= (select max(max_profit) from (select Branch,Product_line,
sum(gross_income-cogs) as max_profit from walmartsales_dataset group by Branch,Product_line) as sub
where Branch=walmartsales_dataset.Branch) order by Branch;
#Question-3
create view Ag as select Customer_ID,sum(total) as Total_amount from walmartsales_dataset
group by Customer_ID
order by Customer_ID;
select *, case
when Total_amount<20000 then 'Low'
when Total_amount<22000 then 'Medium'
else 'High'
end as Type from Ag;
#Question-4
with AverageSales AS (SELECT product_line,AVG(Total) AS Avg_sales
from walmartsales_dataset group by Product_line)
select w.Customer_type,w.product_line,w.Total,a.Avg_sales,
case
when w.Total>(a.Avg_Sales * 2)then 'High Anomaly'
when w.Total<(a.Avg_sales/2) then 'Low Anomaly'
else 'Normal'
end as Anomaly_status from walmartsales_dataset w join AverageSales a on w.product_line = a.product_line
where w.Total>(a.avg_sales*2) or w.total<(a.Avg_sales/2)
order by Anomaly_status,w.Total desc;
#Question-5
select city,payment,count(*)AS transaction_count from walmartsales_dataset
group by city,payment
having count(*)=(select max(transaction_count)
from (select city,payment,count(*) as transaction_count from walmartsales_dataset
group by city,payment) as subquery where city=walmartsales_dataset.city)
order by city,transaction_count desc;
#Question-6
with MonthlySales AS( 
select
year(STR_TO_DATE(date,'%d-%m-%y'))AS Sale_Year,
MONTH(STR_TO_DATE(date,'%d-%m-%y'))AS Sale_Month,
Gender,
sum(Total) AS Total_sales from walmartsales_dataset
where date is not null
group by YEAR(STR_TO_DATE(date,'%d-%m-%y')),
MONTH(STR_TO_DATE(date,'%d-%m-%y')),Gender)
select  
Sale_Year,Sale_Month,Gender,Total_sales
from MonthlySales order by Sale_year,Sale_Month,Gender;
#Question-7
select customer_type,product_line,count(Product_line)as Good_line
from walmartsales_dataset
group by customer_type,product_line
having count(Product_line)=(select max(good_line)from(
select customer_type,product_line,count(Product_line)as Good_line from walmartsales_dataset
group by Customer_type,Product_line) as sub where Customer_type=walmartsales_dataset.Customer_type);
#question-8
Select Customer_ID,count(*) as repeat_purchase_count from walmartsales_dataset
where date between '01-01-2019' and '31-01-2019'
group by Customer_ID
Having count(*)>1;
#Question-9
select customer_id,customer_type,city,sum(Quantity * total) as Sales_Volume from walmartsales_dataset
group by Customer_ID,Customer_type,city
order by sales_volume desc limit 5;
#Question-10
select dayname(str_to_date(date,"%d-%m-%y")) as Day_of_week,
sum(total) as total_sales from walmartsales_dataset
group by Day_of_week
order by field(Day_of_week,"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday");
