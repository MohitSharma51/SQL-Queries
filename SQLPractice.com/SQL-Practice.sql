USE Dannys_dinner
--1. Show first name, last name, and gender of patients who's gender is 'M'

SELECT first_name,last_name,gender FROM patients
WHERE gender = 'M';

--2. Show first name and last name of patients who does not have allergies. (null)

SELECT first_name,last_name FROM patients WHERE allergies IS NULL;

--3. Show first name of patients that start with the letter 'C'

SELECT first_name FROM patients WHERE first_name LIKE 'C%';

--4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT first_name, last_name FROM patients WHERE weight between 100 and 120;

--5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

UPDATE patients SET allergies = 'NKA' WHERE allergies is NULL;

--6. Show first name and last name concatinated into one column to show their full name.

SELECT CONCAT (first_name,' ',last_name) AS 'full_name' FROM patients;

--7. Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON

SELECT first_name, last_name, province_names.province_name 
FROM patients
JOIN province_names ON province_names.province_id = patients.province_id;

--8. Show how many patients have a birth_date with 2010 as the birth year.

SELECT COUNT(*) AS 'patients_count' FROM patients WHERE Year(birth_date) = 2010;

--9. Show the first_name, last_name, and height of the patient with the greatest height.

SELECT first_name, last_name, MAX(height) FROM patients;

--10. Show all columns for patients who have one of the following patient_ids:1,45,534,879,1000

SELECT * FROM patients WHERE patient_id IN (1,45,534,879,1000);

--11. Show the total number of admissions.

SELECT count(*) AS 'no_of_admissions' FROM admissions;

--12. Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT * FROM admissions WHERE admission_date = discharge_date;

--13. Show the patient id and the total number of admissions for patient_id 579.

SELECT patient_id, count(admission_date) AS 'total_no_of_admissions' FROM admissions
WHERE patient_id = '579';

--14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

SELECT DISTINCT (city) FROM patients
WHERE province_id = (SELECT province_id FROM patients WHERE province_id ='NS');

--15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70

SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;

--16. Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null

SELECT first_name, last_name, allergies
FROM patients
WHERE city = 'Hamilton' AND allergies IS NOT NULL;

/*17. Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u).
Show the result order in ascending by city.*/

SELECT city FROM patients
WHERE CITY LIKE 'a%'
OR CITY LIKE 'e%'
OR CITY LIKE 'i%'
OR CITY LIKE 'o%'
OR CITY LIKE 'u%'
GROUP BY city
ORDER by city;

--18. Show unique birth years from patients and order them by ascending.

SELECT distinct (YEAr(birth_date)) AS 'birth_date' FROM patients ORDER BY birth_date;

/*19. Show unique first names from the patients table which only occurs once in the list.For example, if two or more people are named 'John'
in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.*/

SELECT first_name FROM patients
GROUP BY first_name HAVING COUNT (first_name) = 1;

--20. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%s' AND len(first_name)>=6;

--21. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.Primary diagnosis is stored in the admissions table.

SELECT p.patient_id, p.first_name, p.last_name
From patients p
JOIN admissions a on p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';

--22. Display every patient's first_name.Order the list by the length of each name and then by alphbetically

SELECT first_name
FROM patients
ORDER BY LEN(first_name), first_name;

--23. Show the total amount of male patients and the total amount of female patients in the patients table.Display the two results in the same row.

SELECT
SUM(CASE WHEn gender = 'M' then 1 ELSE 0 END) AS 'Male_patients',
SUM(CASE WHEn gender = 'F' then 1 ELSE 0 END) AS 'Female_patients'
FROM patients;

/*24. Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
Show results ordered ascending by allergies then by first_name then by last_name.*/

SELECT first_name, last_name, allergies
FROM patients
WHERE allergies in ('Penicillin', 'Morphine')
ORDER BY allergies, first_name, last_name;

--25. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT patient_id, diagnosis
FROM admissions
GROUP by patient_id, diagnosis
HAVING COUNT(diagnosis) >  1;

--26. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.

SELECT city, count(patient_id) as 'total_no_of_patients'
FROM patients
Group by city
ORDER BY total_no_of_patients Desc, city asc;

--27. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' as role FROM patients
UNION all
SELECT first_name, last_name, 'Doctor' as role FROM doctors

--28. Show all allergies ordered by popularity. Remove 'NKA' AND NULL values from query.

SELECT allergies, count(allergies) as 'count_of_allergy'
FROM patients
WHERE allergies = 'NKA' OR allergies IS NOT NULL
GROUP by allergies
ORDER by count(allergies) desc;

/*29. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade.
Sort the list starting from the earliest birth_date.*/

SELECT first_name, last_name, birth_date
FROM patients
WHERE birth_date between '1970-01-01' AND '1979-12-31'
ORDER BY birth_date ASC;

/*30. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in
all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane*/

SELECT CONCAT(UPPER(last_name),',',LOWER(first_name)) AS full_name
FROM patients
ORDER by first_name DESC;

--31. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT province_id, sum(height)
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

--32. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT MAX(weight) - Min(weight) as difference_of_weight
FROM patients
WHERE last_name = 'Maroni';

/*33. Show all of the days of the month (1-31) and how many admission_dates occurred on that day.
Sort by the day with most admissions to least admissions.*/

SELECT day(admission_date) as 'Day_of_month', COUNT(*) as 'No_of_admissions'
FROM admissions
GROUP BY Day_of_month
ORDER BY No_of_admissions DESC;

--34,Show all columns for patient_id 542's most recent admission_date.

