--Question 1: List all the states in which we have customers who have bought cellphones From 2005 till today

Select Distinct DL.State
From FACT_TRANSACTIONS as FT
Left Join DIM_DATE as DD on DD.Date = FT.Date 
Left Join DIM_Location as DL on DL.IDLocation = FT.IDLocation
Where DD.YEAR >= 2005


--Question 2: What state in the US is buying more 'Samsung' cell phones?

Select top 1 DL.State,sum(FT.Quantity) as 'Number of Samsung cells purchased'
From FACT_TRANSACTIONS as FT
Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
Inner Join DIM_MANUFACTURER as DMFR on DMFR.IDManufacturer = DM.IDManufacturer and DMFR.Manufacturer_Name = 'Samsung'
Inner Join DIM_LOCATION as DL on DL.IDLocation=FT.IDLocation and DL.Country = 'US'
Group By State
Order By 'Number of Samsung cells purchased' desc


--Question 3: Show the number of transactions for each model per zip code per state.

Select DL.State,DL.ZipCode,DM.Model_Name,count(DM.Model_Name) as 'Number of transactions'
From FACT_TRANSACTIONS as FT
Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
Inner Join DIM_LOCATION as DL on DL.IDLocation=FT.IDLocation 
Group By DL.State,DL.ZipCode,DM.Model_Name

--Question 4: Show the cheapest cellphone

Select Top 1 FT.IDModel as  'Cheapest cellphone model'
From FACT_TRANSACTIONS as FT
Order By TotalPrice asc

--Qustion 5: Find out the average price for each model in the top5 manufacturers in terms of sales quantity and Order By average price.

Select DM.Model_Name,round(sum(FT.TotalPrice)/sum(FT.Quantity),2) as 'Average price' 
From FACT_TRANSACTIONS as FT
Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
Inner Join DIM_MANUFACTURER as DMFR on DMFR.IDManufacturer = DM.IDManufacturer
Inner Join (
	Select top 5 DMFR.IDManufacturer,DMFR.Manufacturer_Name,sum(FT.Quantity) as 'Total quantity'
	From FACT_TRANSACTIONS as FT
	Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
	Inner Join DIM_MANUFACTURER as DMFR on DMFR.IDManufacturer = DM.IDManufacturer
	Group By DMFR.IDManufacturer, DMFR.Manufacturer_Name
	Order By 'Total quantity' desc ) as q1 on q1.IDManufacturer = DMFR.IDManufacturer
Group By DM.Model_Name
Order By 'Average price' desc

--Question 6: List the names of the customers and the average amount spent in 2009, Where the average is higher than 500

Select DC.Customer_Name,avg(FT.TotalPrice) as 'Average amount spent'
From FACT_TRANSACTIONS as FT
Left Join DIM_DATE as DD on DD.Date = FT.Date 
Left Join DIM_CUSTOMER as DC on DC.IDCustomer = FT.IDCustomer
Where DD.YEAR = 2009
Group By DC.Customer_Name
having avg(FT.TotalPrice) >500
Order By 'Average amount spent'

--Question 7: List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010

select t2.Model_Name,count(t2.Model_name) as 'Year count in top 5'
From(select t1.* 
	From (Select DD.Year,DM.Model_Name,sum(FT.Quantity) as quantity,
		   row_number() over(partition by DD.year Order By sum(FT.quantity) desc) as quantity_rank
	From FACT_TRANSACTIONS as FT
	Left Join DIM_DATE as DD on DD.Date = FT.Date 
	Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
	Where DD.Year in (2008,2009,2010) 
	Group By Year,Model_Name) t1
	Where t1.quantity_rank <= 5) t2
Group By t2.Model_Name
having count(t2.Model_name)=3

-- Question 8: Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.
Select q2.Year,q2.Manufacturer_Name,q2.sales
From (
	Select q1.* ,
		   row_number() over(partition by year Order By q1.sales desc) as sales_rank
	From
		(Select DD.YEAR,DMFR.Manufacturer_Name,sum(FT.Totalprice) as Sales
		From FACT_TRANSACTIONS as FT
		Left Join DIM_DATE as DD on DD.Date = FT.Date 
		Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
		Inner Join DIM_MANUFACTURER as DMFR on DMFR.IDManufacturer = DM.IDManufacturer 
		Where DD.Year in (2009,2010)
		Group By DD.YEAR,DMFR.Manufacturer_Name) as q1 ) as q2
Where q2.sales_rank = 2
Order By q2.YEAR,q2.sales desc

--Question 9: Show the manufacturers that sold cellphone in 2010 but didn’t in 2009.

Select Distinct DD.YEAR,DMFR.Manufacturer_Name
		From FACT_TRANSACTIONS as FT
		Left Join DIM_DATE as DD on DD.Date = FT.Date 
		Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
		Inner Join DIM_MANUFACTURER as DMFR on DMFR.IDManufacturer = DM.IDManufacturer 
		Where DD.Year in (2010) and DMFR.Manufacturer_Name not in (
									Select Distinct DMFR.Manufacturer_Name
									From FACT_TRANSACTIONS as FT
									Left Join DIM_DATE as DD on DD.Date = FT.Date 
									Inner Join DIM_Model as DM on FT.IDModel=DM.IDModel 
									Inner Join DIM_MANUFACTURER as DMFR on DMFR.IDManufacturer = DM.IDManufacturer 
									Where DD.Year in (2009))

--Question 10:Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend.

select t2.*, (t2.avg_spend - lag(t2.avg_spend) OVER (PARTITION BY t2.Customer_Name Order By t2.year))/(
							 lag(t2.avg_spend) OVER (PARTITION BY t2.Customer_Name Order By t2.year))*100 as percentage_change
							 From (Select DC.Customer_Name,
										  DD.YEAR,
										  avg(FT.TotalPrice) as avg_spend,
										  avg(FT.Quantity) as avg_quantity
										  From FACT_TRANSACTIONS as FT
										  Left Join DIM_DATE as DD on DD.Date = FT.Date 
										  Left Join DIM_CUSTOMER as DC on DC.IDCustomer = FT.IDCustomer
										  Group By DC.Customer_Name,DD.Year) t2
