
/*Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments.
Output just the absolute difference in salaries*/

SELECT ABS(MAX(salary) - MAX(salary1)) FROM
(SELECT MAX(salary))
FILTER (WHERE department = 'marketing') - MAX(salary) filter (WHERE department = 'engineering')) AS salary_diff
FROM db_employee emp
JOIN db_dept dept on emp.department_id = dept.id;

/*We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information.
Find the current salary of each employee assuming that salaries increase each year.
Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.*/

SELECT id, first_name, last_name, department_id, MAX(salary) AS latest_salary
FROM ms_employee_salary
GROUP BY id, first_name, last_name, department_id
ORDER BY id;

/*Find the last time each bike was in use. Output both the bike number and the date-timestamp
of the bike's last use (i.e., the date-time the bike was returned). Order the results by bikes that were most recently used.*/

SELECT bike_number, MAX(end_time) AS last_time_ride
FROM dc_bikeshare_q1_2012
GROUP BY bike_number;

-- Count the number of movies that Abigail Breslin nominated for oscar

SELECT COUNT(*) AS total_nominations
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin';

-- Find all posts which were reacted to with a heart

SELECT pst.post_id, pst.poster, pst.post_text, post_keywords, post_date
FROM facebook_posts pst
JOIN facebook_reactions reac
ON pst.post_id = reac.post_id
AND pst.poster = reac.poster
WHERE reac.reaction = 'heart'
GROUP BY pst.post_id,pst.poster, pst.post_text, post_keywords, post_date;

/* Meta/Facebook has developed a new programing language called Hack.To measure the popularity of Hack they ran a survey with their employees. The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly satisfaction with Hack. Due to an error location data was not collected, but your supervisor demands a report showing average popularity of Hack by office location. Luckily the user IDs of employees completing the surveys were stored.
Based on the above, find the average popularity of the Hack per office location.
Output the location along with the average popularity.*/

select location, Avg(hck.popularity) AS average_popularity
from facebook_employees emp
JOIN facebook_hack_survey hck
ON emp.id = hck.employee_id
GROUP BY location;

/*Find all Lyft drivers who earn either equal to or less than 30k USD or equal to or more than 70k USD. 
Output all details related to retrieved records.*/

SELECT index, start_date, end_date, yearly_salary
FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000
GROUP BY index, start_date, end_date, yearly_salary
ORDER BY yearly_salary;

/*Find how many times each artist appeared on the Spotify ranking list. Output the artist name along with the corresponding number of occurrences.
Order records by the number of occurrences in descending order.*/

SELECT artist, COUNT(position) AS no_of_appearance
FROM spotify_worldwide_daily_song_ranking
GROUP BY artist
ORDER BY no_of_appearance DESC;

-- Find the base pay for Police Captains. Output the employee name along with the corresponding base pay.

SELECT employeename, basepay
FROM sf_public_salaries
WHERE jobtitle = 'CAPTAIN III (POLICE DEPARTMENT)';

/*Find the details of each customer regardless of whether the customer made an order.
Output the customer's first name, last name, and the city along with the order details.
You may have duplicate rows in your results due to a customer ordering several of the same items.
Sort records based on the customer's first name and the order details in ascending order.*/

SELECT first_name, last_name, city, order_details
FROM customers c
LEFT JOIN orders od ON
od.cust_id = c.id
ORDER BY first_name, order_details;


/*Find libraries who haven't provided the email address in circulation year 2016 but their notice preference definition is set to email.
Output the library code.*/

SELECT DISTINCT(home_library_code)
FROM library_usage
WHERE circulation_active_year = 2016
AND notice_preference_definition = 'email'	
AND provided_email_address = 'FALSE';

/*Compare each employee's salary with the average salary of the corresponding department.
Output the department, first name, and salary of employees along with the average salary of that department.*/

SELECT department, first_name, salary, 
AVG(salary) OVER (PARTITION BY department)
from employee
GROUP BY department, first_name, salary;

/* Find order details made by Jill and Eva. Consider the Jill and Eva as first names of customers.
Output the order date, details and cost along with the first name. Order records based on the customer id in ascending order.*/

SELECT first_name, order_date, order_details, SUM(total_order_cost) AS order_cost
FROM orders od
JOIN customers c ON od.cust_id = c.id
WHERE first_name in ('Jill','Eva')
GROUP BY cust_id, c.first_name, order_date, order_details
ORDER BY cust_id;

/* Find the details of each customer regardless of whether the customer made an order.
Output the customer's first name, last name, and the city along with the order details.
You may have duplicate rows in your results due to a customer ordering several of the same items.
Sort records based on the customer's first name and the order details in ascending order.*/

SELECT first_name, last_name, city, order_details
from customers c
LEFT JOIN orders od ON
od.cust_id = c.id
ORDER BY first_name, order_details;

-- Find the activity date and the pe_description of facilities with the name 'STREET CHURROS' and with a score of less than 95 points.

SELECT activity_date, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE facility_name = 'STREET CHURROS'
AND SCORE < 95;

-- Find the most profitable company in the financial sector of the entire world along with its continent

SELECT company, continent
FROM forbes_global_2010_2014
WHERE sector = 'Financials'
AND profits = (SELECT MAX(profits) FROM forbes_global_2010_2014);

/*Count the number of user events performed by MacBookPro users. Output the result along with the event name.
Sort the result based on the event count in the descending order.*/

SELECT event_name, COUNT(*) AS event_count
FROM playbook_events
WHERE device = 'macbook pro'
GROUP BY event_name
ORDER BY event_count DESC;

/*Find the average number of bathrooms and bedrooms for each city’s property types.
Output the result along with the city name and the property type.*/

SELECT city, property_type, AVG(bedrooms) AS avg_no_bedrooms, AVG(bathrooms) AS avg_no_bathrooms
FROM airbnb_search_details
GROUP BY city, property_type;

/*Find the number of rows for each review score earned by 'Hotel Arena'. Output the hotel name (which should be 'Hotel Arena'),
review score along with the corresponding number of rows with that score for the specified hotel.*/

SELECT hotel_name, reviewer_score, COUNT(*) AS no_of_rows
FROM hotel_reviews
WHERE hotel_name = 'Hotel Arena'
GROUP BY hotel_name, reviewer_score
ORDER BY reviewer_score;
