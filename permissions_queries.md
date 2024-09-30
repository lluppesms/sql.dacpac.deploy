# Permissions Example Queries

## Azure SQL Database Copy

``` SQL
CREATE DATABASE database092501 AS COPY OF Dadabase
```

## Query Permissions In Master

``` SQL
SELECT A.name as userName, B.name as login, B.Type_desc, default_database_name, B.*
FROM sys.sysusers A
    FULL OUTER JOIN sys.sql_logins B ON A.sid = B.sid
WHERE islogin = 1 and A.sid is not null

SELECT DP1.name AS DatabaseRoleName,
    isnull (DP2.name, 'No members') AS DatabaseUserName
FROM sys.database_role_members AS DRM
RIGHT OUTER JOIN sys.database_principals AS DP1
    ON DRM.role_principal_id = DP1.principal_id
LEFT OUTER JOIN sys.database_principals AS DP2
    ON DRM.member_principal_id = DP2.principal_id
WHERE DP1.type = 'R'
ORDER BY DP1.name;

SELECT DISTINCT pr.principal_id, pr.name AS [UserName], pr.type_desc AS [User_or_Role], pr.authentication_type_desc AS [Auth_Type], pe.state_desc, pe.permission_name, pe.class_desc, o.[name] AS 'Object'
FROM sys.database_principals AS pr
JOIN sys.database_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
LEFT JOIN sys.objects AS o on (o.object_id = pe.major_id)
AND pr.name NOT IN ('public','loginmanager')
```

## Query Permissions In Child Database

``` SQL
SELECT *
FROM sys.sysusers A
WHERE islogin = 1 and A.sid is not null

SELECT DP1.name AS DatabaseRoleName,
    isnull (DP2.name, 'No members') AS DatabaseUserName
FROM sys.database_role_members AS DRM
RIGHT OUTER JOIN sys.database_principals AS DP1
    ON DRM.role_principal_id = DP1.principal_id
LEFT OUTER JOIN sys.database_principals AS DP2
    ON DRM.member_principal_id = DP2.principal_id
WHERE DP1.type = 'R'
ORDER BY DP1.name;

SELECT DISTINCT pr.principal_id, pr.name AS [UserName], pr.type_desc AS [User_or_Role], pr.authentication_type_desc AS [Auth_Type], pe.state_desc,  pe.permission_name, pe.class_desc, o.[name] AS 'Object'
    FROM sys.database_principals AS pr
    JOIN sys.database_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
    LEFT JOIN sys.objects AS o on (o.object_id = pe.major_id)
```

## Grant User Roles

 ``` SQL
CREATE USER yourServicePrincipal FROM EXTERNAL PROVIDER
ALTER ROLE db_owner ADD MEMBER yourServicePrincipal
```

## Grant Server Roles

``` SQL
CREATE LOGIN [yourServicePrincipal] FROM EXTERNAL PROVIDER
CREATE USER [yourServicePrincipal] FROM EXTERNAL PROVIDER
ALTER SERVER ROLE ##MS_DatabaseManager## ADD MEMBER [yourServicePrincipal];
ALTER SERVER ROLE ##MS_ServerStateReader## DROP MEMBER [yourServicePrincipal];

-- check membership in metadata: --> 1 = Yes
SELECT IS_SRVROLEMEMBER('##MS_DatabaseManager##', 'yourServicePrincipal');

SELECT sql_logins.principal_id AS MemberPrincipalID,
    sql_logins.name AS MemberPrincipalName,
    roles.principal_id AS RolePrincipalID,
    roles.name AS RolePrincipalName
FROM sys.server_role_members AS server_role_members
INNER JOIN sys.server_principals AS roles
    ON server_role_members.role_principal_id = roles.principal_id
LEFT OUTER JOIN sys.sql_logins AS sql_logins
    ON server_role_members.member_principal_id = sql_logins.principal_id
ORDER BY  roles.name,  sql_logins.name
```
