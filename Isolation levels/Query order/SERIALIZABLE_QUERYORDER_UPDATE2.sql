--QUERY ORDER EXAMPLE - SERIALIZABLE - UPDATE2

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;  
GO  
BEGIN TRANSACTION insertTran2;  
GO  

update Production.Product 
set Color = 'White'
where Color = 'Black'

-- END OF PART ONE

COMMIT TRANSACTION insertTran2

