-- Training script by Wojciech Skwierawski for Volue

use AdventureWorks2019

--This script should not be executed as a whole
RAISERROR ('Oooopsie. This file should not be executed this way ;).',20,-1) with log

---------------------------------------- CREATING VIEWS
-- CREATE VIEW <view name> AS 
-- SELECT <column names>
-- FROM <table name or join query>
-- WHERE <condition>

--IMPORTANT NOTE: See that the line below has red underlining. 
-- It is there because creare view query cannot be executed with other queries at the same time
-- Use 'GO' before and after the view and it will disappear

GO;

CREATE VIEW HumanResources.vExecutiveEmployees AS
SELECT e.*
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh on edh.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.Department d on d.DepartmentID = edh.DepartmentID
WHERE d.Name = 'Executive'

GO

select * from HumanResources.vExecutiveEmployees

GO;

CREATE VIEW Person.vPersonContactInfo AS
SELECT p.*, pp.PhoneNumber, em.EmailAddress from Person.Person p
join Person.EmailAddress em on p.BusinessEntityID = em.BusinessEntityID
join Person.PersonPhone pp on pp.BusinessEntityID = p.BusinessEntityID

GO

select * from Person.vPersonContactInfo 

-- [Ex. 1.1]
-- Write a new query that will create a SQL View that will display 
-- only the information that can be seen by everyone inside the organization from tables Employee and Person:
-- Name, JobTitle, HireDate
-- Tables: Person.Person, HumanResources.Employee

CREATE VIEW Person.vPersonInfoAvilableForEveryone AS
SELECT p.FirstName, p.LastName, JobTitle, HireDate from Person.Person p
join HumanResources.Employee e on e.BusinessEntityID = p.BusinessEntityID

select * from Person.vPersonInfoAvilableForEveryone

-- [Ex. 1.2]
-- Write a new query that will create a SQL View that will display 
-- sales people eligible for this year bonus. Call it Sales.PeopleWithBonus
-- Tables: Sales.SalesPerson, Person.Person
-- Condition: SalesYTD > 1000000

CREATE VIEW Sales.vEligibleForBonus AS
select p.*, sp.SalesYTD, sp.Bonus from Person.Person p 
join Sales.SalesPerson sp on sp.BusinessEntityID = p.BusinessEntityID
where SalesYTD > 1000000

select * from Sales.vEligibleForBonus

-- [Ex 1.3]
-- Write a query that could be used to display information about a product on a website.
-- Select all columns from Product, LargePhoto from ProductPhoto 
-- Tables: Production.Product, Production.ProductPhoto, Production.ProductProductPhoto

CREATE VIEW Production.vProductWithFullInfo AS
select p.*, ph.LargePhoto from Production.Product p
join Production.ProductProductPhoto pph on pph.ProductID = p.ProductID
join Production.ProductPhoto ph on ph.ProductPhotoID = pph.ProductPhotoID

select * from Production.vProductWithFullInfo

---------------------------------------- ALTERING VIEWS

-- ALTER VIEW <view name> AS 
-- SELECT <column names>
-- FROM <table name or join query>
-- WHERE <condition>
GO

ALTER VIEW HumanResources.vExecutiveEmployees AS
SELECT e.*
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh on edh.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.Department d on d.DepartmentID = edh.DepartmentID
WHERE d.Name in ( 'Executive', 'Human Resources')

select * from HumanResources.vExecutiveEmployees

-- [Ex. 2.1]
-- This year's inflation rate hit our imaginary company hard :(
-- Modify the view from Ex 1.2 so that only people with SalesYTD > 2500000 will receive the bonus

---------------------------------------- SCALAR FUNCTIONS

--CREATE FUNCTION <function name> (<list of parameters>)
--RETURNS <type of returned value> AS
--BEGIN
--	<function code>
--	RETURN <value to be returned>
--END

GO

CREATE FUNCTION [dbo].[ToDateTime2] ( @Ticks bigint )
  RETURNS datetime2
AS
BEGIN
    DECLARE @DateTime datetime2 = '00010101';
    SET @DateTime = DATEADD( DAY, @Ticks / 864000000000, @DateTime );
    SET @DateTime = DATEADD( SECOND, ( @Ticks % 864000000000) / 10000000, @DateTime );
    RETURN DATEADD( NANOSECOND, ( @Ticks % 10000000 ) * 100, @DateTime );
END

GO

CREATE FUNCTION dbo.ToTicks ( @DateTime datetime2 )
  RETURNS bigint
AS
BEGIN
    DECLARE @Days bigint = DATEDIFF( DAY, '00010101', cast( @DateTime as date ) );
    DECLARE @Seconds bigint = DATEDIFF( SECOND, '00:00', cast( @DateTime as time( 7 ) ) );
    DECLARE @Nanoseconds bigint = DATEPART( NANOSECOND, @DateTime );
    RETURN  @Days * 864000000000 + @Seconds * 10000000 + @Nanoseconds / 100;
END

