--QUERY ORDER EXAMPLE - SNAPSHOT - UPDATE

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;  
GO  
BEGIN TRANSACTION insertTran1;  
GO  

update Production.Product 
set Color = 'Black'
where Color = 'White'

-- END OF PART ONE

COMMIT TRANSACTION insertTran1

