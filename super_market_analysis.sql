#'projects' is the name of the database

#reading the file
select * 
from projects.super_market_sales
limit 5;

# We are seeing the number of rows
SELECT count(*) FROM projects.super_market_sales;

# We are seeing the number of columns
select count(*) as number_of_columns
from information_schema.columns
where table_name='super_market_sales';

#We're seeing the data type of every column and how many nulls are in every column
select column_name ,data_type, isnull(column_name)
from information_schema.columns
where table_schema = 'projects' 
and table_name = 'super_market_sales';

#Here we are going to convert the data type of the "Date" and "Time" columns to date and time

#first we transform the format
update super_market_sales
set `Date`=str_to_date(`Date`, "%m/%d/%Y");
update super_market_sales
set `Time`=str_to_date(`Time`, "%H:%i");
#and here we transform the data type
alter table super_market_sales
modify column `Date` date;
alter table super_market_sales
modify column `Time` time;

#we are extracting of the columns "Date" and "Time" the "year", "month name ", "day name" and the "hour" 
select Date, Time,year(Date) as `year`, monthname(Date) as `month`, 
dayname(Date) as `day`, hour(Time) as `hour`
from projects.super_market_sales
limit 5;

#checking the number of non-repeating values in each column
select count(distinct(`Invoice ID`)), count(distinct(`Branch`)), count(distinct(`City`)),
count(distinct(`Customer type`)), count(distinct(`Gender`)), count(distinct(`Product line`)),
count(distinct(`Unit price`)), count(distinct(`Quantity`)), count(distinct(`Total`)), count(distinct(`Date`)),
count(distinct(`Time`)), count(distinct(`Payment`)), count(distinct(`gross margin percentage`)), 
count(distinct(`Rating`))
from projects.super_market_sales;

#number of clients of each gender
select `Gender` as Gender, count(`Gender`) as Number_of_each_gender
From projects.super_market_sales
Group by Gender;

#checking the number of customers in each branch
select distinct(`Branch`) as Branch, count(`Branch`) as number_of_customer_in_each_branch
from projects.super_market_sales
group by Branch;

#checking the number of customers in each City
select `City` as City, count(`City`) as number_of_customer_in_each_city
from projects.super_market_sales
group by City;

#Number of clients in each city categorized by branch
select `Branch` as Branch, `City` as City, count(`Invoice ID`) as `Number of clients in each city categorized by branch`
from projects.super_market_sales
group by Branch, City;

#Consultation of the quantity of each type of client
select `Customer type`, count(`Customer type`) as `number of each customer type`
from projects.super_market_sales
group by `Customer type`;

#Average rating of each product line
select `Product line`, Round(avg(`Rating`), 4) as `Rating average`
from projects.super_market_sales
group by `Product line`
order by `Rating average` desc;

#Number of customers who buy each product line
select `Product line`, count(`Product line`) as `number of customers who bought each product line`
from projects.super_market_sales
group by `Product line`
order by `number of customers who bought each product line` desc;

#Number of clients per month
select monthname(`Date`) as `month`, count(monthname(`Date`)) as `number of cutomers per month`
from projects.super_market_sales
group by `month`;

#Number of clients per day
select dayname(`Date`) as `day`, count(dayname(`Date`)) as `number of cutomers per day`
from projects.super_market_sales
group by `day`
order by `number of cutomers per day` desc;

#Number of clients per hour
select hour(`Time`) as `hour`, count(hour(`Time`)) as `number of customers per hour`
from projects.super_market_sales
group by `hour`
order by `number of customers per hour` desc;

#Consult the amount of each type of customer grouped by gender
select `Customer type`, `Gender`, count(`Invoice ID`) as `Amount of each type of customer grouped by gender`
from projects.super_market_sales
group by `Customer type`, `Gender`
order by `Customer type`;

#Number of customers who bought each line of products grouped by gender
select `Product line`, `Gender`, count(`Invoice ID`) as `Customers who bought each line of products grouped by gender`
from projects.super_market_sales
group by `Product line`, `Gender`
order by `Product line`;

#Number of customers who buy each line of products grouped by type of Customer
select `Product line`, `Customer type`, count(`Invoice ID`) as `Customers who buy each line of products grouped by type of Customer`
from projects.super_market_sales
group by `Product line`, `Customer type`
order by `Product line`;

#Number of customers of each gender per month
select monthname(`Date`) as `month`, `Gender`, count(`Invoice ID`) as `Number of customers of each gender per month`
from projects.super_market_sales
group by `month`, `Gender`
order by `month`;

