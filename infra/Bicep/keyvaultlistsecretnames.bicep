// -----------------------------------------------------------------------------------------------
// This BICEP file will generate a list of secrets in a KeyVault to use for dup checks, like this:
// ";BlobStorageConnectionString;CosmosConnectionString;GenericSecret;IotHubConnectionString;"
// Each start and end with ";" so you can confidently search for ";mySecret;" and not get fooled
// -----------------------------------------------------------------------------------------------
param keyVaultName string = 'myKeyVault'
param location string = resourceGroup().location
param utcValue string = utcNow()
param userManagedIdentityId string = ''

resource getKeyVaultSecretNames 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'getKeyVaultSecretNameList'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${ userManagedIdentityId }': {} }
  }
  properties: {
    azPowerShellVersion: '8.1'
    forceUpdateTag: utcValue
    retentionInterval: 'PT1H'
    timeout: 'PT5M'
    cleanupPreference: 'Always' // cleanupPreference: 'OnSuccess' or 'Always'
    arguments: ' -KeyVaultName ${keyVaultName}'
    scriptContent: '''
      Param ([string] $KeyVaultName)
      $startDate = Get-Date
      $startTime = [System.Diagnostics.Stopwatch]::StartNew()
      $message = ""
      $message = "Getting names of secrets in vault: $($KeyVaultName)..."
      $secretList = Get-AzKeyVaultSecret -VaultName $KeyVaultName | Select Name
      $secretListFull = ";" + ((-split $secretList) -join ";") + ";"
      $secretListString = $secretListFull.replace("@{Name=", "").replace("}", "")
      $endDate = Get-Date
      $endTime = $startTime.Elapsed;
      $elapsedTime = "Script Elapsed Time: {0:HH:mm:ss}" -f ([datetime]$endTime.Ticks)
      $elapsedTime += "; Start: {0:HH:mm:ss}" -f ([datetime]$startDate)
      $elapsedTime += "; End: {0:HH:mm:ss}" -f ([datetime]$endDate)
      Write-Output $message
      Write-Output $secretListString
      Write-Output $elapsedTime
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['message'] = $message
      $DeploymentScriptOutputs['secretList'] = $secretListString
      $DeploymentScriptOutputs['elapsed'] = $elapsedTime
      '''
  }
}

output message string = getKeyVaultSecretNames.properties.outputs.message
output secretNameList string = getKeyVaultSecretNames.properties.outputs.secretList
output elapsed string = getKeyVaultSecretNames.properties.outputs.elapsed
