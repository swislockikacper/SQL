--DROP INDEXES
DROP INDEX IF EXISTS [dbo].[Client].[CLIENT_NAME_CLUSTERED_INDEX]
GO

--DROP PROCEDURES
DROP PROCEDURE IF EXISTS [dbo].[InsertOrganization]
GO

DROP PROCEDURE IF EXISTS [dbo].[InsertClient]
GO

DROP PROCEDURE IF EXISTS [dbo].[InsertProduct]
GO

DROP PROCEDURE IF EXISTS [dbo].[InsertClientProduct]
GO

--DROP FUNCTIONS 
DROP FUNCTION IF EXISTS [dbo].[GetUserProducts]
GO

--DROP VIEWS 
DROP VIEW IF EXISTS [dbo].[OrganizationAndUser]
GO

DROP VIEW IF EXISTS [dbo].[UsersCountInOrganization]
GO

--DROP FOREIGN KEYS
IF (OBJECT_ID('FK_CLIENT_ORGANIZATION', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE [dbo].[Client] DROP CONSTRAINT FK_CLIENT_ORGANIZATION
END

IF (OBJECT_ID('FK_CLIENTID', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE [dbo].[ClientProduct] DROP CONSTRAINT FK_CLIENTID
END

IF (OBJECT_ID('FK_PRODUCTID', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE [dbo].[ClientProduct] DROP CONSTRAINT FK_PRODUCTID
END

--DROP TABLES
DROP TABLE IF EXISTS [dbo].[ClientProduct]
GO

DROP TABLE IF EXISTS [dbo].[Client]
GO

DROP TABLE IF EXISTS [dbo].[Product]
GO

DROP TABLE IF EXISTS [dbo].[Organization]
GO

--CREATE TABLES
CREATE TABLE [dbo].[Organization]
(
    [Id] INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED NOT NULL,
    [Name] NVARCHAR(100)
);
GO

CREATE TABLE [dbo].[Client]
(
    [Id] INT IDENTITY(1, 1) PRIMARY KEY NONCLUSTERED NOT NULL,
    [OrganizationId] INT NULL,
    [FirstName] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,

    CONSTRAINT FK_CLIENT_ORGANIZATION FOREIGN KEY ([OrganizationId])
        REFERENCES [dbo].[Organization]([Id])
        ON DELETE NO ACTION
);
GO

CREATE TABLE [dbo].[Product]
(
    [Id] INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [Price] INT NOT NULL DEFAULT(100)
);
GO

CREATE TABLE [dbo].[ClientProduct]
(
    [ClientId] INT NOT NULL,
    [ProductId] INT NOT NULL,

    CONSTRAINT PK_CLIENT_PRODUCT PRIMARY KEY ([ClientId], [ProductId]),
    CONSTRAINT FK_CLIENTID FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client]([Id]),
    CONSTRAINT FK_PRODUCTID FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product]([Id])
);
GO

--CREATE INDEXES
CREATE CLUSTERED INDEX CLIENT_NAME_CLUSTERED_INDEX 
    ON [dbo].[Client] ([LastName], [FirstName])
GO

--CREATE PROCEDURES
CREATE PROCEDURE [dbo].[InsertOrganization] @Name NVARCHAR(100)
AS
    INSERT INTO [dbo].[Organization]([Name]) VALUES (@Name)
GO

CREATE PROCEDURE [dbo].[InsertClient] @FirstName NVARCHAR(100), @LastName NVARCHAR(100), @OrganizationId INT
AS
    INSERT INTO [dbo].[Client]([FirstName], [LastName], [OrganizationId]) VALUES (@FirstName, @LastName, @OrganizationId)
GO

CREATE PROCEDURE [dbo].[InsertProduct] @Name NVARCHAR(100), @Price INT
AS
    INSERT INTO [dbo].[Product]([Name], [Price]) VALUES (@Name, @Price)
GO

CREATE PROCEDURE [dbo].[InsertClientProduct] @ClientId INT, @ProductId INT
AS
    INSERT INTO [dbo].[ClientProduct]([ClientId], [ProductId]) VALUES (@ClientId, @ProductId)
GO

--CREATE FUNCTIONS
CREATE FUNCTION [dbo].[GetUserProducts] (@ClientId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT p.[Id] AS ProductId, p.[Name] AS ProductName, c.[FirstName] AS UserFirstName, c.[LastName] AS UserLastName
    FROM [dbo].[Product] p
        INNER JOIN [dbo].[ClientProduct] cp 
            ON p.[Id] = cp.[ProductId]
        INNER JOIN [dbo].[Client] c
            ON c.[Id] = cp.[ClientId]
    WHERE c.[Id] = @ClientId
)
GO

--CREATE VIEWS
CREATE OR ALTER VIEW [dbo].[OrganizationAndUser]
WITH SCHEMABINDING
AS
(
    SELECT o.[Name], c.[FirstName], c.[LastName]
    FROM [dbo].[Organization] o
        INNER JOIN [dbo].[Client] c
        ON c.[OrganizationId] = o.[Id]
    GROUP BY o.[Name], c.[FirstName], c.[LastName]
)
GO

CREATE OR ALTER VIEW [dbo].[UsersCountInOrganization]
WITH SCHEMABINDING
AS
(
    SELECT o.[Name], COUNT(c.[Id]) AS UsersCount
    FROM [dbo].[Organization] o
        INNER JOIN [dbo].[Client] c
        ON c.[OrganizationId] = o.[Id]
    GROUP BY o.[Name]
)
GO