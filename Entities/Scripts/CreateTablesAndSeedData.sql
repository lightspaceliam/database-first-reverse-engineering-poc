USE DbFirstReverseEngineering;
GO

IF EXISTS (SELECT [name] FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND TYPE  IN (N'U'))
	DROP TABLE [dbo].[Product]

IF EXISTS (SELECT [name] FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Supplier]') AND TYPE  IN (N'U'))
	DROP TABLE [dbo].[Supplier]

CREATE TABLE [dbo].[Supplier](
	[Id] [INT] IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL
	, [Name] [NVARCHAR](150) NOT NULL
	, [Created] [DATETIME2](7) NOT NULL
	, [LastModified] [DATETIME2](7) NOT NULL
);

CREATE NONCLUSTERED INDEX [IX_Supplier_Name] ON [dbo].[Supplier]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Product](
	[Id] [INT] IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL
	, [Code] [NVARCHAR](50) NOT NULL
	, [Name] [NVARCHAR](150) NOT NULL
	, [SupplierId] [INT] NOT NULL
	, [Created] [DATETIME2](7) NOT NULL
	, [LastModified] [DATETIME2](7) NOT NULL
	, CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierId)
    REFERENCES Supplier(Id)
);

GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Unique_Product_Code] ON [dbo].[Product]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Product_Name] ON [dbo].[Product]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


INSERT INTO dbo.Supplier ([Name], Created, LastModified) VALUES
	('Apple Inc', GETUTCDATE(), GETUTCDATE());

INSERT INTO dbo.Product ([Name], Code, Created, LastModified, SupplierId) VALUES
	('MacBook Pro', 'ABC', GETUTCDATE(), GETUTCDATE(), (SELECT Id FROM dbo.Supplier WHERE LOWER(LTRIM(RTRIM([Name]))) = 'apple inc')),
	('iMac', 'XYZ', GETUTCDATE(), GETUTCDATE(), (SELECT Id FROM dbo.Supplier WHERE LOWER(LTRIM(RTRIM([Name]))) = 'apple inc'));

SELECT 	*
FROM 	dbo.Product AS P
		INNER JOIN dbo.Supplier AS S
			ON P.SupplierId = S.Id