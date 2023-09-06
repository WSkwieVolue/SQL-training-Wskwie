--PHANTOM READ EXAMPLE - REPEATABLE READ - READ

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
GO  
BEGIN TRANSACTION readTran;  
GO  

select * from 
Sales.Currency
where CurrencyCode like 'W%'

-- END OF FIRST PART

select * from 
Sales.Currency
where CurrencyCode like 'W%'

COMMIT TRANSACTION readTran;  
GO  