param(
    [Parameter(Mandatory = $true)] [string] $FQDNServerName,
    [Parameter(Mandatory = $true)] [string] $RunInDatabase,
    [Parameter(Mandatory = $true)] [string] $SqlFullFileName,
    [Parameter(Mandatory = $true)] [string] $SqlAccessToken
    
)

Invoke-SqlCmd -ServerInstance "$FQDNServerName" -Database "$RunInDatabase" -AccessToken "$SqlAccessToken" -InputFile "$SqlFullFileName" -OutputSqlErrors $true -Verbose -Debug
