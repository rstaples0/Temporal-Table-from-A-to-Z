--Add a temporal table to an existing table
ALTER TABLE [dbo].[TransactionsNoHistory] ADD [ValidFrom] [datetime2](0) GENERATED ALWAYS AS ROW START NOT NULL
											,[ValidTo] [datetime2](0) GENERATED ALWAYS AS ROW END NOT NULL
											,CONSTRAINT [DF_ValidFrom_Transactions_NoHistory] DEFAULT (SYSUTCDATETIME()) FOR [ValidFrom]
											,CONSTRAINT [DF_ValidTo_Transactions_NoHistory] DEFAULT (CONVERT([datetime2](0),'9999-12-31 23:59:59',(0))) FOR [ValidTo]
											,PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
GO

ALTER TABLE [dbo].[TransactionsNoHistory] SET (SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [History].[TransactionsNoHistory] ))
GO




--DO NOT RUN in Presentation; Done before presentation; Create a non-System Versioned table
CREATE TABLE [dbo].[TransactionsNoHistory](
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
 CONSTRAINT [PK1_TRANSACTIONS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--DO NOT RUN in Presentation; Done before presentation; Insert 1,000 records into non-System Versioned table
declare @amount float;

set @amount = 100;

insert into TransactionsNoHistory
([TRANSACTION_DATE],[AMOUNT],[COMMENTS],[CREATE_DATE],[CREATED_BY],[MODIFIED_DATE],[MODIFIED_BY])
values (
dateadd(day,-(select coalesce(max(ID),0) from TransactionsNoHistory), convert(varchar(10), getdate(), 120))
,@amount + (select coalesce(max(ID),0) from TransactionsNoHistory)
,concat('Transaction #', cast((select coalesce(max(ID),0) from TransactionsNoHistory) as varchar(10)))
,SYSUTCDATETIME()
,'SQLUser'
,SYSUTCDATETIME()
,'SQLUser'
)

GO 1000