#Number of customers of each gender per day
select dayname(`Date`) as `Day`, `Gender`, count(`Invoice ID`) as `Number of customers of each gender per day`
from projects.super_market_sales
group by `Day`, `Gender`
order by `Day`;

#Number of customers of each gender per hour
select hour(`Time`) as `Hour`, `Gender`, count(`Invoice ID`) as `Number of customers of each gender per hour`
from projects.super_market_sales
group by `Hour`, `Gender`
order by `Hour`;

#Number of sales by product line
select `Product line`, sum(`Quantity`) as `Number of sales by product line`
from projects.super_market_sales
group by `Product line`
Order by `Number of sales by product line` desc;

#Number of customers using each type of payment method
select `Payment` as `Payment method`, count(`Payment`) as `Number of customers using each type of payment method`
from projects.super_market_sales
group by `Payment method`
order by `Number of customers using each type of payment method` desc;

#Number of customers who use each type of payment method in the different branches
select `Branch`, `Payment` as `Payment method`, count(`Invoice ID`) as `Number of customers who use each type of payment method in the different branches`
from projects.super_market_sales
group by `Branch`, `Payment method`
order by `Branch`;

#Number of customers using each payment type by gender
select `Gender`, `Payment` as `Payment method`, count(`Invoice ID`) as `Number of customers using each payment type by gender`
from projects.super_market_sales
group by `Gender`, 	`Payment method`
order by `Gender`;

#Amount of sales per month
select monthname(`Date`) as `month`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
group by `month`;

#Amount of sales for each month for each gender
select monthname(`Date`) as `month`, `Gender`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
group by `month`, `Gender`
order by `month`;

#Quantity sold of each product line by base per month
with January as
(
select `Product line`, sum(`Quantity`) as `amount of sales January`
from projects.super_market_sales
where monthname(`Date`) = 'January'
group by `Product line`
), February as 
(
select `Product line`, sum(`Quantity`) as `amount of sales February`
from projects.super_market_sales
where monthname(`Date`) = 'February'
group by `Product line`
), March as
(
select `Product line`, sum(`Quantity`) as `amount of sales March`
from projects.super_market_sales
where monthname(`Date`) = 'March'
group by `Product line`
)
select January.`Product line` as `Product line`, January.`amount of sales January` as `amount of sales January`,
February.`amount of sales February` as `amount of sales February`, 
March.`amount of sales March` as `amount of sales January`
from January 
join February
on January.`Product line` = February.`Product line`
join March 
on March.`Product line` = February.`Product line`;

#Number of products sold on a daily basis
select dayname(`Date`) as `Day`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
group by `Day`
order by `Amount of sales` desc;

#Number of products sold each day by gender
with Male as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Male'
group by `Day`
), Female as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Female'
group by `Day`
)
select Male.`Day` as `Day`, Male.`Amount of sales` as `Amount of sales to male gender`,
Female.`Amount of sales` as `Amount of sales to female gender`
from Male
join Female
on Male.`Day` = Female.`Day`;
#Number of products sold each day by type of customer
with Member as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Customer type` = 'Member'
group by `Day`
), Normal as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Customer type` = 'Normal'
group by `Day`
)
select Member.`Day` as `Day`, Member.`Amount of sales` as `Amount of sales to member customers`,
Normal.`Amount of sales` as `Amount of sales to normal customers`
from Member
join Normal
on Member.`Day` = Normal.`Day`;

#Number of products sold each day by type of customer and gender
with Male as 
(
select dayname(`Date`) as `Day`, `Customer type`,sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Male'
group by `Day`, `Customer type`
order by `Day`
), Female as 
(
select dayname(`Date`) as `Day`, `Customer type`,sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Female'
group by `Day`, `Customer type`
order by `Day`
)
select Female.`Day` as `Day`, Female.`Customer type`,Female.`Amount of sales` as `Amount of sales to female gender`,
Male.`Amount of sales` as `Amount of sales to male gender`
from Male
join Female
on Male.`Day` = Female.`Day`
and Male.`Customer type` = Female.`Customer type`;

#Number of products sold in every branch
select `Branch`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
group by `Branch`
order by `Branch`;

#Number of products sold each day by branch categorized by gender
with male as
(
select `Branch`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Male'
group by `Branch`
order by `Branch`
), female as 
(
select `Branch`, sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Female'
group by `Branch`
order by `Branch`
)
select female.`Branch` as `Branch`, female.`Amount of sales` as `Amount of sales to female gender`,
male.`Amount of sales` as `Amount of sales to male gender`
from female
join male
on female.`Branch` = male.`Branch`;

