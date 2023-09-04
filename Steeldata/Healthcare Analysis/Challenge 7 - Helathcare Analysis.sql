USE Steeldata

CREATE TABLE Patients (
patient_id INT PRIMARY KEY,
patient_name VARCHAR(50),
age INT,
gender VARCHAR(10),
city VARCHAR(50)
);
CREATE TABLE Symptoms (
symptom_id INT PRIMARY KEY,
symptom_name VARCHAR(50)
);
CREATE TABLE Diagnoses (
diagnosis_id INT PRIMARY KEY,
diagnosis_name VARCHAR(50)
);
CREATE TABLE Visits (
visit_id INT PRIMARY KEY,
patient_id INT,
symptom_id INT,
diagnosis_id INT,
visit_date DATE,
FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
FOREIGN KEY (symptom_id) REFERENCES Symptoms(symptom_id),
FOREIGN KEY (diagnosis_id) REFERENCES Diagnoses(diagnosis_id)
);


-- Insert data into Patients table
INSERT INTO Patients (patient_id, patient_name, age, gender, city)
VALUES
(1, 'John Smith', 45, 'Male', 'Seattle'),
(2, 'Jane Doe', 32, 'Female', 'Miami'),
(3, 'Mike Johnson', 50, 'Male', 'Seattle'),
(4, 'Lisa Jones', 28, 'Female', 'Miami'),
(5, 'David Kim', 60, 'Male', 'Chicago');


-- Insert data into Symptoms table
INSERT INTO Symptoms (symptom_id, symptom_name)
VALUES
(1, 'Fever'),
(2, 'Cough'),
(3, 'Difficulty Breathing'),
(4, 'Fatigue'),
(5, 'Headache');


-- Insert data into Diagnoses table
INSERT INTO Diagnoses (diagnosis_id, diagnosis_name)
VALUES
(1, 'Common Cold'),
(2, 'Influenza'),
(3, 'Pneumonia'),
(4, 'Bronchitis'),
(5, 'COVID-19');


-- Insert data into Visits table
INSERT INTO Visits (visit_id, patient_id, symptom_id, diagnosis_id, visit_date)
VALUES
(1, 1, 1, 2, '2022-01-01'),
(2, 2, 2, 1, '2022-01-02'),
(3, 3, 3, 3, '2022-01-02'),
(4, 4, 1, 4, '2022-01-03'),
(5, 5, 2, 5, '2022-01-03'),
(6, 1, 4, 1, '2022-05-13'),
(7, 3, 4, 1, '2022-05-20'),
(8, 3, 2, 1, '2022-05-20'),
(9, 2, 1, 4, '2022-08-19'),
(10, 1, 2, 5, '2022-12-01');


SELECT * FROM Patients
SELECT * FROM Symptoms
SELECT * FROM Diagnoses
SELECT * FROM Visits


--1. Write a SQL query to retrieve all patients who have been diagnosed with COVID-19

SELECT p.patient_id, p.patient_name, s.symptom_name, d.diagnosis_name
FROM Patients p
JOIN Visits v
ON p.patient_id = v.patient_id
JOIN Symptoms s
ON v.symptom_id = s.symptom_id
JOIN Diagnoses d
ON v.diagnosis_id = d.diagnosis_id
WHERE diagnosis_name = 'COVID-19';


--2. Write a SQL query to retrieve the number of visits made by each patient, ordered by the number of visits in descending order.

SELECT patient_name, COUNT(*) AS no_of_visits FROM (
SELECT p.patient_name, v.visit_date
FROM Patients p
JOIN Visits v
ON p.patient_id = v.patient_id) tt
GROUP BY patient_name ORDER BY no_of_visits DESC;

--3. Write a SQL query to calculate the average age of patients who have been diagnosed with Pneumonia.

SELECT AVG(p.age) AS avg_age
FROM Patients p
JOIN Visits v
ON p.patient_id = v.patient_id
JOIN Diagnoses d
ON d.diagnosis_id = v.diagnosis_id
WHERE d.diagnosis_name = 'Pneumonia';

--4. Write a SQL query to retrieve the top 3 most common symptoms among all visits.

SELECT TOP 3 s.symptom_name, COUNT(s.symptom_name) AS symptom_count
FROM Symptoms s
JOIN Visits v
ON s.symptom_id = v.symptom_id
GROUP BY s.symptom_name
ORDER BY symptom_count DESC;

--5. Write a SQL query to retrieve the patient who has the highest number of different symptoms reported.

with cte1 AS (
SELECT p.patient_name, COUNT(DISTINCT(s.symptom_name)) AS count_of_distinct_symptoms
FROM Patients p
JOIN Visits v
on p.patient_id = v.patient_id
JOIN Symptoms s
ON v.symptom_id = s.symptom_id
GROUP BY p.patient_name),
cte2 AS (SELECT *, DENSE_RANK() OVER(ORDER BY count_of_distinct_symptoms DESC) AS sym_rnk FROM cte1)
SELECT patient_name, count_of_distinct_symptoms
FROM cte2
WHERE sym_rnk = 1;


--6. Write a SQL query to calculate the percentage of patients who have been diagnosed with COVID-19 out of the total number of patients.

with cte1 AS (
SELECT v.visit_id, d.diagnosis_name
FROM Visits v
JOIN Diagnoses d
ON v.diagnosis_id = d.diagnosis_id)
SELECT CONCAT(CAST((1.0*(SELECT COUNT(*) FROM cte1 WHERE diagnosis_name = 'COVID-19')*100/COUNT(*)) AS DECIMAL(19,0)),'%') AS 'pct_of_covid_patient'
FROM cte1;

--7. Write a SQL query to retrieve the top 5 cities with the highest number of visits, along with the count of visits in each city.

SELECT TOP 5 p.city, COUNT(*) AS visits_per_city
FROM patients p
JOIN Visits v
ON p.patient_id = v.patient_id
GROUP BY p.city
ORDER BY visits_per_city DESC;

--8. Write a SQL query to find the patient who has the highest number of visits in a single day, along with the corresponding visit date.

SELECT Top 1 patient_name, visit_date, COUNT(*) AS visit_count FROM (
SELECT v.visit_id, p.patient_name, v.visit_date
FROM Visits v
JOIN Patients p
ON p.patient_id = v.patient_id) tt
GROUP BY patient_name, visit_date
ORDER BY visit_count DESC;


--9. Write a SQL query to retrieve the average age of patients for each diagnosis, ordered by the average age in descending order.

with cte1 AS (SELECT DISTINCT v.diagnosis_id, d.diagnosis_name, p.patient_id, p.age FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Diagnoses d
ON v.diagnosis_id = d.diagnosis_id)
SELECT diagnosis_name, ROUND(AVG(age),2) AS avg_age
FROM cte1
GROUP BY diagnosis_name
ORDER BY avg_age DESC;

--10. Write a SQL query to calculate the cumulative count of visits over time, ordered by the visit date.

SELECT visit_date, SUM(COUNT(*)) OVER(ORDER BY visit_date) AS cummulative_count
FROM Visits
GROUP BY visit_date;