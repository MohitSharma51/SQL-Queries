--CREATE DATABASE Steeldata_F
--USE Steeldata_F

/*-- Create the Customers table
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
--------------------
-- Create the Branches table
CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Branches table
INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');
--------------------
-- Create the Accounts table
CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
--------------------
-- Populate the Accounts table
INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 1, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 7, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 3, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 2, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 4, 'Savings', 50000.00),
(11, 6, 3, 'Checking', 5000.00),
(12, 6, 3, 'Savings', 10000.00),
(13, 1, 12, 'Credit Card', -500.00),
(14, 2, 6, 'Credit Card', -1000.00),
(15, 3, 4, 'Credit Card', -2000.00);
--------------------
-- Create the Transactions table
CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--------------------
-- Populate the Transactions table
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);*/


--1. What are the names of all the customers who live in New York?

SELECT * FROM Customers

SELECT CONCAT(FirstName,' ',LastName) AS customer_name
FROM customers
WHERE City = 'New York'

--2. What is the total number of accounts in the Accounts table?

SELECT COUNT(1) AS total_accounts
FROM Accounts

--3. What is the total balance of all checking accounts?

SELECT SUM(Balance) AS total_balance
FROM Accounts
WHERE AccountType = 'Checking'

--4. What is the total balance of all accounts associated with customers who live in Los Angeles?

SELECT c.customerID,c.FirstName,c.LastName,a.AccountType,SUM(a.balance) AS total_balance
FROM Accounts a
JOIN Customers c
ON a.customerID = c.customerID
WHERE c.city = 'Los Angeles'
GROUP BY c.customerID,c.FirstName,c.LastName,AccountType
ORDER BY c.customerID

--5. Which branch has the highest average account balance?

WITH blnce AS (
SELECT b.branchname, b.city, b.state, a.balance
FROM accounts a
JOIN customers c
ON a.customerid	= c.customerid
JOIN branches b
ON a.branchid = b.branchid)
SELECT Top 1 branchname, city, state, AVG(Balance) AS avg_balance
FROM blnce
GROUP BY branchname, city, state
ORDER BY avg_balance DESC;

--6. Which customer has the highest current balance in their accounts?

SELECT Top 1 c.firstname, c.lastname, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a
ON c.customerID = a.customerID
GROUP BY c.firstname, c.lastname
ORDER BY total_balance DESC

--7. Which customer has made the most transactions in the Transactions table?

SELECT C.FIRSTNAME, c.lastname, COUNT(1) AS total_transactions
FROM customers c
JOIN accounts a
ON c.customerid = a.customerid
JOIN transactions t
ON a.accountid = t.accountid
GROUP BY C.FIRSTNAME, c.lastname
ORDER BY total_transactions DESC

--8.Which branch has the highest total balance across all of its accounts?

WITH blnce AS (
SELECT b.branchname, b.city, b.state, a.balance
FROM accounts a
JOIN customers c
ON a.customerid	= c.customerid
JOIN branches b
ON a.branchid = b.branchid)
SELECT Top 1 branchname, city, state, SUM(Balance) AS total_balance
FROM blnce
GROUP BY branchname, city, state
ORDER BY total_balance DESC;

--9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?

SELECT Top 1 c.firstname, c.lastname, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a
ON c.customerID = a.customerID
GROUP BY c.firstname, c.lastname
ORDER BY total_balance DESC

--10. Which branch has the highest number of transactions in the Transactions table?

WITH trnsaction AS (
SELECT a.BranchID, b.branchname, b.city,b.state, t.accountID, t.transactiondate
FROM Transactions t
JOIN Accounts a
ON t.AccountID = a.AccountID
JOIN branches b
ON b.BranchID = a.BranchID)
SELECT branchid,branchname, city, state, COUNT(1) AS no_of_transactions
FROM trnsaction
GROUP BY branchid,branchname, city, state
ORDER BY no_of_transactions DESC;