SELECT * FROM admissions
WHERE patient_id = 542
ORDER BY admission_date DESC
LIMIT 1;

/*35. Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.*/

SELECT patient_id,attending_doctor_id,diagnosis
FROM admissions
WHERE (patient_id%2 != 0 AND attending_doctor_id IN(1,5,19))
OR (attending_doctor_id LIKE '%2%' AND LEN(patient_id) = 3);

--36. Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor.

SELECT d.first_name, d.last_name, count(a.admission_date) as total_no_of_admissions
FROM admissions a
JOIN doctors d ON a.attending_doctor_id = d.doctor_id
GROUP BY d.first_name, d.last_name;

--37. For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT doctor_id, CONCAT(first_name,' ', last_name), 
MIN(a.admission_date) as first_admission_date, MAX(a.admission_date) AS last_admission_date
FROM doctors d
JOIN admissions a ON d.doctor_id= a.attending_doctor_id
GROUP By doctor_id;

--38. Display the total amount of patients for each province. Order by descending.

SELECT pr.province_name, count(*) as total_patients
FROM patients pt
JOIN province_names pr on pt.province_id = pr.province_id
GROUP BY pr.province_name
ORDER BY total_patients DESC;

--39. For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

SELECT CONCAT(pt.first_name,' ',pt.last_name) AS patient_full_name,
CONCAT(dr.first_name,' ',dr.last_name) AS doctor_full_name, diagnosis
FROM admissions adm
JOIN patients pt ON adm.patient_id = pt.patient_id
JOIN doctors dr ON adm.attending_doctor_id= dr.doctor_id;

--40. Display the number of duplicate patients based on their first_name and last_name.

SELECT first_name, last_name,
COUNT (CONCAT(first_name,' ',last_name)) AS 'num_of_duplicates'
FROM patients
GROUP BY first_name, last_name
HAVING num_of_duplicates > 1;

/*41. Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date,
gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.*/

SELECT CONCAT(first_name,' ',last_name) AS patient_full_name,
ROUND((height/30.48),1) AS height_in_feet,
ROUND((weight*2.205),0) AS weight_in_pounds,
birth_date,
CASE WHEN gender = 'M' then 'MALE'
	 WHEN gender = 'F' THEN 'FEMALE' END AS gender
FROM patients;

/*42. Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. 
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.*/

SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

/*43. Show patient_id, weight, height, isObese from the patients table.
Display isObese as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)2) >= 30.
weight is in units kg.
height is in units cm.*/

SELECT patient_id, weight, height, 
  (CASE WHEN weight/(POWER(height/100.0,2)) >= 30 THEN 1 ELSE 0 END) AS isObese
FROM patients;

/*44. Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Dementia' and the doctor's first name is 'Lisa'
Check patients, admissions, and doctors tables for required information.*/

SELECT pt.patient_id, pt.first_name, pt.last_name, specialty
FROM patients pt
JOIN admissions adm ON pt.patient_id = adm.patient_id
JOIN doctors dr ON adm.attending_doctor_id = dr.doctor_id
WHERE adm.diagnosis = 'Epilepsy' AND dr.first_name = 'Lisa';

/*45. All patients who have gone through admissions, can see their medical documents on our site. 
Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date */

SELECT pt.patient_id,
CONCAT(pt.patient_id,LEN(pt.last_name),YEAR(pt.birth_date)) AS temp_password
FROM patients pt
JOIN admissions adm on pt.patient_id = adm.patient_id
GROUP BY pt.patient_id;

/*46. Each admission costs $50 for patients without insurance, and $10 for patients with insurance.
All patients with an even patient_id have insurance. Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. 
Add up the admission_total cost for each has_insurance group.*/

WITH cte_cost as
(
  SELECT (CASE WHEN patient_id%2=0 then 'Yes' ELSE 'No' END) AS has_insurance 
FROM admissions
  )
SELECT has_insurance, SUM(CASE WHEN has_insurance = 'Yes' THEN 10 ELSE 50 END) AS cost_after_insurance
FROM cte_cost
GROUP BY has_insurance;

/*47. Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name*/

with cte_gender as
(
  Select province_id,
  SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
  SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
  FROM patients
  GROUP BY province_id
)
SELECT province_name FROM province_names prn
JOIN cte_gender ctg
ON prn.province_id = ctg.province_id
WHERE male_count > female_count
GROUP BY province_name;

/*48. We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston' */

SELECT * FROM patients
WHERE first_name LIKE '__r%'
AND gender = 'F'
AND MONTH(birth_date) IN (2, 5, 12)
AND weight BETWEEN 60 AND 80
AND patient_id%2 !=0
AND city = 'Kingston';

/*49. Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.*/

with cte_pr AS (
SELECT CAST(COUNT(gender) AS FLOAT) AS total_patients,
SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_patients
FROM patients
)
SELECT CONCAT(ROUND(100*(male_patients/total_patients),2),'%') AS male_pr FROM cte_pr;

/*50. For each day display the total amount of admissions on that day. Display the amount changed from the previous date.*/

WITH cte_adm AS
(
SELECT
 admission_date,
 COUNT(admission_date) AS admission_day 
FROM admissions
 GROUP BY admission_date
  ),
cte_adm1 AS (
  SELECT *, LAG(admission_day) OVER(ORDER BY admission_date) AS lag_dm
  FROM cte_adm
   GROUP BY by admission_date)
SELECT admission_date,admission_day, (admission_day - lag_dm) AS admission_count_change
FROM cte_adm1

/*51. Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.*/

SELECT province_name
FROM province_names
ORDER BY
  province_name = 'Ontario' DESC,
  province_name