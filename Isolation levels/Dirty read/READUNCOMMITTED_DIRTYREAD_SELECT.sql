--DIRTY READ EXAMPLE - READ UNCOMMITED - READ

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
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