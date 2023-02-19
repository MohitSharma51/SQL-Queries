
-- What is the total amount each customer spent at the restaurant?
SELECT customer_id, sum(menu.price) AS total_spent_by_customer FROM sales
JOIN menu ON sales.product_id=menu.product_id
GROUP BY customer_id;


-- How many days has each customer visited the restaurant?
SELECT customer_id, count(DISTINCT(order_date)) AS 'No_of_visits'
FROM sales
GROUP BY customer_id;


-- What was the first item from the menu purchased by each customer?
WITH ordered_sales_cte AS
(
  SELECT customer_id, order_date, m.product_name,
RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS 'Order_number'
FROM sales s
JOIN menu m on s.product_id = m.product_id
)
SELECT customer_id, product_name
FROM ordered_sales_cte
WHERE Order_number = 1
GROUP BY customer_id, product_name;


--What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1 (COUNT(s.product_id)) AS most_purchased, m.product_name
FROM sales s
JOIN menu m on s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY most_purchased DESC;


-- Which item was the most popular for each customer?
WITH cte_popular_dish AS
(
  SELECT s.customer_id, m.product_name, COUNT(m.product_id) as 'favourite_dish',
DENSE_RANK() over(partition by s.customer_id ORDER BY count(m.product_id) DESC) AS rank		
FROM sales s
join menu m on s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
)
SELECT customer_id, product_name, favourite_dish
FROM cte_popular_dish WHERE rank = 1;


-- Which item was purchased first by the customer after they became a member?
WITH cte_first_purchase AS
(
  SELECT s.customer_id, mbr.join_date, s.order_date, s.product_id,
DENSE_RANK() OVER(Partition by s.customer_id ORDER BY s.order_date) AS rank FROM sales s
JOIN members mbr ON s.customer_id = mbr.customer_id
WHERE  s.order_date >= mbr.join_date
)
SELECT s.customer_id, s.order_date, m.product_name FROM cte_first_purchase AS s
JOIN menu AS m
ON s.product_id = m.product_id
WHERE rank = 1;


-- Which item was purchased just before the customer became a member?
WITH cte_purchase_before_member AS
(
  SELECT s.customer_id, mbr.join_date, s.order_date, s.product_id,
DENSE_RANK() OVER(partition by s.customer_id ORDER BY s.order_date) AS rank FROM sales s
JOIN members mbr ON
s.customer_id = mbr.customer_id
WHERE s.order_date < mbr.join_date
)
SELECT customer_id, join_date, order_date, m.product_name FROM cte_purchase_before_member AS s
JOIN menu m ON s.product_id = m.product_id
WHERE rank = 1;


-- What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, count(s.product_id) AS total_items_purchased, sum(m.price) AS amount_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mbr ON mbr.customer_id = s.customer_id
WHERE s.order_date < mbr.join_date
GROUP BY s.customer_id;


-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH cte_points AS
(
  SELECT *,
CASE WHEN m.product_id = 1 THEN (m.price*20) ELSE (m.price*10) END AS points
FROM menu m
)
SELECT s.customer_id, sum(p.points) AS total_points_earned FROM cte_points AS p
JOIN sales s ON p.product_id = s.product_id
GROUP BY s.customer_id;

-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?*/
WITH cte_points AS
(
  SELECT s.customer_id, mbr.join_date, s.order_date, (day(order_date) - day(join_date)) AS 'difference',
s.product_id, m.price, (m.price*20) AS 'points_earned'
FROM sales s
JOIN members mbr ON s.customer_id = mbr.customer_id
JOIN menu m ON s.product_id = m.product_id
)
SELECT customer_id, sum(points_earned) AS 'points_earned_by_member' FROM cte_points
WHERE difference BETWEEN 0 AND 7
GROUP BY customer_id;


-- Bonus question (join all the things)
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN join_date IS NOT NULL THEN 'Y' ELSE 'N' END AS Member
FROM sales s
JOIN menu m on s.product_id=m.product_id
LEFT JOIN members mbr ON s.customer_id = mbr.customer_id;

WITH cte_ranking AS
(
  SELECT s.customer_id, mbr.join_date, s.order_date, m.product_name, m.price,
CASE WHEN join_date <= order_date THEN 'Y'
WHEN join_date > order_date THEN 'N'
ELSE 'N'
END AS Member
FROM sales s
JOIN menu m ON s.product_id=m.product_id
LEFT JOIN members mbr ON s.customer_id = mbr.customer_id
)
SELECT *, CASE WHEN Member = 'N'
THEN null ELSE DENSE_RANK() OVER (partition by customer_id, member ORDER BY order_date) END AS ranking
FROM cte_ranking;


-- Aditional questions from my side

-- How much each customer spent as compared to average spent?
WITH cte_avg AS
(
  SELECT customer_id, sum(m.price) AS 'total_spent', avg(m.price) AS 'avg_spent' FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY customer_id
)
SELECT customer_id, total_spent, avg_spent, 
(total_spent - avg_spent) AS diff_spent_vs_average
FROM cte_avg
GROUP BY customer_id, total_spent, avg_spent;



-- What was the spent done by customer before and after the membership?
WITH cte_spent AS
(
  SELECT
s.customer_id,
CASE WHEN order_date < join_date THEN SUM(price) ELSE 0 END AS 'before_membership',
CASE WHEN order_date >= join_date THEN SUM(price) ELSE 0 END AS 'after_membership'
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mbr ON s.customer_id = mbr.customer_id
GROUP BY s.customer_id, s.order_date, mbr.join_date
)
SELECT customer_id, sum(before_membership) AS spent_before_membership, sum(after_membership) AS spent_after_membership
FROM cte_spent
GROUP BY customer_id;