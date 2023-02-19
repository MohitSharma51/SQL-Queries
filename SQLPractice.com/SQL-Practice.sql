--1.Find all inspections which are part of an inactive program.

select * FROM los_angeles_restaurant_health_inspections
WHERE program_status = 'INACTIVE';

/*2.Order all countries by the year they first participated in the Olympics.Output the National Olympics Committee (NOC) name along
with the desired year.Sort records by the year and the NOC in ascending order.*/

SELECT noc, year FROM olympics_athletes_events
ORDER BY year, noc;

/*3.Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by
customer's first name alphabetically.*/

SELECT first_name, SUM(od.total_order_cost) AS total_spent
FROM customers c
JOIN orders od ON od.cust_id=c.id
GROUP BY first_name
ORDER BY first_name;

/*4.Find the gender that has made the most number of doctor appointments. Output the gender along with the corresponding number of appointments.*/

SELECT TOP 1 gender FROM medical_appointments;

/*5.Find the total number of records that belong to each variety in the dataset.
Output the variety along with the corresponding number of records. Order records by the variety in ascending order.*/

SELECT variety, count(*) AS total_records
FROM iris
GROUP BY variety
ORDER BY total_records DESC;

/*6.Find the total number of housing units completed for each year.
Output the year along with the total number of housings. Order the result by year in ascending order.*/

SELECT year, SUM(south+west+midwest+northeast) AS total_units_in_thousands
FROM housing_units_completed_us
GROUP BY year
ORDER BY year;

/*7.Find the number of rows for each review score earned by 'Hotel Arena'.
Output the hotel name (which should be 'Hotel Arena'), review score along with the corresponding number of rows with that score
for the specified hotel.Note: Number of housing units in thousands. */

SELECT hotel_name, average_score,count(average_score) AS frequency_of_review
FROM hotel_reviews
WHERE hotel_name = 'Hotel Arena'
GROUP BY hotel_name, average_score;

--8.Find the total AdWords earnings for each business type. Output the business types along with the total earnings.

SELECT business_type, SUM(adwords_earnings) AS total_earnings
FROM google_adwords_earnings
GROUP BY business_type;

/*9.Find the number of acquisitions that occurred in each quarter of each year.
Output the acquired quarter in YYYY-Qq format along with the number of acquisitions and
order results by the quarters with the highest number of acquisitions first.*/

SELECT acquired_quarter, COUNT(*)
FROM crunchbase_acquisitions
GROUP BY acquired_quarter
ORDER BY acquired_quarter;

--10. Find the number of Yelp businesses that sell pizza.

SELECT COUNT(business_id) AS No_of_business_selling_Pizza
FROM yelp_business
WHERE categories LIKE '%Pizza%';

/*11.Write a query to find which gender gives a higher average review score when writing reviews as guests.
Use the from_type column to identify guest reviews. Output the gender and their average review score.*/

SELECT gender, avg(review_score) AS avg_review_score
FROM airbnb_guests gts
JOIN airbnb_reviews rws on gts.guest_id = rws.to_user
GROUP BY gender;

--12.Find players who participated in the Olympics representing more than one team.Output the player name, team, games, sport, and the medal.

SELECT name, games, sport, medal 
FROM olympics_athletes_events
GROUP BY name, games, sport, medal 
HAVING COUNT(team) > 1;

--13.Find workers and their corresponding information from the table with an even number for their worker id.

SELECT * FROM worker WHERE worker_id%2 = 0;

--14.Find workers and their corresponding information from the table with an odd number for their worker id.

SELECT * FROM worker WHERE worker_id%2 != 0;

--15.Find the number of crime occurrences for each day of the week. Output the day alongside the corresponding crime count.

SELECT day_of_week, count(*) AS no_of_crime_occurence
FROM sf_crime_incidents_2014_01
GROUP BY day_of_week;

--16.What is the total sales revenue of Samantha and Lisa?

SELECT salesperson, SUM(sales_revenue) As total_revenue
FROM sales_performance
WHERE salesperson IN ('Lisa','Samantha')
GROUP BY salesperson;

--17.Find the total number of searches for houses in Westlake neighborhood with a TV among the amenities.

SELECT COUNT(*) AS total_no_of_searches
FROM airbnb_search_details
WHERE neighbourhood = 'Westlake'
AND amenities LIKE '%TV%';

--18.Find the number of relationships that user  with id == 1 is not part of.

SELECT COUNT(*) AS relationship_excluding_1 FROM (SELECT CONCAT(user1,user2) AS rtl
FROM facebook_friends
WHERE user1!= 1 AND user2!= 1
GROUP BY rtl) AS temp; 

/*19.Find whether hosts or guests give higher review scores based on their average review scores.
Output the higher of the average review score rounded to the 2nd decimal spot (e.g., 5.11).*/

SELECT from_type, ROUND(AVG(review_score),2) AS avg_rating
FROM airbnb_reviews
GROUP BY from_type
ORDER BY avg_rating DESC
LIMIT 1;

/*20.Find the number of reviews received by Lo-Lo's Chicken & Waffles for each star.Output the number of stars
along with the corresponding number of reviews. Sort records by stars in ascending order.*/

SELECT COUNT(review_id) AS total_reviews
FROM yelp_reviews
WHERE business_name = 'Lo-Lo''s Chicken & Waffles';

--21.Find the number of 5-star reviews earned by Lo-Lo's Chicken & Waffles.

select COUNT(*) FROM yelp_reviews
WHERE Stars = '5'
AND (business_name = 'Lo-Lo''s Chicken & Waffles');

/*22.Cast stars column values to integer and return with all other column values. Be aware that certain rows contain non integer values.
You need to remove such rows. You are allowed to examine and explore the dataset before making a solution.*/

SELECT *, CAST(stars AS INT) from yelp_reviews
WHERE stars != '?';

--23. Find records with the value '?' in the stars column.

SELECT * FROM yelp_reviews WHERE stars = '?';

/*24.Find the number of entries per star. Output each number of stars along with the corresponding number of entries.
Order records by stars in ascending order.*/

SELECT stars, COUNT(*) AS no_of_entries FROM yelp_reviews
GROUP BY stars
ORDER BY stars;

--25.Find the number of open businesses.

SELECT COUNT(is_open) AS no_of_open_business
FROM yelp_business
WHERE is_open = 1;

--26.Find the review count for one-star businesses from yelp.Output the name along with the corresponding review count.

SELECT stars, count(review_count) AS review_count
FROM yelp_business
WHERE stars = 1
GROUP BY stars;

--27.Find the number of US-based wineries that have expensive wines.A wine is considered to be expensive if its price is $200 or more.

SELECT COUNT(id) AS US_wineries_with_expensive_wines
FROM winemag_p1
WHERE country = 'US'
AND price >=200;

--28.Find wine varieties tasted by 'Roger Voss' and with a value in the 'region_1' column of the dataset. Output unique variety names only.

SELECT DISTINCT(variety)
FROM winemag_p2
WHERE taster_name ='Roger Voss'
ORDER BY variety;

--29.Find all wine varieties which can be considered cheap based on the price. A variety is considered cheap if the price of a bottle lies between 5 to 20 USD.Output unique variety names only.

SELECT DISTINCT(variety) AS cheap_wines
FROM winemag_p1
WHERE price BETWEEN 5 AND 20
ORDER BY variety;

