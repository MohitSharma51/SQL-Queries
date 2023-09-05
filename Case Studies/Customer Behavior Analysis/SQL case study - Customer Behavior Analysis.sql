USE [SQL Case Study]

-- Data Preparation

--Question 1: What is the total number of rows in each of the 3 tables in database?

SELECT Count(*) AS 'Number of Records in Customer Table' From Tbl_Customer

SELECT Count(*) AS 'Number of Records in Product Category Table' From Tbl_procat

SELECT Count(*) AS 'Number of Records in Transaction table' From Tbl_transaction

-- Question 2: What is the total number of transactions that have return?

SELECT COUNT (qty) 'Transaction Returned' From Tbl_Transaction WHERE qty < 0

--Question 3: As you would have noticed, the dates provided across the datasets are not in a correct format.
-- As first steps, pls convert the date variables into valid date formats before proceeding ahead.

SELECT CONVERT(date, DOB, 105) As 'Date of Birth'
From tbl_customer; 
SELECT CONVERT(date, tran_date, 105) as 'Date of transaction' From Tbl_Transaction

--Question 4: What is the time range of the transaction data available for analysis?
--Show the output in number of days, months and years simultaneously in different columns.

SELECT DATEDIFF(day,MAX(convert(date,tran_date,105)),MIN(convert(date,tran_date,105))) as 'Number of days', 
       DATEDIFF(month,MAX(convert(date,tran_date,105)),MIN(convert(date,tran_date,105))) as 'Number of month',
      DATEDIFF(year,MAX(convert(date,tran_date,105)),MIN(convert(date,tran_date,105))) as 'Number of years'
      From tbl_transaction;

-- Question 5: Which product category does the subcategory "DIY" belongs to?

SELECT prod_cat as 'Product category', Prod_subcat as 'Product subcategory' From Tbl_procat WHERE Prod_subcat = 'DIY'

--  Data Analysis

-- Question 1: Which channel is most frequently used for transaction?

SELECT Top 1 Store_type, COUNT(Store_Type) AS 'Number of time channel used' From Tbl_Transaction Group BY Store_type Order By 'Number of time channel used' DESC

-- Question 2: What is the count of Male and Female customers in the database?

SELECT Gender, Count(Gender) AS 'Number of Customers by Gender' From Tbl_Customer WHERE GENDER IN ('M','F') Group By Gender Order By 'Number of Customers by Gender' DESC

-- Question 3: From which city do we have the maximum number of customers and how many?

SELECT Top 1 city_code, Count(city_code) AS 'Number of customers' From Tbl_Customer Group BY city_code Order By 'Number of customers' DESC

-- Question 4: How many sub-categories are there under Books category?

SELECT prod_cat as 'Product category', Count (prod_subcat) AS 'No. of sub-categories' From Tbl_procat WHERE prod_cat = 'Books' Group BY prod_cat

-- Question 5: What is the maximum quantity of products ever ordered?

SELECT pr.prod_cat as 'Product category', pr.prod_cat_code as 'Product category code',
Max (qty) AS 'Max. quantity purchased' From Tbl_Transaction as tr
Left JOIN Tbl_procat as pr ON tr.prod_cat_code = pr.prod_cat_code
Group BY pr.prod_cat_code, pr.prod_cat
Order By 'Max. quantity purchased' DESC


-- Question 6: What is the net total revenue generated in categories Electronics and Books?

SELECT  pr.prod_cat as 'Product category', pr.prod_cat_code as 'Product category code',
SUM(Cast(total_amt as numeric)) AS 'Revenue Generated' From Tbl_Transaction as tr
LEFT JOIN Tbl_procat as pr ON Tr.prod_cat_code = Pr.prod_cat_code
WHERE tr.prod_cat_code IN ('3','5')
Group BY pr.prod_cat, pr.prod_cat_code
Order By 'Revenue Generated' DESC


-- Question 7: How many customers have> 10 transactions with us, excluding returns

SELECT Cust_id as 'Customer ID', COUNT(cust_id) AS 'No. of Transaction' From Tbl_transaction
WHERE Cast (Qty as numeric) > 0
Group BY cust_id
Having COUNT(cust_id) > 10

-- Question 8: What is the combined revenue earned From the "Electronics" & Clothing" categories, From "Flagship stores"?

SELECT SUM(Cast (total_amt as numeric)) AS 'Combined Revenue'
From Tbl_Transaction WHERE prod_cat_code IN ('1','3') AND Store_type = 'Flagship store'

-- Question 9: What is the total revenue generated From "Male" customers in "electronics" category? Output should display total revenue by prod sub_cat?

SELECT prod_subcat as 'Product subcategory', SUM(cast(total_amt as numeric)) as 'Total revenue' From tbl_transaction as tr
Inner Join tbl_procat as pr ON tr.prod_subcat_code = pr.prod_sub_cat_code and tr.prod_cat_code = pr.prod_cat_code  
Inner join Tbl_customer on tr.cust_id = Tbl_customer.customer_Id
WHERE Gender = 'M' and prod_cat = 'Electronics'
Group by prod_subcat
Order By 'Total revenue' DESC

