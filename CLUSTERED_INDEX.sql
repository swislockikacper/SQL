DROP TABLE IF EXISTS [dbo].[Client]
GO

CREATE TABLE [dbo].[Client] 
(
    [Id] bigint NOT NULL IDENTITY PRIMARY KEY NONCLUSTERED,
    [Name] nvarchar(100) NOT NULL
)
GO

declare @Counter AS int = 1;

WHILE @Counter < 10000
BEGIN
INSERT INTO [dbo].[Client]([Name]) VALUES('Name' + STR(FLOOR(RAND()* 10000)))
SET @Counter = @Counter + 1;
END;
GO

UPDATE [dbo].[Client]
SET [Name] = REPLACE([Name],' ', '')
GO

CREATE CLUSTERED INDEX [ClientNameIndex] ON [dbo].[Client]([Name])
GO

SELECT * 
FROM [dbo].[Client]
WHERE [Name] LIKE 'Name5%'
ORDER BY [Name]

