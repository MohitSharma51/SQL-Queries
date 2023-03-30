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

--25. Find the average number of stars for each state. Output the state name along with the corresponding average number of stars.

SELECT state, avg(stars) AS avg_stars
FROM yelp_business
GROUP BY state
ORDER BY state;

--26.Find the number of open businesses.

SELECT COUNT(is_open) AS no_of_open_business
FROM yelp_business
WHERE is_open = 1;

--27.Find the review count for one-star businesses from yelp.Output the name along with the corresponding review count.

SELECT stars, count(review_count) AS review_count
FROM yelp_business
WHERE stars = 1
GROUP BY stars;

--28.Find the number of US-based wineries that have expensive wines.A wine is considered to be expensive if its price is $200 or more.

SELECT COUNT(id) AS US_wineries_with_expensive_wines
FROM winemag_p1
WHERE country = 'US'
AND price >=200;

--29.Find wine varieties tasted by 'Roger Voss' and with a value in the 'region_1' column of the dataset. Output unique variety names only.

SELECT DISTINCT(variety)
FROM winemag_p2
WHERE taster_name ='Roger Voss'
ORDER BY variety;

--30.Find all wine varieties which can be considered cheap based on the price. A variety is considered cheap if the price of a bottle lies between 5 to 20 USD.Output unique variety names only.

SELECT DISTINCT(variety) AS cheap_wines
FROM winemag_p1
WHERE price BETWEEN 5 AND 20
ORDER BY variety;

--31 Find all top-rated wineries based on points. Consider a top-rated winery has been awarded points more or equal than 95.

SELECT winery, points FROM winemag_p1
WHERE points >= 95
GROUP BY winery, points
ORDER BY points DESC;

--32. Find prices for Spanish, Italian, and French wines. Output the price.

SELECT winery, country price from winemag_p1
WHERE country IN ('France', 'Italy', 'Spain')
GROUP BY winery, country, price
ORDER BY country ASC;

--33. Find the total costs and total customers acquired in each year. Output the year along with corresponding total money spent and total acquired customers.

SELECT year, SUM(customers_acquired) AS total_customers_acquired,
SUM(money_spent) as total_money_spent
FROM uber_advertising
GROUP BY year
ORDER BY year;

--34. Find the average cost of each request status.Request status can be either 'success' or 'fail'.Output the request status along with the average cost.

SELECT request_status, AVG(monetary_cost) AS avg_cost
FROM uber_ride_requests
GROUP BY request_status;

/*35. Find the average distance traveled in each hour. Output the hour along with the corresponding average traveled distance.
Sort records by the hour in ascending order*/

SELECT hour, AVG(travel_distance) AS avg_distance_covered
FROM lyft_rides
GROUP BY hour
ORDER BY hour;

--36. Find the hour with the highest gasoline cost. Assume there's only 1 hour with the highest gas cost.

SELECT hour, SUM(gasoline_cost) AS total_gasoline_cost
FROM lyft_rides
GROUP BY hour
ORDER BY total_gasoline_cost DESC
LIMIT 1;

--37. Find all Lyft rides which happened on rainy days before noon

SELECT index
FROM lyft_rides
WHERE (weather = 'rainy') AND (hour BETWEEN 0 AND 12);

--38. Find the advertising channel where Uber spent more than 100k USD in 2019.

SELECT advertising_channel
FROM uber_advertising
WHERE year = 2019 AND money_spent > 100000;

/*39. Find the cost per customer for each advertising channel and year combination. Include only channels that are advertised via public
transport (advertising channel includes "bus" substring). The cost per customer is equal to the total spent money divided by the
total number of acquired customers through that advertising channel. Output advertising channel and its cost per customer.*/

SELECT advertising_channel, year,
SUM(money_spent)/SUM(customers_acquired) AS cost_per_customer
FROM uber_advertising
WHERE advertising_channel LIKE '%bus%'
GROUP BY advertising_channel, year
ORDER BY year;

--40. Find the year that Uber acquired more than 2000 customers through celebrities

SELECT year
FROM uber_advertising
WHERE advertising_channel = 'celebrities'
GROUP BY year
HAVING SUM(customers_acquired) > 2000;

--41. Find songs that are ranked between 8-10.Output the track name along with the corresponding position, ordered ascendingly.

SELECT trackname, position
FROM spotify_worldwide_daily_song_ranking
WHERE position BETWEEN 8 AND 10
ORDER BY position;

--42. Find the total number of streams for the top 100 ranked songs.

SELECT SUM(streams) AS total_no_of_streams
FROM spotify_worldwide_daily_song_ranking
WHERE position BETWEEN 1 AND 100;

--43. Find the average number of streams across all songs.

SELECT trackname, AVG(streams) AS avg_no_of_streams
FROM spotify_worldwide_daily_song_ranking
GROUP BY trackname;

/*44.Find the top 10 ranked songs by position. Output the track name along with the corresponding position and sort records
by the position in descending order and track name alphabetically, as there are many tracks that are tied for the same position*/

SELECT trackname, position
FROM spotify_worldwide_daily_song_ranking
WHERE position BETWEEN 1 AND 10
GROUP BY trackname, position
ORDER BY position DESC, trackname;

/*45.Find songs with less than 2000 streams. Output the track name along with the corresponding streams.Sort records by streams in descending order.
There is no need to group rows with same track name*/