-- Question 10: What is percenage of sales and returns by product sub category;
-- display only top 5 sub categories in term of sales?

Select top 5 P.prod_subcat as 'Subcategory' ,
((Round(SUM(cast( case when T.Qty > 0 then T.Qty  else 0 end as float)),2))/
(Round(SUM(cast( case when T.Qty > 0 then T.Qty else 0 end as float)),2)
- Round(SUM(cast( case when T.Qty < 0 then T.Qty   else 0 end as float)),2)))*100 as 'Percentage of sales',
((Round(SUM(cast( case when T.Qty < 0 then T.Qty  else 0 end as float)),2))/
(Round(SUM(cast( case when T.Qty > 0 then T.Qty else 0 end as float)),2)
- Round(SUM(cast( case when T.Qty < 0 then T.Qty   else 0 end as float)),2)))*100 as 'Percentage of return'
From Tbl_Transaction as T
INNER JOIN Tbl_Procat as P ON T.prod_subcat_code = P.prod_sub_cat_code
Group by P.prod_subcat
Order By 'Percentage of sales' desc


-- Question 11: For all customers aged between 25 years to 35 years, find what is the total revenue generated by these 
-- consumers in last 30 days of transaction From max transaction available in the data?


SELECT SUM(cast(tr.total_amt as numeric)) as net_total_revenue
From (SELECT tr.*,
MAX(convert(date,tr.tran_date,105)) OVER () as max_tran_date From Tbl_Transaction as tr) tr
JOIN Tbl_customer as cr ON tr.cust_id = cr.customer_Id
WHERE convert(date,tr.tran_date,105) <= DATEADD(day, -30, tr.max_tran_date) AND 
convert(date,tr.tran_date,105) >= DATEADD(YEAR, 25, convert(date,cr.DOB,105)) AND
convert(date,tr.tran_date,105) < DATEADD(YEAR, 31, convert(date,cr.DOB,105))


--Question 12: Which product category has seen the max value of returns in the last 3 months of transactions?

Select Top 1 pr.prod_cat as 'Product category', pr.prod_cat_code as 'Product category code',
pr.prod_subcat as 'Product subcategory',pr.prod_sub_cat_code as 'Product subcategory code',
round(Max(Cast(total_amt AS float)),2) AS 'Max value of return'
From Tbl_Transaction as tr
JOIN tbl_procat as pr on pr.prod_sub_cat_code = tr.prod_subcat_code
WHERE Cast(total_amt AS float) < 0
Group BY pr.prod_cat, pr.prod_cat_code,pr.prod_sub_cat_code, pr.prod_subcat, TRAN_DATE 
Having  DATEDIFF(Day,convert(date,tr.Tran_date,105),convert(date,tr.tran_date,105)) BETWEEN 0 AND 90
Order By 'Max value of return'


--Question 13: Which store-type sells the maximum products; by value of sales amount and by quanity sold?

SELECT top 1 store_type as 'Store type', Count(cast(qty as numeric)) AS 'Quantity sold', Sum(cast(total_amt as numeric)) AS 'Sales amount'
From Tbl_Transaction WHERE QTY > 0
Group BY Store_type Order By 'Sales amount' DESC


-- Question 14: What are the categories for which average revenue is above all the overall average?

SELECT pr.prod_cat as 'Product category', AVG(cast(tr.total_amt as numeric)) AS 'Average Sales' From TbL_procat as pr
LEFT JOIN Tbl_Transaction as tr ON pr.prod_cat_code = tr.prod_cat_code WHERE cast(tr.total_amt as numeric) > 0
Group BY pr.prod_cat, Tr.total_amt
Having AVG(cast(tr.total_amt as numeric)) > (SELECT Avg(cast(total_amt as numeric)) From Tbl_Transaction)
Order By cast(tr.total_amt as numeric) DESC

-- Question 15: Find the average and total revenue by each subcategory for the categories which are among top 5 categories in term of quantity sold

SELECT p.prod_subcat as 'Product subcategory', AVG(Cast(total_amt as float)) as 'Average revenue',
SUM(Cast(total_amt as float)) as 'Total revenue' From Tbl_Transaction as T
Inner Join Tbl_Procat as p
ON T.prod_cat_code = P.prod_cat_code AND T.prod_subcat_code = P.prod_sub_cat_code
WHERE P.prod_cat IN (SELECT Top 5 p.prod_cat From Tbl_Procat as p
Inner Join tbl_transaction as T
ON P.prod_cat_code = T.prod_cat_code AND P.prod_sub_cat_code = T.prod_subcat_code
Group BY p.prod_cat
Order By Sum(cast(Qty as Int)) DESC)
Group BY p.prod_subcat