CREATE TABLE [ActivationBid](
	[ActivationBidId] [uniqueidentifier] NOT NULL,
	[ExternalBidId] [varchar](50) NOT NULL,
	[Direction] [smallint] NOT NULL,
	[Price] [decimal](11, 3) NOT NULL,
	[ControlArea] [varchar](5) NOT NULL,
	[Market] [varchar](20) NOT NULL,
	[ValidFor] [bigint] NOT NULL,
	[IsOverwritten] [bit] NOT NULL,
	[ActivationTime] [tinyint] NULL,
	[IntervalStart] [bigint] NOT NULL,
	[IntervalEnd] [bigint] NOT NULL,
	[Resolution] [tinyint] NOT NULL,
	[AggregatedReserveObjectAlias] [varchar](40) NULL,
	[LinkedGroupId] [varchar](50) NULL,
	[Owner] [varchar](50) NULL,
 CONSTRAINT [PK_ActivationBid] PRIMARY KEY NONCLUSTERED 
(
	[ActivationBidId]
)) 

CREATE TABLE [ActivationBidCurve](
	[ActivationBidCurveId] [uniqueidentifier] NOT NULL,
	[ReserveObjectAlias] [varchar](40) NULL,
	[ActivationBidCurveActivationBidId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ActivationBidCurve] PRIMARY KEY NONCLUSTERED 
(
	[ActivationBidCurveId] ASC
)) 

ALTER TABLE [ActivationBidCurve]  WITH CHECK ADD  CONSTRAINT [FK_ActivationBidCurve_ActivationBid] FOREIGN KEY([ActivationBidCurveActivationBidId])
REFERENCES [ActivationBid] ([ActivationBidId])
GO

ALTER TABLE [ActivationBidCurve] CHECK CONSTRAINT [FK_ActivationBidCurve_ActivationBid]
GO

CREATE TABLE [ActivationBidCurveValue](
	[ActivationBidCurveValueId] [uniqueidentifier] NOT NULL,
	[Volume] [decimal](11, 3) NOT NULL,
	[Order] [tinyint] NOT NULL,
	[ActivationBidCurveValueActivationBidCurveId] [uniqueidentifier] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ActivationBidCurveValueId] ASC
)) 

ALTER TABLE [ActivationBidCurveValue]  WITH CHECK ADD  CONSTRAINT [FK_ActivationBidCurveValue_ActivationBidCurve] FOREIGN KEY([ActivationBidCurveValueActivationBidCurveId])
REFERENCES [ActivationBidCurve] ([ActivationBidCurveId])
GO

ALTER TABLE [ActivationBidCurveValue] CHECK CONSTRAINT [FK_ActivationBidCurveValue_ActivationBidCurve]
GO