#Number of products sold each day by branch categorized by gender and type of customer
with Male as 
(
select `Branch`, `Customer type`,sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Male'
group by `Branch`, `Customer type`
order by `Branch`
), Female as 
(
select `Branch`, `Customer type`,sum(`Quantity`) as `Amount of sales`
from projects.super_market_sales
where `Gender` = 'Female'
group by `Branch`, `Customer type`
order by `Branch`
)
select Female.`Branch` as `Branch`, Female.`Customer type`,Female.`Amount of sales` as `Amount of sales to female gender`,
Male.`Amount of sales` as `Amount of sales to male gender`
from Male
join Female
on Male.`Branch` = Female.`Branch`
and Male.`Customer type` = Female.`Customer type`;

#Quantities of each product line depending on the day
with `Electronic accessories` as
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Electronic accessories'
group by `Day`
), `Fashion accessories` as
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Fashion accessories'
group by `Day`
), `Food and beverages` as
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Food and beverages'
group by `Day`
), `Health and beauty` as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Health and beauty'
group by `Day`
), `Home and lifestyle` as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Home and lifestyle'
group by `Day`
), `Sports and travel` as 
(
select dayname(`Date`) as `Day`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Sports and travel'
group by `Day`
)
select `Electronic accessories`.`Day` as `Day`, `Electronic accessories`.`amount of sales` as `amount of sales of Electronic accessories`,
`Fashion accessories`.`amount of sales` as `amount of sales of Fashion accessories`,
`Food and beverages`.`amount of sales` as `amount of sales of Food and beverages`,
`Health and beauty`.`amount of sales` as `amount of sales of Health and beauty`,
`Home and lifestyle`.`amount of sales` as `amount of sales of Home and lifestyle`,
`Sports and travel`.`amount of sales` as `amount of sales of Sports and travel`
from `Electronic accessories` 
join `Fashion accessories`
on `Electronic accessories`.`Day` = `Fashion accessories`.`Day`
join `Food and beverages`
on `Food and beverages`.`Day` = `Fashion accessories`.`Day`
join `Health and beauty`
on `Health and beauty`.`Day` = `Food and beverages`.`Day`
join `Home and lifestyle`
on `Home and lifestyle`.`Day` = `Health and beauty`.`Day`
join `Sports and travel`
on `Sports and travel`.`Day` = `Home and lifestyle`.`Day`;

#Number of products sold every hour
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
group by `hour`
order by `hour` asc;

#Number of products sold per hour for each gender
with female as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Gender` = 'Female'
group by `hour`
order by `hour` asc
), male as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Gender` = 'Male'
group by `hour`
order by `hour` asc
)
select female.`hour` as `Hour`, female.`amount of sales` as `Amount of sales to female gender`,
male.`amount of sales` as `Amount of sales to male gender`
from female
join male
on female.`hour` = male.`hour`;

#Number of products sold per hour to each type of customer'
with member as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Customer type` = 'Member'
group by `hour`
order by `hour` asc
), normal as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Customer type` = 'Normal'
group by `hour`
order by `hour` asc
)
select member.`hour` as `Hour`, member.`amount of sales` as `Amount of sales to member customers`,
normal.`amount of sales` as `Amount of sales to normal customers`
from member
join normal
on member.`hour` = normal.`hour`;

