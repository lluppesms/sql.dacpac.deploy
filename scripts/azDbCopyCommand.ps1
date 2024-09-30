param(
    [Parameter(Mandatory = $true)] [string] $ResourceGroup,
    [Parameter(Mandatory = $true)] [string] $DbServerName,
    [Parameter(Mandatory = $true)] [string] $DatabaseToCopy,
    [Parameter(Mandatory = $true)] [string] $CopyDatabaseTo
)

New-AzSqlDatabaseCopy -ResourceGroupName $ResourceGroup -CopyResourceGroupName $ResourceGroup -ServerName $DbServerName -CopyServerName $DbServerName -DatabaseName $DatabaseToCopy -CopyDatabaseName $CopyDatabaseTo
