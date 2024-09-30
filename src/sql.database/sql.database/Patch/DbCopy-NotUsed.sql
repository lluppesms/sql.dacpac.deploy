-- Replaced by call to azDbCopyCommand.ps1
-- You can use this interactively, but it doesn't play well in a deployment pipeline
-- https://learn.microsoft.com/en-us/azure/azure-sql/database/database-copy
PRINT 'Running: USE master'
USE master
GO

PRINT '--------------------------------------------------'
PRINT 'Running: SELECT name FROM master.dbo.sysdatabases'
SELECT name FROM master.dbo.sysdatabases
GO

PRINT '--------------------------------------------------'
PRINT 'Running: CREATE DATABASE DadabaseV2 AS COPY OF Dadabase'
CREATE DATABASE DadabaseV2 AS COPY OF Dadabase
GO

PRINT '--------------------------------------------------'
PRINT 'Running: SELECT name FROM master.dbo.sysdatabases'
SELECT name FROM master.dbo.sysdatabases
GO

PRINT '--------------------------------------------------'
Print 'Done!'