SELECT trackname, streams
FROM spotify_worldwide_daily_song_ranking
WHERE streams < 2000
ORDER BY streams DESC;

/*46. Find songs that have more than 3 million streams. Output the track name, artist, and the corresponding streams.Sort records based on streams
in descending order.*/

SELECT trackname
FROM spotify_worldwide_daily_song_ranking
GROUP BY trackname
HAVING SUM(streams) > 3000000
ORDER BY SUM(streams) DESC;

--47. Get the job titles of the 3 employees who received the most overtime pay.Output the job title of selected records.

SELECT jobtitle, SUM(overtimepay) AS total_overtimepay
FROM sf_public_salaries
GROUP BY jobtitle
ORDER BY total_overtimepay DESC
LIMIT 3;

/*48. Find all employees with a job title that contains 'METROPOLITAN TRANSIT AUTHORITY'
and output the employee's name along with the corresponding total pay with benefits.*/

SELECT employeename, SUM(totalpaybenefits) AS total_pay_benefits
FROM sf_public_salaries
WHERE jobtitle LIKE '%METROPOLITAN TRANSIT AUTHORITY%'
GROUP BY employeename;

--49. Find benefits that people with the name 'Patrick' have. Output the employee name along with the corresponding benefits.

SELECT employeename, SUM(benefits) AS total_benefits
FROM sf_public_salaries
WHERE employeename LIKE '%Patrick%'
GROUP BY employeename;

--50. Find job titles that had 0 hours of overtime. Output unique job title names.

SELECT DISTINCT(jobtitle)
FROM sf_public_salaries
WHERE overtimepay = 0
ORDER BY jobtitle;

/*51. Find quarterbacks with the most interceptions in 2016.
Output the quarterbacks along with the corresponding number of interceptions. Sort records by the interceptions in descending order.*/

SELECT qb AS quarterbacks, SUM(int) AS interceptions
FROM qbstats_2015_2016
WHERE year = 2016
GROUP BY quarterbacks
ORDER BY interceptions DESC;

/*52. Find the top 10 quarterbacks with the highest game points in 2016.
Output the quarterback along with the corresponding game points.
Order records based on game points in descending order and just output the top 10 rows
without considering any ties in game points that would result in more than 10 qbs in the output.*/

SELECT qb AS quaterbacks, SUM(game_points) AS gamepoints
FROM qbstats_2015_2016
WHERE year = 2016
GROUP BY quaterbacks
ORDER BY gamepoints DESC
LIMIT 10;

--53. Find the top 10 ratings quarterbacks received. Output the quarterback along with the corresponding rating.

SELECT qb, rate
FROM qbstats_2015_2016
ORDER BY qb, rate DESC;

/*54. Find Olympics games that the youngest and the oldest athletes participated in the history of Olympics.
Output all the details corresponding to each record.*/

SELECT * FROM olympics_athletes_events
WHERE age = (SELECT MAX(age) FROM olympics_athletes_events)
OR age = (SELECT MIN(age) FROM olympics_athletes_events)
ORDER BY age DESC; 

/*55. Find the history of each sport by finding the first year, last year, and the total number of years that sport played in the Olympics.
Output the sport name along with the first year, last year, and the total years.
Order records by the first year in descending order.*/

SELECT sport, MIN(year) AS first_year, MAX(year) AS last_year,
(MAX(year)-MIN(year)) AS total_years
FROM olympics_athletes_events
GROUP BY sport
ORDER BY first_year DESC;

/*56. Find the Olympic game which had the highest number of participants that didn't earn a medal.
Output the Olympic game name along with the corresponding number of athletes.
Olympic game name consists of the year and the season.*/

SELECT games, year, season, count(name) as total_participant
FROM olympics_athletes_events
WHERE medal IS NULL
GROUP BY games, year, season
ORDER BY total_participant DESC
LIMIT 1;

/*57. Find the lowest, average, and the highest ages of athletes across all Olympics.
HINT: If athlete participated in more than one discipline at one Olympic games, consider it as a separate athlete,
no need to remove such edge cases.*/

SELECT games, sport,
MIN(age) AS lowest_age, ROUND(AVG(age),1) AS average_age, MAX(age) AS highest_age
FROM olympics_athletes_events
WHERE season = 'Winter' AND age IS NOT NULL
GROUP BY games, sport;

--58. Find events of any Winter Olympics in which there were athletes of height between 180 to 210 centimeters. Output unique events only.

SELECT DISTINCT(event)
FROM olympics_athletes_events
WHERE (height BETWEEN 180 AND 210) AND (games LIKE '%Winter%');

--59. Find all athletes who were older than 40 years when they won either Bronze or Silver medals

SELECT name
FROM olympics_athletes_events
WHERE age > 40
AND medal IN ('Silver', 'Bronze');

/*60. Find all minor that participated in Olympics games. A player is considered as a minor if he or she is older less or equal than 18 years.
Output the name and age of the player along with participated Olympic games (ex: 1992 Summer).*/

SELECT name, age, games
FROM olympics_athletes_events
WHERE age <=18;

--61. Find all events participated by Christine Jacoba Aaftink.Output unique values only.

SELECT DISTINCT(event)
FROM olympics_athletes_events
WHERE name = 'Christine Jacoba Aaftink';

--62. Find the athletes who competed in swimming events at the London Olympics.

SELECT name
FROM olympics_athletes_events
WHERE city = 'London' AND event LIKE '%Swimming%';

