﻿PRINT 'Running: USE master'
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
