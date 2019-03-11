DECLARE @OrganizationCounter AS SMALLINT = 1
DECLARE @OrganizationName AS NVARCHAR(20) = ''

WHILE @OrganizationCounter < 11
BEGIN
    SET @OrganizationName = CONCAT('Organization', @OrganizationCounter)
    EXEC [dbo].[InsertOrganization] @Name = @OrganizationName
    SET @OrganizationCounter = @OrganizationCounter + 1
END
GO

DECLARE @ClientCounter AS INT = 1
DECLARE @ClientName AS NVARCHAR(40) = ''
DECLARE @ClientLastName AS NVARCHAR(60) = ''
DECLARE @ClientOrganizationId AS INT = 1

WHILE @ClientCounter < 100000
BEGIN
    SET @ClientOrganizationId = FLOOR(RAND()* 10) + 1
    SET @ClientName = 'Name' + STR(FLOOR(RAND()* 100000))
    SET @ClientLastName = 'LastName' + STR(FLOOR(RAND()* 100000))
    EXEC [dbo].[InsertClient] @FirstName = @ClientName, @LastName = @ClientLastName, @OrganizationId = @ClientOrganizationId
    SET @ClientCounter = @ClientCounter + 1
END
GO

DECLARE @ProductCounter AS SMALLINT = 1
DECLARE @ProductName AS NVARCHAR(20) = ''
DECLARE @ProductPrice AS INT = 100

WHILE @ProductCounter < 10000
BEGIN
    SET @ProductPrice = FLOOR(RAND()* 1000) + 100
    SET @ProductName = CONCAT('Product', @ProductCounter)
    EXEC [dbo].[InsertProduct] @Name = @ProductName, @Price = @ProductPrice
    SET @ProductCounter = @ProductCounter + 1
END
GO

DECLARE @ClientProductCounter AS INT = 1
DECLARE @ClientProductId AS INT = 1
DECLARE @ProductClientId AS INT = 1

WHILE @ClientProductCounter < 100000
BEGIN
    SET @ClientProductId = FLOOR(RAND()* 100000) + 1
    SET @ProductClientId = FLOOR(RAND()* 10000) + 1
    EXEC [dbo].[InsertClientProduct] @ClientId = @ClientProductId, @ProductId = @ProductClientId
    SET @ClientProductCounter = @ClientProductCounter + 1
END
GO