--63. Find all Danish athletes who won a medal. Output unique names only.

SELECT DISTINCT(name)
FROM olympics_athletes_events
WHERE team = 'Denmark' AND medal IS NOT NULL;

--64. Find unique names women who participated in an Olympics before World War 2. Let's consider the year 1939 as the start of WW2.

SELECT name
FROM olympics_athletes_events
WHERE sex = 'F' AND year < 1939;

/*65. Find libraries with the highest number of total renewals. Output all home library definitions along with the corresponding total renewals.
Order records by total renewals in descending order.*/

SELECT home_library_definition, SUM(total_renewals) AS ttl_renewal
FROM library_usage
GROUP BY home_library_definition
ORDER BY ttl_renewal DESC;

--66. Find how many people registered in libraries in the year 2016. Output the total patrons. Keep in mind that each row represents different patron.

SELECT patron_type_code, patron_type_definition, Count(*) AS total_patrons_in_2016
FROM library_usage
WHERE year_patron_registered = 2016
GROUP BY patron_type_code, patron_type_definition
ORDER BY patron_type_code;

/*67. Find the number of libraries that had 100 or more of total checkouts in February 2015. 
Be aware that there could be more than one row for certain library on monthly basis.*/

SELECT COUNT(*) AS 'no_of_libraries'
FROM library_usage
WHERE circulation_active_month = 'February'
AND circulation_active_year = 2015
HAVING SUM(total_checkouts) >= 100;

/*68. Find employees in the Sales department who achieved a target greater than 150. Output first names of employees.
Sort records by the first name in descending order.*/

SELECT first_name, last_name
FROM employee
WHERE department = 'Sales'
GROUP BY first_name, last_name
HAVING SUM(target) > 150
ORDER BY first_name DESC;

--69. Find departments with at more than or equal 5 employees.

SELECT department
FROM employee
GROUP BY department
HAVING COUNT(*) > 5

--70. You have been asked to find the five highest distinct salaries. If two people earn the same amount of money, they are counted as one.

SELECT DISTINCT(salary) AS  slry
FROM worker
ORDER BY slry DESC
LIMIT 5;

--71. You have been asked to find the three lowest distinct salaries. If two people earn the same amount of money, they are counted as one.

SELECT DISTINCT(salary) AS  slry
FROM worker
ORDER BY slry
LIMIT 3;

--72. Your output should include the full name of the employee(s) with the highest salary in one column and the corresponding salary in the other.

SELECT CONCAT(first_name,' ',last_name), salary
FROM worker
ORDER BY salary DESC
LIMIT 2;

--73. Find the last five records of the dataset.

(SELECT * FROM worker ORDER BY worker_id DESC LIMIT 5)
ORDER BY worker_id ASC;


--74. Find the first record of the dataset without using LIMIT or ORDER BY. Note: The earliest records correspond to the earliest employee ID's.

SELECT * FROM worker
WHERE worker_id = (SELECT MIN(worker_id) FROM worker);

--75. Find the last record of the dataset without using LIMIT or ORDER BY. Note: The earliest records correspond to the earliest employee ID's.

SELECT * FROM worker
WHERE worker_id = (SELECT MAX(worker_id) FROM worker);

--76. Find the number of employees in each department. Output the department name along with the corresponding number of employees.

SELECT department, COUNT(*) AS no_of_employees
FROM worker
GROUP BY department;

/*77. Find the number of workers by department who joined in or after April. Output the department name along with the corresponding
number of workers.Sort records based on the number of workers in descending order.*/

SELECT department, COUNT(*) AS no_of_employees
FROM worker
WHERE month(joining_date) >= 04
GROUP BY department;

/*78. Find the full name of workers whose salaries range from 50,000 to 100,000 inclusive.
Output the worker's first name and last name in one column along with their salaries.*/

SELECT CONCAT(first_name,' ',last_name) AS full_name, salary
FROM worker
WHERE salary BETWEEN 50000 AND 100000;

--79. Find the number of employees working in the Admin department that joined in April or later.

SELECT COUNT(*) AS 'no_of_employees'
FROM worker
WHERE department = 'Admin'
AND month(joining_date) >= 04;

--80. Find all workers who joined on February 2014.

SELECT first_name, last_name
FROM worker
WHERE (month(joining_date) = 02) AND (year(joining_date) = 2014);

--81. Find all workers whose salary lies between 100,000 and 500,000 inclusive.

SELECT first_name, last_name
FROM worker
WHERE salary BETWEEN 100000 AND 500000;

--82. Find all workers whose first name contains 6 letters and also ends with the letter 'h'.Display all information about the workers in output.

SELECT * FROM workers
WHERE first_name LIKE '%h'
AND LENGTH (first_name) = 6;

--83. Find all workers whose first name ends with the letter 'a'.

SELECT first_name FROM worker
WHERE first_name LIKE '%a';

--84. First Name's Containing the Letter 'a'

SELECT * FROM worker
WHERE first_name LIKE '%a%';

--85. Find all workers and their details that work in the Admin department.

SELECT * FROM worker_ws
WHERE department = 'admin';

--86. Employees Without First Names 'Vipul' or 'Satish' or Last Name Containing a 'c'

SELECT * FROM worker
WHERE first_name IN ('Vipul', 'Satish')
OR last_name LIKE '%c%';

--87. Sort workers in ascending order by the first name and then in descending order by department name.

SELECT first_name, last_name, department
FROM worker
ORDER BY first_name, department DESC;

