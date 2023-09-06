--PHANTOM READ EXAMPLE - REPEATABLE READ - INSERT

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
GO  
BEGIN TRANSACTION insertTran;  
GO  

insert into Sales.Currency 
([CurrencyCode], [Name])
values
('W0J', 'WojtekCurrency')


COMMIT TRANSACTION insertTran

