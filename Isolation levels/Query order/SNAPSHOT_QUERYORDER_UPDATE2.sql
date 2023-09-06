--QUERY ORDER EXAMPLE - SNAPSHOT - UPDATE2

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;  
GO  
BEGIN TRANSACTION insertTran2;  
GO  

update Production.Product 
set Color = 'White'
where Color = 'Black'

-- END OF PART ONE

COMMIT TRANSACTION insertTran2