--88. Combine the first and last names of workers with a space in-between in a column 'full_name'.

SELECT CONCAT(first_name,' ',last_name) AS full_name

--89. Replace the letter 'a' with 'A' in the first name

SELECT REPLACE(first_name, 'a', 'A')
FROM worker;

--90. Print the first name after removing white spaces from the left side.

SELECT LTRIM(first_name) AS trimmed_first_name
FROM worker_ws;

--91. Print the first name after removing white spaces from the right side.

SELECT RTRIM(first_name) AS trimmed_first_name
FROM worker_ws;
FROM worker;

--92. Find the position of the lower case letter 'a' in the first name of the worker 'Amitah'.


--93. Print the first three characters of the first name.

SELECT SUBSTRING(first_name, 1, 3) As three_letters
FROM worker;

--94. Find business types present in the dataset.

SELECT DISTINCT(business_type) AS types
FROM google_adwords_earnings;

--95. Find all companies with more than 10 employees

SELECT * FROM google_adwords_earnings
WHERE n_employees > 10
GROUP BY business_type;

--96. Find all records with words that start with the letter 'g'. Output words1 and words2 if any of them satisfies the condition.

SELECT * FROM google_word_lists
WHERE words1 LIKE 'g%' OR words2 LIKE 'g%';

--97. Find drafts which contains the word 'optimism'.

SELECT * FROM google_file_store
WHERE contents LIKE '%optimism%';

--98. Find the total assets of the energy sector.

SELECT SUM(assets) AS total_assets
FROM forbes_global_2010_2014
WHERE sector = 'energy';

--99. Find the number of USA companies that are on the list.

SELECT COUNT(*) AS 'no_of_USA_countries'
FROM forbes_global_2010_2014
WHERE country = 'United States';

--100. Find the total market value for the financial sector.

SELECT SUM(marketvalue) AS 'total_market_value'
FROM forbes_global_2010_2014
WHERE sector = 'financials';

--101. Find the average profit for major banks.

SELECT AVG(profits) AS AVG_Profit FROM forbes_global_2010_2014
WHERE industry = 'Major Banks';

--102. Find the total number of interactions on days 0 and 2. Output the result alongside the day.

SELECT day, COUNT(*) as total_interaction
FROM facebook_user_interactions
WHERE day = 0 OR day = 2
GROUP BY day;

--103. Find all users that have performed at least one scroll_up event.

SELECT user_id
FROM facebook_web_log
WHERE action = 'scroll_up'
GROUP BY user_id, action
HAVING COUNT(action) >= 1;

--104. Find the overall friend acceptance count for a given date.Assume the date is 2nd of January 2019.

SELECT date_approved, COUNT(*) AS 'acceptance_count'
FROM facebook_friendship_requests
WHERE date_approved IS NOT NULL
GROUP BY date_approved;

--105. Find the maximum step reached for every feature. Output the feature id along with its maximum step.

SELECT feature_id, MAX(step_reached)
FROM facebook_product_features_realizations;

--106. Find all actions which occurred more than once in the weblog.

SELECT action
FROM facebook_web_log
HAVING COUNT(DISTINCT(action)) > 1;

--107. Find the number of views each post has. Output the post id along with the number of views. Order records by post id in ascending order.

SELECT post_id, COUNT(*) AS post_views
FROM facebook_post_views
GROUP BY post_id
ORDER BY post_id;

--108. Find all users who liked one or more posts

SELECT poster
FROM facebook_reactions
WHERE reaction = 'Like'
GROUP BY poster
HAVING COUNT(reaction) >= 1;

--109. Posts with 'nba' substring in keyword

SELECT * FROM facebook_posts
WHERE post_keywords LIKE '%nba%';

--110. Find all messages which have references to either user 2 or 3.

SELECT * FROM facebook_messages_sent
WHERE text LIKE '%2%' OR '%3%';

--111. Find the complaint id for the processed complaints of type 1.

SELECT complaint_id
FROM facebook_complaints
WHERE type = 1;

--112. List all interactions of user wth id 4 on either day 0 or 2

SELECT * FROM facebook_user_interactions
WHERE (user1 = 4 OR user2 = 4)
AND day IN (0,2);

--113. Find the number of people that made a search on Airbnb.

SELECT COUNT(*) AS 'np_of_people' FROM airbnb_searches
WHERE n_searches IS NOT NULL;

/*114. Find the best publishers based on total sales made by each publisher. Output publishers alongside their total sales.
Order records based on the sales in descending order.*/

SELECT publisher, SUM(total) AS total_sales
FROM global_weekly_charts_2013_2014
GROUP BY publisher
ORDER BY total_sales DESC;

/*115. Find the genres that yielded the highest sales. Output the genre alongside its total sales.
Order results based on the total sales in descending order.*/

SELECT genre
FROM global_weekly_charts_2013_2014
WHERE total = (SELECT Max(total) FROM global_weekly_charts_2013_2014);


/*116. Find the most dangerous places in SF based on the crime count per address and district combination.
Output the number of incidents alongside the corresponding address and the district.
Order records based on the number of occurrences in descending order.*/

SELECT CONCAT(pd_district,'-',address) AS 'SF_address', COUNT(*) AS crime_count
FROM sf_crime_incidents_2014_01
GROUP BY SF_address
ORDER BY crime_count DESC
LIMIT 1;

