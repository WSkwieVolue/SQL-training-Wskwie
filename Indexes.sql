-- Training script by Wojciech Skwierawski for Volue

use AdventureWorks2019

--This script should not be executed as a whole
RAISERROR ('Oooopsie. This file should not be executed this way ;).',20,-1) with log

---------------------------------------- CREATING CLUSTERED INDEX
-- CREATE CLUSTERED INDEX <index name>   
--    ON <table name> (<column names in order>);   


-- TO USE THIS QUERY FIRST YOU HAVE TO EXECUTE ActReqCreateBidTables.sql
CREATE CLUSTERED INDEX IC_ActivationBid_CI ON ActivationBid (ValidFor, ActivationBidId)

-- EXAMPLE OF CREATING INDEX WHEN CREATING TABLE
 CREATE TABLE [dbo].[TimeSeriesIndexedDocument](
	[TimeSeriesDocumentId] [varchar](32) NOT NULL PRIMARY KEY,
	[ControlArea] [varchar](10) NOT NULL,
	[MarketReference] [varchar](40) NOT NULL,
	[TradeObjectReference] [varchar](60) NOT NULL,
	[TimeSeriesType] [varchar](60) NOT NULL,
	[Extension] [varchar](60) NULL,
	[Resolution] [varchar](20) NULL,
	[MeasureUnit] [varchar](20) NULL,
	[Source] [varchar](60) NULL,
	[Volumes] [nvarchar](max) NOT NULL,
	[Qualities] [nvarchar](max) NOT NULL,
	[DocumentDate] [bigint] NOT NULL,
	[ValidFor] [bigint] NOT NULL,
	[Currency] [varchar](20) NULL,
	CONSTRAINT IX_TimeSeriesIndexedDocument UNIQUE CLUSTERED ([ValidFor], [ControlArea], [MarketReference], [TradeObjectReference], [TimeSeriesType], [Extension])
) 

-- [Ex. 1.1]
-- Create table using CreateTable.sql file added to this repository
-- Add a clustered index on that table. Use HireDate and BusinessEntityId

---------------------------------------- CREATING NONCLUSTERED INDEX
-- CREATE NONCLUSTERED INDEX <index name> ON <table name> (<column names>)

CREATE NONCLUSTERED INDEX IC_ActivationBid_NI ON ActivationBid (ExternalBidId)

-- [Ex. 2.1]
-- Create non-clustered index on the table from previous exercise.
-- Use rowguid column

---------------------------------------- INDEX FRAGMENTATION AND PAGE FULLNESS

-- https://solutioncenter.apexsql.com/why-when-and-how-to-rebuild-and-reorganize-sql-server-indexes/

--SELECT OBJECT_NAME(ips.OBJECT_ID)
-- ,i.NAME
-- ,ips.index_id
-- ,index_type_desc
-- ,avg_fragmentation_in_percent
-- ,avg_page_space_used_in_percent
-- ,page_count
--FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
--INNER JOIN sys.indexes i ON (ips.object_id = i.object_id)
-- AND (ips.index_id = i.index_id)
--ORDER BY avg_fragmentation_in_percent DESC


-- ALTER INDEX ALL ON <table name> REORGANIZE;

-- ALTER INDEX ALL ON <table name> REBUILD;


-- [Ex. 3.1]
-- Display mentioned values and reorganize indexes on 2 selected tables.
-- Select the values once again

-- [Ex. 3.2]
-- Display mentioned values and rebuild indexes on 2 selected tables.
-- Select the values once again