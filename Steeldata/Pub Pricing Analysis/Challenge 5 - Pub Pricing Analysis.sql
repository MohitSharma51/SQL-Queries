--USE Steeldata_Pubs

--SELECT * FROM pubs;
--SELECT * FROM beverages;
--SELECT * FROM ratings;
--SELECT * FROM sales;

--1. How many pubs are located in each country??

SELECT Country, COUNT(1) AS no_of_pubs
FROM pubs
GROUP BY country;

--2. What is the total sales amount for each pub, including the beverage price and quantity sold?

WITH cte_pubs AS (
SELECT p.*,s.beverage_id, s.quantity, b.price_per_unit, (s.quantity * b.price_per_unit) AS total_cost
FROM sales s
JOIN beverages b
ON s.beverage_id = b.beverage_id
JOIN pubs p
ON s.pub_id = p.pub_id)
SELECT pub_id, pub_name, city, state, country, SUM(total_cost) AS total_sales
FROM cte_pubs
GROUP BY pub_id, pub_name, city, state, country

--3. Which pub has the highest average rating?

SELECT pub_id, pub_name, city, state, country, ROUND(AVG(rating),1) AS avg_rating FROM (
SELECT p.*, r.rating
FROM pubs p
JOIN ratings r
ON p.pub_id = r.pub_id) tt
GROUP BY pub_id, pub_name, city, state, country

--4. What are the top 5 beverages by sales quantity across all pubs?

WITH cte1 AS (
SELECT b.beverage_name, s.quantity
FROM beverages b
JOIN sales s
ON b.beverage_id = s.beverage_id)
SELECT Top 5 beverage_name, SUM(quantity) AS total_quantity
FROM cte1
GROUP BY beverage_name
ORDER BY total_quantity DESC

--5. How many sales transactions occurred on each date?

SELECT transaction_date, COUNT(1) AS total_transactions
FROM sales
GROUP BY transaction_date

--6. Find the name of someone that had cocktails and which pub they had it in.

SELECT p.*, r.customer_name
FROM pubs p
JOIN ratings r
ON p.pub_id = r.pub_id
JOIN sales s
ON r.pub_id = s.pub_id
JOIN beverages b
ON b.beverage_id = s.beverage_id
WHERE b.category = 'Cocktail'
ORDER BY p.pub_id

--7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?

SELECT category AS 'Beverage Category', AVG(price_per_unit) AS 'Average Price Per Unit'
FROM beverages
WHERE category NOT LIKE 'Spirit'
GROUP BY category 
ORDER BY AVG(price_per_unit) DESC;

--8. Which pubs have a rating higher than the average rating of all pubs?

SELECT p.*, r.rating
FROM pubs p
JOIN ratings r
ON p.pub_id = r.pub_id
WHERE r.rating > (SELECT ROUND(AVG(rating),1) FROM ratings)
ORDER BY pub_id

--9. What is the running total of sales amount for each pub, ordered by the transaction date?

WITH cte1 AS (
SELECT p.*,s.transaction_date,SUM((s.quantity*b.price_per_unit)) AS total_sales
FROM sales s
JOIN beverages b
ON s.beverage_id = b.beverage_id
JOIN pubs p
ON s.pub_id = p.pub_id
GROUP BY p.pub_id,p.pub_name, p.city,p.state,p.country,s.transaction_date)
SELECT *, SUM(total_sales) OVER (PARTITION BY pub_id ORDER BY transaction_date) AS running_sales
FROM cte1

--10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?

WITH cte1 AS (
SELECT p.country, b.category, ROUND(AVG(price_per_unit),2) AS country_avg_price
FROM beverages b
JOIN sales s
ON b.beverage_id = s.beverage_id
JOIN pubs p
ON p.pub_id = s.pub_id
GROUP BY p.country, b.category)
, cte2 AS (SELECT b.category, ROUND(AVG(price_per_unit),2) AS category_avg_price FROM beverages b
JOIN sales s
ON b.beverage_id = s.beverage_id
GROUP BY b.category)
SELECT cte1.*,cte2.category_avg_price
FROM cte1
JOIN cte2 ON
cte1.category = cte2.category
ORDER BY country, category

--11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?
WITH cte1 AS (
SELECT p.*,b.category, SUM(s.quantity * b.price_per_unit) AS cgry_sales
FROM beverages b
JOIN Sales s
ON b.beverage_id = s.beverage_id
JOIN pubs p
ON s.pub_id = p.pub_id
GROUP BY p.pub_id, p.pub_name, p.city, p.state, p.country, b.category)
,cte2 AS (
SELECT p.*, SUM(s.quantity * b.price_per_unit) AS pub_sales
FROM beverages b
JOIN Sales s
ON b.beverage_id = s.beverage_id
JOIN pubs p
ON s.pub_id = p.pub_id
GROUP BY p.pub_id, p.pub_name, p.city, p.state, p.country)
SELECT cte1.*, cte2.pub_sales, ROUND((1.0*cgry_sales/pub_sales*100),2) AS ctgry_contribution_prcnt
FROM cte1
JOIN cte2
ON cte1.pub_id = cte2.pub_id
ORDER BY pub_id