-- [Ex. 3.1]
-- Create a function that will calculate the amount of tax that is present in a ListPrice
-- Assume 23% tax rate.
-- Use on table: Production.Product

ALTER FUNCTION Production.AmountOfTax ( @input money, @taxPercent money )
  RETURNS money
AS
BEGIN
    
    RETURN @input * @taxPercent/(1 + @taxPercent)
END

select Production.AmountOfTax(ListPrice, 0.23) as TaxAmount,  * 
from Production.Product
where ListPrice > 100

-- [Ex. 3.2]
-- Write a function that will return true if an employee was hired more that 15 years ago
-- (function will accept a date and return bit)
-- Use on table: HumanResources.Employee

ALTER FUNCTION HumanResources.WasHiredMoreThan15YearsAgo ( @hireDate date )
  RETURNS bit
AS
BEGIN
    
    declare @fifteenYAgo date = DateAdd(year, -15, GetDate())

	return iif(@hireDate > @fifteenYAgo, 0,1)
	
END

select HumanResources.WasHiredMoreThan15YearsAgo(HireDate), HireDate,  * from HumanResources.Employee

-- [Ex. 3.3]
-- Create a function that will display the phone number without the dashes and with a '+48' at the beginning
-- Find a helpful string method on the Internet
-- Table: Person.PersonPhone

Alter FUNCTION Person.FormatPhone ( @phone nvarchar(25))
  RETURNS nvarchar(25)
AS
BEGIN
  
	return '+48' + Replace(@phone,'-','')
	
END


select Person.FormatPhone(PhoneNumber), * from Person.PersonPhone

---------------------------------------- TABLE FUNCTIONS

--CREATE FUNCTION <function name> (<list of parameters>)
--RETURNS TABLE AS
--RETURN
--	<function code>

GO

CREATE FUNCTION PeopleInCity(@city varchar(40))  
RETURNS TABLE  
AS  
RETURN  
    select p.* from Person.Person p
	join Person.BusinessEntityAddress bea on bea.BusinessEntityID = p.BusinessEntityID

GO


select * from PeopleInCity('Austell')

GO

CREATE FUNCTION MyCustomTableFunction(@input varchar(40))  
RETURNS TABLE  
AS  
RETURN  
    select 'Some Value' as 'column name1', @input as input, 'suffix' as suffixColumn

GO


select * from MyCustomTableFunction('Austell')

-- [Ex. 4.1]
-- Let's prepare our imaginary company for future crisis. Instead of view that will have hardcoded SalesYTD threshold
-- write a function that can use it as a parameter. This way we will avoid modifying it every year ;)

-- [Ex. 4.2]
-- Write a function that will split email address to 2 column table. 
-- Use built int functions: CharIndex, Substring, Len
-- Use example:
-- Wojciech.Skwierawski@volue.com

--		___________________________________
--		|--------username-------|--domain--|
--		____________________________________
--		| Wojciech.Skwierawski  | volue.com|


---------------------------------------- STORED PROCEDURES

--CREATE PROCEDURE <procedure name> <param1 name> <param type1>, <param2 name> <param type2> <OUTPUT if yout want to return values from procedure>
--AS
--<procedure code>

GO

CREATE PROCEDURE sp_deleteProduct @productID int, @deletedCount int OUTPUT
AS

set @deletedCount = 0;

delete from Production.BillOfMaterials where ProductAssemblyID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.BillOfMaterials where ComponentID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductCostHistory where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductModel where ProductModelID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductReview where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductDocument where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductInventory where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductListPriceHistory where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.ProductProductPhoto where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Sales.SalesOrderDetail where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Sales.SpecialOfferProduct where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.TransactionHistory where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.WorkOrderRouting where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.WorkOrder where ProductID = @productID
set @deletedCount = @deletedCount + @@ROWCOUNT

delete from Production.Product where ProductID = @productID

GO


--Execution
declare @deletedCount int;
EXEC sp_deleteProduct 994, @deletedCount = @deletedCount output

select @deletedCount

-- [Ex. 5.1]
-- Write a procedure that will display information about an employee by his BusinessId from several sources in separate displayed tables
-- Tables: Person.Person, Person.Address, Person.EmailAddress, HumanResources.Employee

-- [Ex. 5.2]
-- Write a procedure that will delete a record from Production.ProductPhoto 
-- (Find connected connected objects)

---------------------------------------- TRIGGERS

-- CREATE TRIGGER <trigger name>
-- on <table name or database name>
-- AFTER <or BEFORE> <action name: (INSERT, UPDATE, DELETE)>
-- AS
-- BEGIN
--		<trigger logic>
-- END

GO

create trigger myCustomTrigger
on Person.[Address]
after insert
as
begin

INSERT [dbo].ErrorLog 
        (
        ErrorTime, 
        UserName, 
        ErrorNumber, 
        ErrorSeverity, 
        ErrorMessage
        ) 
    VALUES 
        (
        GETDATE(), 
        CONVERT(sysname, CURRENT_USER), 
        1, 
		1,
        'INSERTED NEW VALUE INTO ADDRESS'
        );

end


GO