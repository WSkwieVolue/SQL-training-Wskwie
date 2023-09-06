--DIRTY READ EXAMPLE - READ COMMITED - READ

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
GO  
BEGIN TRANSACTION readtran;  
GO  

SELECT *   
    FROM Sales.Currency 
	where CurrencyCode = 'AED'
GO  

-- END OF FIRST PART

SELECT *   
    FROM Sales.Currency 
	where CurrencyCode = 'AED'
GO 

COMMIT TRANSACTION readtran;  
GO  