/*117. Find all inspections made on restaurants and output the business name and the inspection score.
For this question business is considered as a restaurant if it contains string "restaurant" inside its name.*/

SELECT * FROM sf_restaurant_health_violations
WHERE business_name LIKE '%restaurant%';

--118.Find the business names that scored less than 50 in inspections.Output the result along with the corresponding inspection date and the score.

SELECT business_name, inspection_date, inspection_score
FROM sf_restaurant_health_violations
WHERE inspection_score < 50
GROUP BY business_name, inspection_date, inspection_score;

--119. Find all business postal codes of restaurants with issues related to the water (violation description contains substring "water").

SELECT business_name, business_postal_code
FROM sf_restaurant_health_violations
WHERE violation_description LIKE '%water%';

--120. Find all businesses which have a phone number.

SELECT DISTINCT(business_name) AS 'business_with_phone'
FROM sf_restaurant_health_violations
WHERE business_phone_number IS NOT NULL;

--121. Find all businesses which have low-risk safety violations.

SELECT business_name
FROM sf_restaurant_health_violations
WHERE risk_category = 'Low Risk'
GROUP BY business_name;

--122. Find the mean of inspections scores between 91 and 100. Assuming that the scores are normally distributed.

SELECT AVG(score) AS avg_score
FROM los_angeles_restaurant_health_inspections
WHERE score BETWEEN 91 AND 100;

--123. Find the number of inspections per day. Output the result along with the date of the activity. Order results based on the activity date in the ascending order.

SELECT activity_date, COUNT(*) AS 'inspection_per_day'
FROM los_angeles_restaurant_health_inspections
GROUP BY activity_date
ORDER BY activity_date;

--124. Find the most common grade earned by bakeries.

SELECT grade, COUNT(grade) AS 'grade_count'
FROM los_angeles_restaurant_health_inspections
WHERE facility_name LIKE '%Bakery%'
GROUP BY grade
ORDER BY grade_count DESC
LIMIT 1;

/*125. Count the number of unique facilities per municipality zip code along with the number of inspections. 
Output the result along with the number of inspections per each municipality zip code.
Sort the result based on the number of inspections in descending order.*/

SELECT facility_zip, COUNT(DISTINCT(facility_name)) AS unique_facility,
COUNT(*) AS 'no_of_inspection' 
FROM los_angeles_restaurant_health_inspections
GROUP BY facility_zip;

--126. Find the owner_name and the pe_description of facilities owned by 'BAKERY' where low-risk cases have been reported.

SELECT owner_name, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE facility_name LIKE '%Bakery%'
AND pe_description LIKE '%LOW RISK%'
GROUP BY owner_name, pe_description;

--127. Check if record_id is unique for every row. Output the total record ids and total unique record ids for comparison.

SELECT COUNT(record_id) AS 'total_record',
COUNT(DISTINCT(record_id)) AS 'unique_record'
from los_angeles_restaurant_health_inspections;

--128. Find the average score for grades A, B, and C. Output the results along with the corresponding grade (ex: 'A', avg(score)).

SELECT grade, AVG(score) AS avg_scoew
FROM los_angeles_restaurant_health_inspections
GROUP By grade;

--129. Find all facilities with the zip code 90049, 90034, or 90045.

SELECT facility_name, facility_zip
FROM los_angeles_restaurant_health_inspections
WHERE facility_zip IN (90049, 90034, 90045);

--130. Find all routine inspections where high-risk issues were found

SELECT * FROM los_angeles_restaurant_health_inspections
WHERE service_description = 'Routine Inspection'
AND pe_description LIKE '%HIGH RISK%';

--131. Find all inspection details made for facilities owned by 'GLASSELL COFFEE SHOP LLC'.

SELECT * FROM los_angeles_restaurant_health_inspections
WHERE owner_name = 'GLASSELL COFFEE SHOP LLC';

--132. Find the details of oscar winners between 2001 and 2009.

SELECT * FROM oscar_nominees
WHERE year BETWEEN 2001 AND 2009;

--133. Find companies that have at least 2 Chinese speaking users.

SELECT company_id
FROM playbook_users
WHERE language = 'chinese'
GROUP BY company_id
HAVING COUNT(language) >= 2;

--134. Find the highest market value for each sector. Output the sector name along with the result.

SELECT sector, marketvalue FROM forbes_global_2010_2014
ORDER BY marketvalue DESC
LIMIT 1;

--135. What is the profit to sales ratio (profit/sales) of Royal Dutch Shell? Output the result along with the company name.

SELECT company, (profits/sales) AS 'profit_to_sales_ratio'
FROM forbes_global_2010_2014
WHERE company = 'Royal Dutch Shell';

--136. Count the number of cancelled flights by American Airlines (AA).

SELECT COUNT(cancelled) AS 'no_of_cancelled_flights'
FROM us_flights
WHERE unique_carrier = 'AA';

--137. Find the average distance an airplane travels from each origin airport. Output the result along with the corresponding origin.

SELECT flight_num, origin, AVG(distance) AS 'avg_distance_from_origin'
FROM us_flights
GROUP BY flight_num, origin;

--138. Find all US flight details which had no delay (use only arr_delay column for filtering).

SELECT * FROM us_flights
WHERE arr_delay = 0;

/*139. Find the top 5 longest US flights by distance. Output the result along with the corresponding origin, destination, and distance.
Sort the flights from longest to shortest.*/

