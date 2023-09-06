-- Training script by Wojciech Skwierawski for Volue

--This script should not be executed as a whole
RAISERROR ('Oooopsie. This file should not be executed this way ;).',20,-1) with log

---------------------------------------- USE TRANSACTION
-- BEGIN TRAN <or TRANSACTION. It will execute the same way>
-- <optional transaction name>
-- <set of queries to be executed within transaction>
-- COMMIT <or ROLLBACK to undo queries>

begin tran

update HumanResources.Employee 
set MaritalStatus = 'S'
where BusinessEntityID = 2

commit

-- [Ex. 1.1]
-- Write a new transaction that changes MiddleName of people with BusinessId between 1 and 5 to 'Sr' 
-- and changes LastName of people with BusinessId between 7 and 10 to 'Lebowski'
-- Table: Person.Person

-- [Ex 1.2]
-- 1. Write and execute a 'begin tran' query
-- 2. Then write and execute a query that will change MaritalStatus to 'S' for person with BusinessEntityID = 2
-- 3. Open another file and display the value of MaritalStatus
-- 4. Write and execute 'commit'
-- 5. Once again display the value of MaritalStatus

-- [Ex 1.3]
-- 1. Write and execute a 'begin tran' query
-- 2. Then write and execute a query that will delete all product reviews
-- 3. Select all product reviews inside the same file
-- 4. Select all product reviews in new file
-- 5. Write and execute 'rollback'
-- table: [Production].[ProductReview]

---------------------------------------- EXAMPLE ERROR

-- It is possible that when trying to commit a transaction some constraints will block one or more queries.
-- Also queries can block each other when trying to change the data in the same place.
-- Some queries could be then send once again to retry the execution but some of them will fail after retry.

-- [Ex. 2.1] Create deadlock
-- Open a new file and copy the content of first block without executing anything
-- Once again open a new file and copy the content of second block
-- Execute the marked part of first file (see comment in block)
-- Execute the marked part second file
-- Try to execute the rest of first file
-- Try to execute the rest of second file
-- Notice the error message in one of the files
-- The file with error can be now executed once again without errors

-- IMPORTANT NOTE: AFTER FINISHING CLOSE ALL OTHER OPEN FILES.(IF PROMPTED ABOUT TRANSACTIONS COMMIT THEM)

--BLOCK ONE START

begin tran tranOne

update [Person].[Address]
set AddressLine1 = 'AddressLine1'
where AddressID = 1

--BLOCK ONE STEP ONE END

update [Production].[Product]
set Color = 'Black'
where ProductID = 1

commit transaction tranOne

--BLOCK ONE END

--BLOCK TWO START

begin tran tranTwo

update [Production].[Product]
set ListPrice = 10
where ProductID = 1

--BLOCK TWO STEP ONE END

update [Person].[Address]
set AddressLine2 = 'AddressLine2'
where AddressID = 1

commit transaction tranTwo

--BLOCK TWO END

-- [Ex. 2.2] transaction blocked by constraint
-- Open a new file and copy the content of first block without executing anything
-- Once again open a new file and copy the content of second block
-- Execute the marked part of first file (see comment in block)
-- Execute the marked part second file
-- Commit the transaction in second file
-- See the error in the second file. 

--BLOCK ONE START

begin tran

update HumanResources.Employee 
set SickLeaveHours = SickLeaveHours - 55
where BusinessEntityID = 10

--BLOCK ONE STEP ONE END

commit

--BLOCK ONE END

--BLOCK TWO START

begin tran

update HumanResources.Employee 
set SickLeaveHours = SickLeaveHours - 61
where BusinessEntityID = 10

--BLOCK TWO STEP ONE END

commit

--BLOCK TWO END

-- IMPORTANT NOTE: AFTER FINISHING CLOSE ALL OTHER OPEN FILES.(IF PROMPTED ABOUT TRANSACTIONS COMMIT THEM)



---------------------------------------- ISOLATION LEVELS

-- https://learn.microsoft.com/en-us/sql/connect/jdbc/understanding-isolation-levels?view=sql-server-ver16
-- https://en.wikipedia.org/wiki/Isolation_%28database_systems%29

-- In this section we will see how transactions behave in certain situations.
-- Instead of writing queries students should open prepared files and execute
-- queries in specific order to observe the differences between levels.

------------------- Dirty read

-- [Ex. 3.1] - read uncommitted and dirty read
-- 1. Open READUNCOMMITTED_DIRTYREAD_SELECT.sql
-- 2. Execute the first part of the file
-- 3. Open READUNCOMMITTED_DIRTYREAD_UPDATE.sql and execute first part of the second file
-- 4. Execute the rest of the first file. See that the value changed even without commiting the second transaction
-- 5. Execute the second part of the update transaction
-- 6. Once again execute read transaction and notice that the column returned to original value

-- [Ex. 3.2] - read committed and dirty read prevented
-- Perform once again the same set of actions but this time use files:
-- READCOMMITTED_DIRTYREAD_SELECT.sql and READCOMMITTED_DIRTYREAD_UPDATE.sql
-- This time the dirty read should be prevented and original value should be displayed every time


------------------- Non-Repeatable Read

-- [Ex. 3.3] - read committed and non-repeatable reads
-- 1. Open READCOMMITTED_NONREPREAD_SELECT.sql
-- 1. Open READCOMMITTED_NONREPREAD_UPDATE.sql
-- 2. Execute first part of the first file and observe the [ListPrice] value
-- 3. Execute the whole second file 
-- 4. Execute the remaining part of first file
-- 5. Notice that the exact same query now returns different value of [ListPrice]


-- [Ex. 3.4] - repeatable read and non-repeatable reads prevented
-- Perform once again the same set of actions but this time use files:
-- NONREPREAD_NONREPREAD_SELECT.sql and NONREPREAD_NONREPREAD_UPDATE.sql
-- This time the update query should be blocked until the read query finishes execution
-- Both select queries in the same transaction should return the same values

------------------- Phanton reads

ALTER DATABASE AdventureWorks2019  
SET ALLOW_SNAPSHOT_ISOLATION ON  

-- [Ex. 3.5] - repeatable read and phantom reads
-- 1. Open PHANTOMREADS_NONREPREAD_SELECT.sql
-- 1. Open PHANTOMREADS_NONREPREAD_INSERT.sql
-- 2. Execute first part of the first file and observe that is returned an empty list of records
-- 3. Execute the whole second file 
-- 4. Execute the remaining part of first file
-- 5. Notice that the second time we got a record that have not existed before

-- [Ex. 3.6] - snapshot and phantom reads prevented
-- Perform once again the same set of actions but this time use files:
-- SNAPSHOT_PHANTOMREADS_SELECT.sql and SNAPSHOT_PHANTOMREADS_DELETE.sql
-- This time we are not adding new rows but deleting those from previous example
-- Both select queries in the same transaction should return the same records
-- Rows that have been deleted and commited also should be displayed


------------------- Different order of queries

-- [Ex. 3.7] - snapshot and order of queries
-- 1. Open PHANTOMREADS_NONREPREAD_SELECT.sql
-- 1. Open PHANTOMREADS_NONREPREAD_INSERT.sql
-- 2. Execute first part of the first file and observe that is returned an empty list of records
-- 3. Execute the whole second file 
-- 4. Execute the remaining part of first file
-- 5. Notice that the second time we got a record that have not existed before