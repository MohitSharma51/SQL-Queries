-- USE Kaggle

/*ALTER TABLE ATC_drugs

ADD Drug_Id NVARCHAR(10)

UPDATE ATC_drugs SET Drug_id = 3 WHERE Drug_name = 'N02BA'
UPDATE ATC_drugs SET Drug_id = 4 WHERE Drug_name = 'N02BE'
UPDATE ATC_drugs SET Drug_id = 5 WHERE Drug_name = 'N05B'
UPDATE ATC_drugs SET Drug_id = 6 WHERE Drug_name = 'N05C'
UPDATE ATC_drugs SET Drug_id = 7 WHERE Drug_name = 'R03'
UPDATE ATC_drugs SET Drug_id = 8 WHERE Drug_name = 'R06'*/

-- Pivoting the records
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'M01AB', Sales = M01AB INTO atc FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'M01AE', Sales = M01AE FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'N02BA', Sales = N02BA FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'N02BE', Sales = N02BE FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'N05B', Sales = N05B FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'N05C', Sales = N05C FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'R03', Sales = R03 FROM salesmonthly
UNION
SELECT CAST(datum as date) AS Sales_date, Drug_name = 'R06', Sales = R06 FROM salesmonthly


-- Calculating the total units sold. 2019 data includes data till October 2019 only

SELECT SUM(CAST (Units AS INT)) AS overall_units_sold
FROM ATC_drugs;


-- Calculating the total units sold each year. 2019 data includes data till October 2019 only

SELECT DATEPART(year, Sales_date) AS sales_year, SUM(CAST (Units AS INT)) AS overall_units_sold
FROM ATC_drugs
GROUP BY DATEPART(year, Sales_date);


-- Calculating the total units sold by each drug category

SELECT drug_name, SUM(CAST (Units AS INT)) AS overall_units_sold
FROM ATC_drugs
GROUP BY Drug_name
ORDER BY overall_units_sold DESC;


-- Calculating the total units sold every month

SELECT CONCAT(FORMAT(Sales_date, 'MMM'),'-',DATEPART(year, Sales_date)) AS sales_date,
SUM(CAST (Units AS INT)) AS Monthly_units_sold
FROM ATC_drugs
GROUP BY Sales_date


-- Calculating month-on-month growth of total units sold along with growth in percentage

-- Grouping by units at the monthly level. Converting sales_date from 'yyyy-mm-dd' format to 'mmm-yyyy' format
WITH cte AS (
SELECT sales_date, CONCAT(FORMAT(Sales_date, 'MMM'),'-',DATEPART(year, Sales_date)) AS s_date,
SUM(CAST (Units AS INT)) AS Monthly_units_sold
FROM ATC_drugs
GROUP BY Sales_date)
-- Using LAG function to get previous month sales to compare the units sold difference between previos month and current month
,cte2 AS (SELECT *, LAG(monthly_units_sold,1) OVER (ORDER BY sales_date) AS previous_month
FROM cte)
-- Subtracting current month units from previous month to get the month on month growth
SELECT s_date, monthly_units_sold, previous_month_units, monthly_units_sold - previous_month_units AS units_difference,
CASE WHEN previous_month_units = 0 THEN 0 ELSE CAST((1.0*(monthly_units_sold - previous_month_units)/previous_month_units)*100 AS DECIMAL(19,2)) END AS pct_growth
FROM (
SELECT s_date, monthly_units_sold, COALESCE(previous_month,0) AS previous_month_units
FROM cte2) tt


-- Calculating month-on-month growth of units sold of each drug category 
WITH CTE_wdw AS
(SELECT Drug_id, Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)) AS mnth_yr, Drug_name,
SUM (CAST (Units AS INT)) AS current_mnth_units
FROM ATC_drugs
GROUP BY Sales_date, drug_id, Drug_name,Units)
, cte1 AS (SELECT cte_wdw.*,
LAG(current_mnth_units,1,0) OVER (PARTITION BY drug_id ORDER BY sales_date) AS pvs_month_units FROM CTE_wdw)
SELECT Drug_id, mnth_yr, Drug_name, current_mnth_units, pvs_month_units, CASE WHEN pvs_month_units = 0 THEN '-' ELSE (current_mnth_units - pvs_month_units) END AS Units_difference,
CASE WHEN pvs_month_units = 0 THEN 0 ELSE CAST((1.0*(current_mnth_units - pvs_month_units)/pvs_month_units)*100 AS DECIMAL(19,2)) END AS pct_growth
FROM cte1



-- Comparing units sold of each drug category vs. avg. units in each month

-- Calculating total units sold of each drug, and average units sold at monthly level
WITH CTE_wdw AS
(SELECT Drug_id, Drug_name, Sales_date, CONCAT(FORMAT(sales_date,'MMM'),'-',DATEPART(year,sales_date)) AS s_dte,
SUM (CAST (Units AS INT)) AS Total_units_sold,
AVG(CAST (Units AS INT)) OVER(PARTITION BY Sales_date ORDER BY Sales_date) AS Avg_units_sold
FROM ATC_drugs
GROUP BY Sales_date, drug_id, Drug_name,Units)
-- Calculating total units sold vs. average units sold
SELECT Drug_id, Drug_name, s_dte, Total_units_sold, Avg_units_sold,
Total_units_sold - Avg_units_sold AS 'Total_units_vs_Avg_units'
FROM CTE_wdw


-- Ranking the drug category according to the units sold in each month. Drug category with the highest units is ranked first 