SELECT unique_carrier, origin, dest, distance
FROM us_flights
ORDER BY distance DESC
LIMIT 5;

--140. What are the unique IATA codes for all origin airports in the dataset?

SELECT DISTINCT(origin) FROM us_flights;

--141. Find how many different origin airports exist?

SELECT COUNT(DISTINCT(origin)) AS 'no_of_origin_airport'
FROM us_flights;

--142. Count the number of speakers for each language. Sort the result based on the number of speakers in descending order.

SELECT language, COUNT(user_id) AS 'no_of_speakers'
FROM playbook_users
GROUP BY language
ORDER BY no_of_speakers DESC;

--143. How many users speak English, German, French or Spanish? Note: Users who speak more than one language are counted only once.

SELECT COUNT(*) AS 'no_of_users'
FROM playbook_users
WHERE language in ('English','French','Spanish');

--144. Find the industry which has the lowest average sales compared to all industries

SELECT industry, AVG(sales) AS 'avg_sales'
FROM forbes_global_2010_2014
GROUP BY industry
ORDER BY avg_sales
LIMIT 1;

/*145. Count the number of companies in the Information Technology sector in each country.
Output the result along with the corresponding country name.
Order the result based on the number of companies in the descending order.*/

SELECT country, COUNT(*) AS 'no_of_IT_companies'
FROM forbes_global_2010_2014
WHERE sector = 'Information Technology'
GROUP BY country;

/*146. Finding the highest market value for each sector. Which sector is it best to invest in? Output the result along with the sector name.
Order the result based on the highest market value in descending order.*/

SELECT sector, MAX(marketvalue) AS 'highest_market_value'
FROM forbes_global_2010_2014
GROUP BY sector
ORDER BY highest_market_value DESC;

--147. List all companies working in the financial sector with headquarters in Europe or Asia.

SELECT company, continent AS 'Headquarter'
FROM forbes_global_2010_2014
WHERE continent IN ('Asia', 'Europe');

--148. Count the number of students lectured by each teacher. Output the result along with the name of the teacher.

SELECT teacher, COUNT(student_id) AS 'no_of_students_lectured'
FROM sat_scores
GROUP BY teacher;

--149. Find the average height of a quarterback

--150. How many accounts have performed a login in the year 2016?

SELECT COUNT(account_id) AS 'no_of_accounts_logged_in_2016'
from product_logins
WHERE YEAR(login_date) = 2016;

/*151. How many athletes were drafted into NFL from 2013 NFL Combine?
The pickround column specifies if the athlete was drafted into the NFL. A value of 0 means that the athlete was not drafted into the NFL.*/

SELECT COUNT(*) AS 'athletes_drafted_into_NFL_2013'
FROM nfl_combine
WHERE pickround != 0;

--152. How many unique users have performed a search?

SELECT COUNT(DISTINCT(id_user)) AS 'unique_user'
FROM airbnb_searches
WHERE n_searches IS NOT NULL;

--153. Find the average number of searches made by each user and present the result with their corresponding user id.

SELECT id_user, AVG(n_searches)
FROM airbnb_searches
GROUP BY id_user;

--154. Find all neighborhoods that have properties with a parking space and don't charge for cleaning fees.

SELECT DISTINCT(neighbourhood)
FROM airbnb_search_details
WHERE amenities LIKE '%Free parking on premises%'
AND cleaning_fee = 0;

/*155. Find the average number of beds in each neighborhood that has at least 3 beds in total.
Output results along with the neighborhood name and sort the results based on the number of average beds in descending order.*/

SELECT DISTINCT(neighbourhood) AS 'nhood'
FROM airbnb_search_details
WHERE beds >= 3
GROUP BY nhood;

--156. Find all neighbourhoods present in this dataset.

SELECT DISTINCT(neighbourhood) As 'neighbourhood'
FROM airbnb_search_details;

--157. Find the price of the cheapest property for every city.

SELECT city, property_type, MIN(price) AS 'cheapest_price'
FROM airbnb_search_details
GROUP BY city, property_type;

/*158. Find all searches for San Francisco with a flexible cancellation policy
and a review score rating. Sort the results by the review score in the descending order.*/

SELECT * FROM airbnb_search_details
WHERE cancellation_policy = 'flexible'
AND city = 'SF'
AND review_scores_rating IS NOT NULL
ORDER BY review_scores_rating DESC;

--159. Find all search details where data is missing from the host_response_rate column.

SELECT * FROM airbnb_search_details
WHERE host_response_rate IS NULL;

--160. Find the search details for villas and houses with wireless internet access.

SELECT * FROM airbnb_search_details
WHERE property_type IN ('House', 'Villa')
AND amenities LIKE '%Wireless Internet%';

--161. Find distinct searches for Los Angeles neighborhoods. Output neighborhoods and remove duplicates.

SELECT DISTINCT(neighbourhood) AS 'unique_nhood'
FROM airbnb_search_details
WHERE city = 'LA';

--162. Find all searches for accommodations with an equal number of bedrooms bathrooms

SELECT * FROM airbnb_search_details
WHERE bedrooms = bathrooms;

--163. Find the search details made by people who searched for apartments designed for a single-person stay.

SELECT * FROM airbnb_search_details
WHERE accommodates = 1
AND property_type = 'Apartment';

--164. Find the date when Apple's opening stock price reached its maximum

SELECT date
FROM aapl_historical_stock_price
WHERE open = (SELECT MAX(open) FROM aapl_historical_stock_price);

