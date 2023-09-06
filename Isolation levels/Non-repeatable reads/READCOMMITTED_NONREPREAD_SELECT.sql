--NON-REPEATABLE READ EXAMPLE - READ COMMITED - READ

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
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