#Number of products sold per hour per branch
with A as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Branch` = 'A'
group by `hour`
order by `hour` asc
), B as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Branch` = 'B'
group by `hour`
order by `hour` asc
), C as
(
select hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Branch` = 'C'
group by `hour`
order by `hour` asc
)
select A.`hour` as `Hour`, A.`amount of sales` as `Amount of sales to customer of Branch A`,
B.`amount of sales` as `Amount of sales to customers of Branch B`,
C.`amount of sales` as `Amount of sales to customers of Branch C`
from A
join B
on A.`hour` = B.`hour`
join C
on C.`hour` = B.`hour`;

#Number of products sold per hour by product line
with `Electronic accessories` as
(
select Hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Electronic accessories'
group by `hour`
order by `hour`
), `Fashion accessories` as
(
select Hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Fashion accessories'
group by `hour`
order by `hour`
), `Food and beverages` as
(
select Hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Food and beverages'
group by `hour`
order by `hour`
), `Health and beauty` as 
(
select Hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Health and beauty'
group by `hour`
order by `hour`
), `Home and lifestyle` as 
(
select Hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Home and lifestyle'
group by `hour`
order by `hour`
), `Sports and travel` as 
(
select Hour(`Time`) as `hour`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Sports and travel'
group by `hour`
order by `hour`
)
select `Electronic accessories`.`hour` as `hour`, `Electronic accessories`.`amount of sales` as `amount of sales of Electronic accessories`,
`Fashion accessories`.`amount of sales` as `amount of sales of Fashion accessories`,
`Food and beverages`.`amount of sales` as `amount of sales of Food and beverages`,
`Health and beauty`.`amount of sales` as `amount of sales of Health and beauty`,
`Home and lifestyle`.`amount of sales` as `amount of sales of Home and lifestyle`,
`Sports and travel`.`amount of sales` as `amount of sales of Sports and travel`
from `Electronic accessories` 
join `Fashion accessories`
on `Electronic accessories`.`hour` = `Fashion accessories`.`hour`
join `Food and beverages`
on `Food and beverages`.`hour` = `Fashion accessories`.`hour`
join `Health and beauty`
on `Health and beauty`.`hour` = `Food and beverages`.`hour`
join `Home and lifestyle`
on `Home and lifestyle`.`hour` = `Health and beauty`.`hour`
join `Sports and travel`
on `Sports and travel`.`hour` = `Home and lifestyle`.`hour`;

# Quantities of each product line sold to each type of customer 
with member as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Customer type` = 'Member'
group by `Product line`
order by `Product line`
), normal as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Customer type` = 'Normal'
group by `Product line`
order by `Product line`
)
select member.`Product line` as `Product line`, member.`amount of sales` as `Amount of sales to member customers`,
normal.`amount of sales` as `Amount of sales to normal customers`
from member
join normal
on member.`Product line` = normal.`Product line`;

# Quantities of each product line sold to each gender
with female as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Gender` = 'Female'
group by `Product line`
order by `Product line`
), male as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Gender` = 'Male'
group by `Product line`
order by `Product line`
)
select female.`Product line` as `Product line`, female.`amount of sales` as `Amount of sales to female Gender`,
male.`amount of sales` as `Amount of sales to male gender`
from female
join male
on female.`Product line` = male.`Product line`;

#Quantities of each product line sold by payment method
with `cash` as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Payment` = 'Cash'
group by `Product line`
order by `Product line`
), `credit card` as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Payment` = 'Credit card'
group by `Product line`
order by `Product line`
), `Ewallet` as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Payment` = 'Ewallet'
group by `Product line`
order by `Product line`
)
select `cash`.`Product line` as `Product line`, `cash`.`amount of sales` as `Amount of sales through cash`,
`credit card`.`amount of sales` as `Amount of sales through credit card`,
`ewallet`.`amount of sales` as `Amount of sales through ewallet`
from `cash`
join `credit card`
on `cash`.`Product line` = `credit card`.`Product line`
join `ewallet`
on `ewallet`.`Product line` = `credit card`.`Product line`;