/*165. Find hotels in the Netherlands that got complaints
from guests about room dirtiness (word "dirty" in its negative review). Output all the columns in your results*/

SELECT * FROM hotel_reviews
WHERE hotel_address LIKE '%Netherlands%'
AND negative_review LIKE '%dirty%';

--166. Find SAT scores of students whose high school names do not end with 'HS'.

SELECT school, student_id, sat_writing, sat_verbal, sat_math, average_sat
FROM sat_scores
WHERE school NOT LIKE '%HS' ;

/*167. You have been asked to find the number of employees hired between the months of January and July in the year 2022 inclusive.
Your output should contain the number of employees hired in this given time frame.*/

SELECT COUNT(*) AS 'no_of_employees'
FROM employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-07-31';

/*168.You've been asked by Amazon to find the shipment_id and weight of the third heaviest shipment. Output the shipment_id, and total_weight for
that shipment_id. In the event of a tie, do not skip ranks.*/

WITH CTE_Amazon AS
(select *, DENSE_RANK() OVER(ORDER BY
weight  DESC) AS weight_rank from amazon_shipment)
SELECT shipment_id, weight FROM CTE_Amazon WHERE weight_rank = 3;

/*169. Amazon's information technology department is looking for information on employees' most recent logins.
The output should include all information related to each employee's most recent login.*/

WITH CTE_emp AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY worker_id ORDER BY login_timestamp DESC)
AS time_rank FROM worker_logins)
SELECT * FROM CTE_emp WHERE time_rank = 1;

--170. You are given a list of posts of a Facebook user. Find the average number of likes.

SELECT AVG(no_of_likes) AS 'avg_no_of_likes'
FROM fb_posts;

--171. Find the number of account registrations according to the signup date. Output the months and their corresponding number of registrations.

SELECT MONTH(started_at) AS 'Month', COUNT(*) AS'no_of_reistration'
FROM noom_signups
GROUP BY Month
ORDER BY Month;

/*172. What are the top two (ranked in decreasing order) single-channelmedia types that correspond to the most money the grocery
chain had spent on its promotional campaigns?*/

SELECT media_type, SUM(cost) AS 'total_promotional_cost'
FROM facebook_sales_promotions
GROUP BY media_type
ORDER BY total_promotional_cost DESC
LIMIT 2;


--173. For the 5 most lucrative products, i.e. products that generated the highest revenue, output their IDs and the total revenue.

SELECT product_id, SUM(cost_in_dollars) AS 'total_revenue'
FROM facebook_sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;

--174. How many orders were shipped by Speedy Express in total?

SELECT COUNT(order_id) AS 'total_orders'
FROM shopify_orders sho
JOIN shopify_carriers shc ON sho.carrier_id = shc.id;

--175. Write a query to get a list of products that have not had any sales. Output the ID and market name of these products.


/*176. Write a query to return all Customers (cust_id) who are violating primary key constraints in the Customer Dimension (dim_customer)
i.e. those Customers who are present more than once in the Customer Dimension.
For example if cust_id 'C123' is present thrice then the query should return 'C123' | '3' as output.*/

SELECT cust_id, COUNT(cust_id) AS 'presence'
FROM dim_customer
GROUP BY cust_id
HAVING presence > 1;

--177. Given the education levels and salaries of a group of individuals, find what is the average salary for each level of education.

SELECT education, AVG(salary) AS 'avg_salary'
FROM google_salaries
GROUP BY education;

--178. For each video game player, find the latest date when they logged in.

SELECT player_id, MAX(login_date) AS 'last_login'
FROM players_logins
GROUP BY player_id;

--179. Count how many claims submitted in December 2021 are still pending. A claim is pending when it has neither an acceptance nor rejection date.

SELECT COUNT(*) AS 'claims_pending'
FROM cvs_claims
WHERE date_accepted IS NULL AND date_rejected IS NULL;

/*180. Count the number of unique users per day who logged in from both a mobile device and web.
Output the date and the corresponding number of users.*/

SELECT ML.date AS 'login_date', COUNT(*) AS 'users'
FROM mobile_logs ML
JOIN web_logs WL WHERE ML.user_id = WL.user_id AND ML.date = WL.date
GROUP BY login_date;

/*181 For each platform (e.g. Windows, iPhone, iPad etc.), calculate the number of users. 
Consider unique users and not individual sessions. Output the name of the platform with the corresponding number of users.*/

SELECT platform, COUNT(DISTINCT(user_id))
FROM user_sessions
GROUP BY platform;

/*182. To improve sales, the marketing department runs various types of promotions. The marketing manager would like to analyze the effectiveness
of these promotional campaigns. In particular, what percentage of sales had a valid promotion applied? Only the promotions found in the 
facebook_promotions table are valid.*/



--183. What percentage of all products are both low fat and recyclable?

SELECT (100* SUM(CASE WHEN is_low_fat = 'Y' AND is_recyclable = 'Y' THEN 1 ELSE 0 END)/COUNT(*)) AS 'percentage'
FROM facebook_products;

/*184. You are given a list of exchange rates from various currencies to US Dollars (USD) in different months. Show how the exchange rate of all
the currencies changed in the first half of 2020. Output the currency code and the difference between values of the exchange rate between
July 1, 2020 and January 1, 2020.*/


--185. How many searches were there in the second quarter of 2021?