-- Grouping BY units at Drug_id, Sales_date level
WITH CTE_wdw AS
(SELECT Drug_id, Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)) AS mnth_yr, Drug_name,
SUM (CAST (Units AS INT)) AS Total_units_sold
FROM ATC_drugs
GROUP BY Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)),drug_id, Drug_name,Units)
-- Ranking the total units sold on monthly basis
SELECT Drug_id, Drug_name, mnth_yr, Total_units_sold,
RANK() OVER(PARTITION BY Sales_date ORDER BY Total_units_sold DESC) AS 'Units_rank'
FROM CTE_wdw


-- Calculating how many times each drug category has acquired particular rank on basis of units sold monthly

-- Grouping BY units at Drug_id, Sales_date level
WITH CTE_wdw AS
(SELECT Drug_id, Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)) AS mnth_yr, Drug_name,
SUM (CAST (Units AS INT)) AS Total_units_sold
FROM ATC_drugs
GROUP BY Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)),drug_id, Drug_name,Units)
-- Ranking the total units sold on monthly basis
,cte2 AS (
SELECT Drug_id, Drug_name, mnth_yr, Total_units_sold,
RANK() OVER(PARTITION BY Sales_date ORDER BY Total_units_sold DESC) AS 'Units_rank'
FROM CTE_wdw)
-- Counting how many times a drug achieved a particular rank
SELECT Drug_name, COUNT(CASE WHEN Units_rank = 1 THEN Units_rank END) AS rank_1,
COUNT(CASE WHEN Units_rank = 2 THEN Units_rank END) AS rank_2,
COUNT(CASE WHEN Units_rank = 3 THEN Units_rank END) AS rank_3,
COUNT(CASE WHEN Units_rank = 4 THEN Units_rank END) AS rank_4,
COUNT(CASE WHEN Units_rank = 5 THEN Units_rank END) AS rank_5,
COUNT(CASE WHEN Units_rank = 6 THEN Units_rank END) AS rank_6,
COUNT(CASE WHEN Units_rank = 7 THEN Units_rank END) AS rank_7,
COUNT(CASE WHEN Units_rank = 8 THEN Units_rank END) AS rank_8
FROM cte2
GROUP BY Drug_name


-- Calculating monthly market share of each drug category 

-- Grouping BY units at drug name, and sales date
WITH CTE_wdw AS
(SELECT Drug_id, Drug_name, Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)) AS mnth_yr,
SUM (CAST (Units AS INT)) AS Total_units_sold,
SUM(CAST (Units AS INT)) OVER(PARTITION BY Sales_date ORDER BY Sales_date) AS Monthly_units_sold
FROM ATC_drugs
GROUP BY Sales_date, drug_id, Drug_name,Units)
-- Dividing monthly units of brand sold by total units sold in the month to get the market share
SELECT Drug_id, Drug_name, mnth_yr, Total_units_sold,Monthly_units_sold, CAST((1.0*Total_units_sold/Monthly_units_sold*100) AS decimal(19,2)) AS 'Market_Share'
FROM CTE_wdw
ORDER BY sales_date, total_units_sold DESC, market_share DESC


-- Calculating monthly moving units at drug category level

-- Grouping By units at drug name, and sales date
WITH cte AS (
SELECT Drug_id, Drug_name, Sales_date, CONCAT(FORMAT(Sales_date,'MMM'),'-',DATEPART(year,Sales_date)) AS mnth_yr, SUM(CAST (Units AS INT)) AS total_units_sold
FROM ATC_drugs
GROUP BY Drug_id,Drug_name,Sales_date)
-- Applying SUM as window function on total units sold over drug name, and sales date
SELECT Drug_id, Drug_name, mnth_yr, total_units_sold, SUM(total_units_sold) OVER (PARTITION BY drug_name ORDER BY Sales_date) AS moving_sales
FROM cte
ORDER BY Drug_id, Drug_name,Sales_date


-- Month-on-Month growth at drug level




-- Calculating year-on-year growth of each other category. Percentage growth of 2019 is excluded as it has no full year data 

WITH cte1 AS (
SELECT drug_id, drug_name, SUM(CASE WHEN DATEPART(Year, Sales_date) = 2014 THEN CAST (units AS INT) END) AS units_2014,
SUM(CASE WHEN DATEPART(Year, Sales_date) = 2015 THEN CAST (units AS INT) END) AS units_2015,
SUM(CASE WHEN DATEPART(Year, Sales_date) = 2016 THEN CAST (units AS INT) END) AS units_2016,
SUM(CASE WHEN DATEPART(Year, Sales_date) = 2017 THEN CAST (units AS INT) END) AS units_2017,
SUM(CASE WHEN DATEPART(Year, Sales_date) = 2018 THEN CAST (units AS INT) END) AS units_2018
FROM ATC_drugs
GROUP BY drug_id, drug_name)
-- Calculating growth percentage. Excluding 2019 as data is available till October 2019 only
SELECT *, CAST((1.0*(units_2015 - units_2014)/units_2014)*100 AS decimal (19,2)) AS Growth_2015,
CAST((1.0*(units_2016 - units_2015)/units_2015)*100 AS decimal (19,2)) AS Growth_2016,
CAST((1.0*(units_2017 - units_2016)/units_2016)*100 AS decimal (19,2)) AS Growth_2017,
CAST((1.0*(units_2018 - units_2017)/units_2016)*100 AS decimal (19,2)) AS Growth_2018
FROM cte1

