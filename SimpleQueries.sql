-- Training script by Wojciech Skwierawski for Volue

--This script should not be executed as a whole
RAISERROR ('Oooopsie. This file should not be executed this way ;).',20,-1) with log

----------------------------------------
-- SELECT <columns names or asterix> FROM <schema name>.<table name>

select * from DatabaseLog
select * from dbo.DatabaseLog
select FirstName as FN, MiddleName as Middle, LastName from Person.Person

-- [Ex. 1.1]
-- Write a query that will select all departments from schema HumanResources

-- [Ex. 1.2]
-- Write a query that will select only currency codes from schema currency

-- [Ex. 1.3]
-- Write a query that will select password hash from schema Person but name the column 'Some random letters'

----------------------------------------
-- SELECT <column names> FROM <schema name>.<table name> WHERE <Condition>

select * from Person.Person where FirstName = 'bob' 
-- see that by default SQL server is case insensitive ;)
-- to change that we would need to change the collation of DB

select * from Person.Person where Suffix is not null

select * from Production.Product where ListPrice > 1000 and Color = 'Red'

-- [Ex. 2.1]
-- Select all people without a middle name

-- [Ex. 2.2]
-- select all products from Product schema with SellStartDate bigger than 2008-04-30 00:00:00.000

-- [Ex. 2.3]
-- select all people with a letter 'h' in their last name. 
-- Try to use 'like' instead of '=' and '%' as a wildcard for letters before and after the letter 'h'

----------------------------------------
-- SELECT TOP <Number> <column names> from [schema name>.[table name> 
-- ORDER BY <column names with directions>

-- SELECT <column names> from <schema name>.<table name> 
-- ORDER BY <column names with directions>
-- OFFSET <Number> ROWS 
-- FETCH NEXT <Number> ROWS ONLY

-- SELECT DISTINCT <column names> from <schema name>.<table name> 

select top 10 * from Production.Product order by ListPrice desc, [Weight]

select 
	* 
from 
	Production.Product 
order by
	ListPrice desc, [Weight] 
offset 10 rows 
fetch next 10 rows only

select distinct FirstName, MiddleName from Person.Person

--[Ex. 3.1]
-- Select a SalesPerson that sold products for the biggest amount of money this year (SalesYTD column)

--[Ex. 3.2]
-- Select only the person that was the second best seller (second best SalesYTD)

--[Ex. 3.3]
-- Select all distinct cities from adrressed in schema Person

----------------------------------------
-- INSERT INTO <schema name>.<table name> (<column names>) values (<values that should be inserted>)

INSERT INTO Sales.Currency ([CurrencyCode] ,[Name] ,[ModifiedDate]) 
values ('BTC', 'Strange internet money', '2023-07-20 00:00:00.000')
-- This query cannot be executed more than once. It will not accept duplicate

INSERT INTO [Person].[Address]
values ('AddressLine1', null, 'City', 79, 98011, 0xE6100000010CD6FA851AE6D74740BC262A0A03905EC0, NEWID(), GETDATE())
-- See that we do not specify the AddressID column.
-- We do not have to add manually value for column if it is identity type (auto incrementing column)

insert into Sales.Currency ([CurrencyCode] ,[Name] ,[ModifiedDate])
values ('QQQ', 'Some currency', '2023-07-20 00:00:00.000'),
('ZZZ', 'Some currency 2', '2023-07-20 00:00:00.000'),
('YYY', 'Some currency 3', '2023-07-20 00:00:00.000')

--[Ex. 4.1]
-- Add new value to AddressType with some artificial data

--[Ex. 4.2]
-- Add new record to Sales.Person but only specify values for column that are non-nullable

----------------------------------------
-- UPDATE <schema name>.<table name>
-- set <column name> <new values>
-- where <condition>

update Person.Person 
set Suffix = 'Mr'
where FirstName = 'bob'

update [Person].[EmailAddress]
set EmailAddress = 'wojciech.skwierawski@volue.com',
ModifiedDate = GETDATE()
where EmailAddressID = 1

-- [Ex. 5.1]
-- Write a query that will change the description of the new BTC currency to 'Expensive internet money'

-- [Ex. 5.2]
-- Write a query that will change the full name of every 'David' to 'Mr. David Bowie Jr.'

----------------------------------------
-- DELETE FROM <schema name>.<table name>
-- WHERE <condition>

DELETE FROM [Person].[Address]
where AddressLine1 = 'AddressLine1'
-- Some times when writing a 'dangerous' update query it can be helpful
-- to write where with condition before writing the column names with new values.


--[Ex 6.1]
-- Delete all currencies that were added today with insert queries (but do not delete any other currency :] )


----------------------------------------
-- SELECT <Column names> from <schema1 name>.<table1 name> <table1 alias>
-- <Join types] JOIN <schema2 name>.<table2 name> <table2 alias>


select p.ProductID, p.Name, pm.Name from Production.Product p
left join Production.ProductModel pm on pm.ProductModelID = p.ProductModelID
-- See that we need to specify the table when selecting columns 'name' because they exist in both tables

select p.ProductID, p.Name, pm.Name from Production.Product p
inner join Production.ProductModel pm on pm.ProductModelID = p.ProductModelID

select p.ProductID, p.Name, pm.Name from Production.Product p
join Production.ProductModel pm on pm.ProductModelID = p.ProductModelID

select p.ProductID, p.Name, pm.Name from Production.Product p
right join Production.ProductModel pm on pm.ProductModelID = p.ProductModelID

--[Ex. 7.1]
-- Write a query that will display names of products that have a review and the content of that opinion

--[Ex. 7.2]
-- Write a query that will display a persons full name and his phone and email address

--[Ex. 7.3]
-- Write a query that will display a persons name and his credit card number (use join two times)








