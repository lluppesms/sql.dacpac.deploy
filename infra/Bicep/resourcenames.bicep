// --------------------------------------------------------------------------------
// Bicep file that builds all the resource names used by other Bicep templates
// --------------------------------------------------------------------------------
@allowed(['azd','gha','azdo','dev','demo','qa','stg','ct','prod'])
param environmentCode string = 'azd'
param location string = 'eastus'
param sqlServerNamePrefix string = 'mysqlserver'

var resourceToken = toLower(uniqueString(resourceGroup().id, environmentCode, location))

// --------------------------------------------------------------------------------
var sanitizedEnvironment = toLower(environmentCode)

// pull resource abbreviations from a common JSON file
var resourceAbbreviations = loadJsonContent('./resourceAbbreviations.json')

// --------------------------------------------------------------------------------
output logAnalyticsWorkspaceName string = toLower('${resourceAbbreviations.logworkspace}-${resourceToken}')
output sqlServerName string             = toLower('${sqlServerNamePrefix}${sanitizedEnvironment}')

// Key Vaults and Storage Accounts can only be 24 characters long
output keyVaultName string              = take('${resourceAbbreviations.keyVaultAbbreviation}${resourceToken}', 24)
output storageAccountName string        = take('${resourceAbbreviations.storageAccountSuffix}${resourceToken}', 24)
