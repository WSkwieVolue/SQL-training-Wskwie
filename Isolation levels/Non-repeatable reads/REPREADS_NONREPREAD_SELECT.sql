--NON-REPEATABLE READ EXAMPLE - REPEATABLE READ - READ

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
GO  
BEGIN TRANSACTION readtran;  
GO  

select ListPrice, * from 
Production.Product
where ProductID = 749

-- END OF FIRST PART

select ListPrice, * from 
Production.Product
where ProductID = 749

COMMIT TRANSACTION readtran;  
GO  