SELECT COUNT(*) AS 'Q2_seaarches'
FROM fb_searches
WHERE date BETWEEN '2020-01-04' AND '2020-30-06';

--186. Count the number of users who made more than 5 searches in August 2021.

/*187. Calculate the total weight for each shipment and add it as a new column. Your output needs to have all the existing rows and columns in addition to the  new column
that shows the total weight for each shipment. One shipment can have multiple rows.*/

SELECT *, SUM(weight) OVER(PARTITION BY shipment_id) AS 'total_shipment_weight'
FROM amazon_shipment;

--188.Write a query to find the weight for each shipment's earliest shipment date. Output the shipment id along with the weight.

WITH cte_amazon AS
(SELECT *,
RANK() OVER(PARTITION BY shipment_id ORDER BY shipment_date) AS 'rank_date'
FROM amazon_shipment)
SELECT shipment_id, weight FROM cte_amazon
WHERE rank_date = 1;

/*189. Write a query that will calculate the number of shipments per month. The unique key for one shipment is a combination of shipment_id
and sub_id. Output the year_month in format YYYY-MM and the number of shipments in that month.*/


/*190. Find the growth rate of active users for Dec 2020 to Jan 2021 for each account. The growth rate is defined as the number of users in January 2021
divided by the number of users in Dec 2020. Output the account_id and growth rate.*/


/*191. Find the monthly active users for January 2021 for each account. Your output should have account_id and the
monthly count for that account.*/

SELECT COUNT(user_id) AS 'Jan_active_users'
FROM sf_events
WHERE date BETWEEN '2021-01-01' AND '2021-01-31';

/*192. Uber is interested in identifying gaps in their business. Calculate the count of orders for each status of each service.
Your output should include the service name, status of the order, and the number of orders.*/

SELECT
service_name, status_of_order, COUNT(*) AS 'total_orders'
FROM uber_orders
GROUP BY service_name, status_of_order;

/*193. Return all employees who have never had an annual review. Your output should include the employee's first name, last name, 
hiring date, and termination date. List the most recently hired employees first.*/




/*194. Find the number of unique transactions and total sales for each of the product categories in 2017. Output the product categories,
number of transactions, and total sales in descending order. The sales column represents the total cost the customer paid for the product so
no additional calculations need to be done on the column. Only include product categories that have products sold.*/

SELECT product_category, COUNT(transaction_id) AS 'total_no_transaction',
SUM(sales) AS 'total_sales'
FROM wfm_transactions wt
JOIN wfm_products wp ON
wp.product_id = wt.product_id
GROUP BY product_category
ORDER BY product_category DESC, total_no_transaction DESC, total_sales DESC;

--195. Write a query that returns the number of unique users per client per month

SELECT client_id, MONTH(time_id) AS 'Mnth', COUNT(DISTINCT(user_id)) AS 'unique_users'
FROM fact_events
GROUP BY client_id, Mnth
ORDER BY Mnth;

--196. Return a list of users with status free who didn’t make any calls in Apr 2020.

with cte_inactive AS
(SELECT rcc.user_id, 
MONTH(CAST(date AS Date)) AS New_Date
, call_id, rcu.status
FROM rc_calls rcc
JOIN rc_users rcu
ON rcc.user_id = rcu.user_id
WHERE status = 'Free') 
SELECT * FROM cte_inactive WHERE New_Date = 4 AND call_id = 0;

--197. How many paid users had any calls in Apr 2020?

SELECT COUNT(DISTINCT(rcc.user_id)) AS 'unique_users'
FROM rc_calls rcc
JOIN rc_users rcu
ON rcc.user_id = rcu.user_id
WHERE status = 'Paid'
AND (SELECT MONTH(CAST(date AS Date)) AS New_Date) = 4;

--198. How many customers placed an order and what is the average order amount?

SELECT COUNT(customer_id) AS 'Customers_placed_orders',
ROUND(AVG(amount), 2) AS 'avg_order_amount'
from postmates_orders;

--199. Calculate the average session duration for each session type?

--200. Find users who are both a viewer and streamer.

SELECT user_id                      
FROM twitch_sessions                
WHERE session_type = 'streamer'     
  AND user_id in                    
  (SELECT user_id
     FROM
       (SELECT user_id,
               session_type,
               rank() OVER (PARTITION BY user_id
                            ORDER BY session_start) streams_order
        FROM twitch_sessions) s1
     WHERE streams_order =1
       AND session_type = 'viewer')

--201. Return a distribution of users activity per day of the month. By distribution we mean the number of posts per day of the month. 

SELECT DAY(post_date) AS 'day_of_post', COUNT(*) AS 'no_of_posts'
FROM facebook_posts
GROUP BY day_of_post;

/*202. Return the total number of comments received for each user in the 30 or less days before 2020-02-10. Don't output users who haven't
received any comment in the defined time period.*/

--203. Write a query that returns the user ID of all users that have created at least one ‘Refinance’ submission and at least one ‘InSchool’ submission.

with cte_loan AS
(SELECT user_id,
SUM(CASE WHEN type = 'Refinance' THEN 1 ELSE 0 END) AS 'Refinance_type',
SUM(CASE WHEN type = 'InSchool' THEN 1 ELSE 0 END) AS 'InSchool_type'
FROM loans
GROUP BY user_id)
SELECT user_id, Refinance_type, InSchool_type FROM cte_loan
WHERE Refinance_type >= 1 AND InSchool_type >=1