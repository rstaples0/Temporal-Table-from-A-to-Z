--Create a Schema and Temporal Table
CREATE SCHEMA History
GO

CREATE TABLE [dbo].[Transactions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TRANSACTION_DATE] [date] NOT NULL,
	[REFERENCE_NUMBER] [varchar](50) NULL,
	[AMOUNT] [decimal](18, 2) NOT NULL,
	[COMMENTS] [varchar](2500) NULL,
	[WIRE_ADDENDA] [varchar](50) NULL,
	[VENDOR_NUMBER] [varchar](50) NULL,
	[POSTED] [bit] NULL,
	[CD_DELETE] [int] NULL,
	[TEMPLATE_ID] [int] NULL,
	[RECEIPT_DISBURSEMENT_ID] [int] NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATED_BY] [varchar](50) NULL,
	[MODIFIED_DATE] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](0) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK1_TRANSACTIONS_TEMPORAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [History].[Transactions] )
)
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_ValidFrom_Transactions]  DEFAULT (SYSUTCDATETIME()) FOR [ValidFrom]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_ValidTo_Transactions]  DEFAULT (CONVERT([datetime2](0),'9999-12-31 23:59:59',(0))) FOR [ValidTo]
GO

--Insert 1,000 records into table
declare @amount float;

set @amount = 100;

insert into Transactions
([TRANSACTION_DATE],[AMOUNT],[COMMENTS],[CREATE_DATE],[CREATED_BY],[MODIFIED_DATE],[MODIFIED_BY])
values (
dateadd(day,-(select coalesce(max(ID),0) from Transactions), '2020-11-02')
,@amount + (select coalesce(max(ID),0) from Transactions)
,concat('Transaction #', cast((select coalesce(max(ID),0) from Transactions) as varchar(10)))
,SYSUTCDATETIME()
,'SQLUser'
,SYSUTCDATETIME()
,'SQLUser'
)

GO 1000



--Drop a column
alter table Transactions
drop column CD_DELETE;

GO




--Add a column
alter table Transactions
add IS_DELETED bit default 0 not null;




--Rename a column
EXEC sp_rename 'Transactions.VENDOR_NUMBER', 'VENDOR_NO', 'COLUMN';

GO




--Drop a table with a Temporal table
USE [DemoDB]
GO

ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [DF_ValidTo_Transactions]
GO

ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [DF_ValidFrom_Transactions]
GO

ALTER TABLE [dbo].[Transactions] SET ( SYSTEM_VERSIONING = OFF  )
GO

DROP TABLE [dbo].[Transactions]
GO

DROP TABLE [History].[Transactions]
GO

DROP SCHEMA History
GO




--Create a Temporal table
CREATE SCHEMA History
GO

CREATE TABLE [dbo].[Transactions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TRANSACTION_DATE] [date] NOT NULL,
	[REFERENCE_NUMBER] [varchar](50) NULL,
	[AMOUNT] [decimal](18, 2) NOT NULL,
	[COMMENTS] [varchar](2500) NULL,
	[WIRE_ADDENDA] [varchar](50) NULL,
	[VENDOR_NUMBER] [varchar](50) NULL,
	[POSTED] [bit] NULL,
	[CD_DELETE] [int] NULL,
	[TEMPLATE_ID] [int] NULL,
	[RECEIPT_DISBURSEMENT_ID] [int] NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATED_BY] [varchar](50) NULL,
	[MODIFIED_DATE] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	[ValidFrom] [datetime2](0) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](0) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK1_TRANSACTIONS_TEMPORAL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [History].[Transactions] )
)
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_ValidFrom_Transactions]  DEFAULT (SYSUTCDATETIME()) FOR [ValidFrom]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_ValidTo_Transactions]  DEFAULT (CONVERT([datetime2](0),'9999-12-31 23:59:59',(0))) FOR [ValidTo]
GO




--Insert 1,000 records into table
declare @amount float;

set @amount = 100;

insert into Transactions
([TRANSACTION_DATE],[AMOUNT],[COMMENTS],[CREATE_DATE],[CREATED_BY],[MODIFIED_DATE],[MODIFIED_BY])
values (
dateadd(day,-(select coalesce(max(ID),0) from Transactions), '2020-11-02')
,@amount + (select coalesce(max(ID),0) from Transactions)
,concat('Transaction #', cast((select coalesce(max(ID),0) from Transactions) as varchar(10)))
,SYSUTCDATETIME()
,'SQLUser'
,SYSUTCDATETIME()
,'SQLUser'
)

GO 1000




--Verify Temporal table is empty
select * from History.Transactions;




--Update 1,000 records
declare @amount float;

set @amount = 100;

update t
set t.AMOUNT = t.AMOUNT + @amount
,t.MODIFIED_DATE = SYSUTCDATETIME()
from Transactions t




--Verify Temporal table is no longer empty
select * from History.Transactions;




--Delete 11 records
delete from Transactions where ID between 900 and 910




--From NULL to NOT NULL
alter table Transactions SET (System_Versioning = Off);

alter table Transactions
add constraint df_POSTED DEFAULT 0 for POSTED;

update Transactions
set POSTED = 0;

alter table Transactions
alter column POSTED bit NOT NULL;

update History.Transactions
set POSTED = 0;

alter table History.Transactions
alter column POSTED bit NOT NULL;

alter table Transactions SET (System_Versioning = On (History_Table=History.Transactions));