#Quantities of each product line sold in each branch
with A as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Branch` = 'A'
group by `Product line`
order by `Product line`
), B as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Branch` = 'B'
group by `Product line`
order by `Product line`
), C as
(
select `Product line`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Branch` = 'C'
group by `Product line`
order by `Product line`
)
select A.`Product line` as `Product line`, A.`amount of sales` as `Amount of sales through branch A`,
B.`amount of sales` as `Amount of sales through branch B`,
C.`amount of sales` as `Amount of sales through branch C`
from A
join B
on A.`Product line` = B.`Product line`
join C
on C.`Product line` = B.`Product line`;

#Quantity sold of each product line based on valuation (rounded)
with `Electronic accessories` as
(
select round(`Rating`) as `valuation`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Electronic accessories'
group by `valuation`
order by `valuation`
), `Fashion accessories` as
(
select round(`Rating`) as `valuation`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Fashion accessories'
group by `valuation`
order by `valuation`
), `Food and beverages` as
(
select round(`Rating`) as `valuation`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Food and beverages'
group by `valuation`
order by `valuation`
), `Health and beauty` as 
(
select round(`Rating`) as `valuation`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Health and beauty'
group by `valuation`
order by `valuation`
), `Home and lifestyle` as 
(
select round(`Rating`) as `valuation`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Home and lifestyle'
group by `valuation`
order by `valuation`
), `Sports and travel` as 
(
select round(`Rating`) as `valuation`, sum(`Quantity`) as `amount of sales`
from projects.super_market_sales
where `Product line` = 'Sports and travel'
group by `valuation`
order by `valuation`
)
select `Electronic accessories`.`valuation` as `Valuation (rounded)`, `Electronic accessories`.`amount of sales` as `amount of sales of Electronic accessories`,
`Fashion accessories`.`amount of sales` as `amount of sales of Fashion accessories`,
`Food and beverages`.`amount of sales` as `amount of sales of Food and beverages`,
`Health and beauty`.`amount of sales` as `amount of sales of Health and beauty`,
`Home and lifestyle`.`amount of sales` as `amount of sales of Home and lifestyle`,
`Sports and travel`.`amount of sales` as `amount of sales of Sports and travel`
from `Electronic accessories` 
join `Fashion accessories`
on `Electronic accessories`.`valuation` = `Fashion accessories`.`valuation`
join `Food and beverages`
on `Food and beverages`.`valuation` = `Fashion accessories`.`valuation`
join `Health and beauty`
on `Health and beauty`.`valuation` = `Food and beverages`.`valuation`
join `Home and lifestyle`
on `Home and lifestyle`.`valuation` = `Health and beauty`.`valuation`
join `Sports and travel`
on `Sports and travel`.`valuation` = `Home and lifestyle`.`valuation`;

#Billing based on branch
select `Branch`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `Branch`
order by `Branch`;

#Billing based on gender 
select `Gender`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `Gender`;

#Billing based on the type of client
select `Customer type`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `Customer type`;

#Dates that were Sunday and billing for those dates
select `Date` as `Sundays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Sunday' 
group by `Sundays`
order by `Sundays`;

#Dates that were Monday and billing for those dates
select `Date` as `Mondays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Monday' 
group by `Mondays`
order by `Mondays`;

#Dates that were Tuesday and billing for those dates
select `Date` as `Tuesdays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Tuesday' 
group by `Tuesdays`
order by `Tuesdays`;

#Dates that were Wednesdays and billing for those dates
select `Date` as `Wednesdays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Wednesday' 
group by `Wednesdays`
order by `Wednesdays`;

#Dates that were Thursday and billing for those dates
select `Date` as `Thursdays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Thursday' 
group by `Thursdays`
order by `Thursdays`;

#Dates that were Friday and billing for those dates
select `Date` as `Fridays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Friday' 
group by `Fridays`
order by `Fridays`;

#Dates that were Saturday and billing for those dates:')
select `Date` as `Saturdays`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where dayname(`Date`) = 'Saturday' 
group by `Saturdays`
order by `Saturdays`;

#Billing based on date 
select `Date`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `Date`
order by `Date`;

#Billing based on the date (of each branch)
with A as
(
select `Date`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Branch` = 'A'
group by `Date`
order by `Date`
), B as
(
select `Date`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Branch` = 'B'
group by `Date`
order by `Date`
), C as
(
select `Date`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Branch` = 'C'
group by `Date`
order by `Date`
)
select A.`Date`, A.`Billing` as `Billing of branch A`,  B.`Billing` as `Billing of branch B`,
 C.`Billing` as `Billing of branch C`
from A
join B 
on A.`Date` = B.`Date`
join C
on C.`Date` = B.`Date`;

#Billing based on the hour
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `hour`
order by `hour`;

#Billing based on the day
select Dayname(`Date`) as `day`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `day`
order by `day`;

#Billing based on the hour (for each branch)
with A as 
(
select hour(`Time`) as `hour`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'A'
group by `hour`
order by `hour`
), B as 
(
select hour(`Time`) as `hour`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'B'
group by `hour`
order by `hour`
), C as
(
select hour(`Time`) as `hour`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'C'
group by `hour`
order by `hour`
)
select A.`hour`, A.billing as `billing of branch A`, B.billing as `billing of branch B`, C.billing as `billing of branch C`
from A
join B
on A.`hour` = B.`hour`
join C
on C.`hour` = B.`hour`;

#Billing based on the day (of each branch)
with A as 
(
select dayname(`Date`) as `day`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'A'
group by `day`
order by `day`
), B as 
(
select dayname(`Date`) as `day`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'B'
group by `day`
order by `day`
), C as
(
select dayname(`Date`) as `day`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'C'
group by `day`
order by `day`
)
select A.`day`, A.billing as `billing of branch A`, B.billing as `billing of branch B`, C.billing as `billing of branch C`
from A
join B
on A.`day` = B.`day`
join C
on C.`day` = B.`day`;

