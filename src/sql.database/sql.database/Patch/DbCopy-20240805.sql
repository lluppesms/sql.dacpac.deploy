PRINT 'Running: USE master'
USE master
GO

PRINT 'Running: CREATE DATABASE Dadabase0805 AS COPY OF Dadabase'
CREATE DATABASE Dadabase0805 AS COPY OF Dadabase
GO

Print 'Done!'
