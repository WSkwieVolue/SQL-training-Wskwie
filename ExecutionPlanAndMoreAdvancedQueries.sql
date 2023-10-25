-- Training script by Wojciech Skwierawski for Volue

use AdventureWorks2019

--This script should not be executed as a whole
RAISERROR ('Oooopsie. This file should not be executed this way ;).',20,-1) with log

---------------------------------------- EXECUTION PLAN
-- SQL SERVER to execute a query first has to create an execution plan
-- Summary of that plan can be seen when enabliing 'Include Actual Execution Plan' or 'Include Live Query Statistics'


-- [Ex. 1.1]
-- Enable both options then write and execute query that will select everything from Sales.SalesPerson

-- [Ex. 1.2]
-- Modify the query so that instead of everything it will display the amount of commission that should be payed to the salesPerson (commission to pay)
-- (CommissionPct multiplied by SalesYTD). See the execution plan 

-- [Ex. 1.3]
-- Now modify the query that it will display three column:
-- The column from previous exercise,
-- The maximal value from records from previous column (max commision),
-- The ratio of commision to pay for this salesPerson divided by maximal commission in percent
-- (CommissionPct multiplied by SalesYTD). See the execution plan 


---------------------------------------- CTE - COMMON TABLE EXPRESSION

-- SQL SERVER can reuse query if used properly.
-- Common table expressions will tell SQL SERVER that part of the query is identical in both cases so it can be reused

-- WITH <name of cte> AS (
-- <query to retreive data>
-- )
-- SELECT <column names from table and cte> from <name of cte and/or other tables>

go;

with maxCommission as
(
	select max(CommissionPct * SalesYTD) as maxC from Sales.SalesPerson 
)
select 
	CommissionPct * SalesYTD 
	,maxC
	
	from Sales.SalesPerson cross join maxCommission


-- [Ex. 2.1]
-- Write a query that will display:
-- profit from every product.Product (ListPrice - StandardCost)
-- average profit of all products
-- ratio of this product profit to avarage profit


---------------------------------------- ADVANCED QUERIES WITH WINDOW FUNCTIONS

--  AGGREGATING:
--		SUM(), MIN(), MAX(), COUNT(), AVG()
--	RANKING:
--		ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()
--	OFFSET:
--		LAG(), LEAD(), LAST_VALUE(), FIRST_VALUE()


select 
	ProductId,
	Name,
	color,
	avg(ListPrice) over (partition by color) as averagePriceForColor
from Production.Product

select 
	ProductId,
	Name,
	ListPrice,
	color,
	row_number() over (partition by color order by listPrice) as whichInColorByPrice
from Production.Product

select 
	ProductId,
	Name,
	ListPrice,
	color,
	lag(ListPrice) over (partition by color order by listPrice) as previousPrice,
	ListPrice - lag(ListPrice) over (partition by color order by listPrice) as Diff
from Production.Product

-- [Ex. 3.1]
-- Write a window function that will display the average vacation hours based for marital status 
-- and sum of the hours alongside all other columns

-- [Ex. 3.2]
-- Write a window function that will order the employees by hire date 
-- and display the difference in days between tha dates (use datediff)


---------------------------------------- EXECUTION PLAN AND INDEXES

select * from HumanResources.Employee where BusinessEntityID = 10

select * from HumanResources.Employee where JobTitle = 'Vice President of Engineering'

select * from HumanResources.Employee where BusinessEntityID < 10 and JobTitle = 'Vice President of Engineering'