#Billing obtained from each product line based on time
with `Electronic accessories` as
(
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Electronic accessories'
group by `hour`
order by `hour`
), `Fashion accessories` as
(
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Fashion accessories'
group by `hour`
order by `hour`
), `Food and beverages` as
(
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Food and beverages'
group by `hour`
order by `hour`
), `Health and beauty` as 
(
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Health and beauty'
group by `hour`
order by `hour`
), `Home and lifestyle` as 
(
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Home and lifestyle'
group by `hour`
order by `hour`
), `Sports and travel` as 
(
select Hour(`Time`) as `hour`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Sports and travel'
group by `hour`
order by `hour`
)
select `Electronic accessories`.`hour` as `hour`, `Electronic accessories`.`Billing` as `Billing of Electronic accessories`,
`Fashion accessories`.`Billing` as `Billing of Fashion accessories`,
`Food and beverages`.`Billing` as `Billing of Food and beverages`,
`Health and beauty`.`Billing` as `Billing of Health and beauty`,
`Home and lifestyle`.`Billing` as `Billing of Home and lifestyle`,
`Sports and travel`.`Billing` as `Billing of Sports and travel`
from `Electronic accessories` 
join `Fashion accessories`
on `Electronic accessories`.`hour` = `Fashion accessories`.`hour`
join `Food and beverages`
on `Food and beverages`.`hour` = `Fashion accessories`.`hour`
join `Health and beauty`
on `Health and beauty`.`hour` = `Food and beverages`.`hour`
join `Home and lifestyle`
on `Home and lifestyle`.`hour` = `Health and beauty`.`hour`
join `Sports and travel`
on `Sports and travel`.`hour` = `Home and lifestyle`.`hour`;

#Billing based on the product line
select `Product line`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `Product line`;

#Billing based on the type of product (classified by branches)
with A as 
(
select `Product line`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'A'
group by `Product line`
order by `Product line`
), B as 
(
select `Product line`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'B'
group by `Product line`
order by `Product line`
), C as
(
select `Product line`, round(sum(`Total`), 2) as billing
from projects.super_market_sales
where Branch = 'C'
group by `Product line`
order by `Product line`
)
select A.`Product line`, A.billing as `billing of branch A`, B.billing as `billing of branch B`,
C.billing as `billing of branch C`
from A
join B
on A.`Product line` = B.`Product line`
join C
on C.`Product line` = B.`Product line`;

#Billing based on the valuation of each product line
with `Electronic accessories` as
(
select round(`Rating`) as `valuation`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Electronic accessories'
group by `valuation`
order by `valuation`
), `Fashion accessories` as
(
select round(`Rating`) as `valuation`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Fashion accessories'
group by `valuation`
order by `valuation`
), `Food and beverages` as
(
select round(`Rating`) as `valuation`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Food and beverages'
group by `valuation`
order by `valuation`
), `Health and beauty` as 
(
select round(`Rating`) as `valuation`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Health and beauty'
group by `valuation`
order by `valuation`
), `Home and lifestyle` as 
(
select round(`Rating`) as `valuation`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Home and lifestyle'
group by `valuation`
order by `valuation`
), `Sports and travel` as 
(
select round(`Rating`) as `valuation`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
where `Product line` = 'Sports and travel'
group by `valuation`
order by `valuation`
)
select `Electronic accessories`.`valuation` as `Valuation (rounded)`, `Electronic accessories`.`Billing` as `Billing of Electronic accessories`,
`Fashion accessories`.`Billing` as `Billing of Fashion accessories`,
`Food and beverages`.`Billing` as `Billing of Food and beverages`,
`Health and beauty`.`Billing` as `Billing of Health and beauty`,
`Home and lifestyle`.`Billing` as `Billing of Home and lifestyle`,
`Sports and travel`.`Billing` as `Billing of Sports and travel`
from `Electronic accessories` 
join `Fashion accessories`
on `Electronic accessories`.`valuation` = `Fashion accessories`.`valuation`
join `Food and beverages`
on `Food and beverages`.`valuation` = `Fashion accessories`.`valuation`
join `Health and beauty`
on `Health and beauty`.`valuation` = `Food and beverages`.`valuation`
join `Home and lifestyle`
on `Home and lifestyle`.`valuation` = `Health and beauty`.`valuation`
join `Sports and travel`
on `Sports and travel`.`valuation` = `Home and lifestyle`.`valuation`;

#Billing by payment
select `Payment` as `Payment method`, round(sum(`Total`), 2) as `Billing`
from projects.super_market_sales
group by `Payment method`;

#The income of every product is 4.7619% of the billing