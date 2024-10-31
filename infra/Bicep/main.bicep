// --------------------------------------------------------------------------------
// Main Bicep file that creates all of the Azure Resources for one environment
// --------------------------------------------------------------------------------
// To deploy this Bicep manually:
// 	 az login
//   az account set --subscription <subscriptionId>
//   az deployment group create -n main-deploy-20231024T1634Z --resource-group rg_sql_demo --template-file 'main.bicep' --parameters environmentCode=demo databaseName=dadabase sqlSkuTier=GeneralPurpose sqlSkuFamily=Gen5 sqlSkuName=GP_S_Gen5 keyVaultOwnerUserId=xxxxxxxx-xxxx-xxxx adminLoginUserSid=xxxxxxxx-xxxx-xxxx adminLoginTenantId=xxxxxxxx-xxxx-xxxx adminLoginUserId=xxxxxxxx@onmicrosoft.com
// --------------------------------------------------------------------------------
@allowed(['azd','gha','azdo','dev','demo','qa','stg','ct','prod'])
param environmentCode string = 'azd'
param location string = resourceGroup().location
param keyVaultOwnerUserId string = ''
param sqlServerNamePrefix string = ''
param sqlDatabaseName string = 'dadabase'
@allowed(['Basic','Standard','Premium','BusinessCritical','GeneralPurpose'])
param sqlSkuTier string = 'GeneralPurpose'
param sqlSkuFamily string = 'Gen5'
param sqlSkuName string = 'GP_S_Gen5'
param adminLoginUserId string = ''
param adminLoginUserSid string = ''
param adminLoginTenantId string = ''
param sqlAdminUser string = ''
@secure()
param sqlAdminPassword string = ''
param storageSku string = 'Standard_LRS'
param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
var deploymentSuffix = '-${runDateTime}'
var commonTags = {         
  LastDeployed: runDateTime
  Environment: environmentCode
}

// --------------------------------------------------------------------------------
module resourceNames 'resourcenames.bicep' = {
  name: 'resourcenames${deploymentSuffix}'
  params: {
    environmentCode: environmentCode
    location: location
    sqlServerNamePrefix: sqlServerNamePrefix
  }
}
// --------------------------------------------------------------------------------
module logAnalyticsWorkspaceModule 'loganalyticsworkspace.bicep' = {
  name: 'logAnalytics${deploymentSuffix}'
  params: {
    logAnalyticsWorkspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    location: location
    commonTags: commonTags
  }
}

// --------------------------------------------------------------------------------
module storageModule 'storageaccount.bicep' = {
  name: 'storage${deploymentSuffix}'
  params: {
    storageSku: storageSku
    storageAccountName: resourceNames.outputs.storageAccountName
    location: location
    commonTags: commonTags
    allowNetworkAccess: 'Deny'
  }
}

module sqlDbModule 'sqlserver.bicep' = {
  name: 'sql-server${deploymentSuffix}'
  params: {
    sqlServerName: resourceNames.outputs.sqlServerName
    sqlDBName: sqlDatabaseName
    sqlSkuTier: sqlSkuTier
    sqlSkuName: sqlSkuName
    sqlSkuFamily: sqlSkuFamily
    mincores: 1
    autopause: 60
    location: location
    commonTags: commonTags
    adAdminUserId: adminLoginUserId
    adAdminUserSid: adminLoginUserSid
    adAdminTenantId: adminLoginTenantId
    sqlAdminUser:sqlAdminUser
    sqlAdminPassword: sqlAdminPassword
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
    // storageAccountName: resourceNames.outputs.storageAccountName
  }
}

module keyVaultModule 'keyvault.bicep' = {
  name: 'keyvault${deploymentSuffix}'
  params: {
    keyVaultName: resourceNames.outputs.keyVaultName
    location: location
    commonTags: commonTags
    adminUserObjectIds: [ keyVaultOwnerUserId ]
    applicationUserObjectIds: [ ]
    workspaceId: logAnalyticsWorkspaceModule.outputs.id
  }
}

module keyVaultSecretList 'keyvaultlistsecretnames.bicep' = {
  name: 'keyVault-Secret-List-Names${deploymentSuffix}'
  dependsOn: [ keyVaultModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    location: location
    userManagedIdentityId: keyVaultModule.outputs.userManagedIdentityId
  }
}

module keyVaultSecret2 'keyvaultsecretsqlserver.bicep' = {
  name: 'keyVaultSecret2${deploymentSuffix}'
  dependsOn: [ keyVaultModule, sqlDbModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'sqlConnectionString'
    sqlServerName: sqlDbModule.outputs.serverName
    sqlDatabaseName: sqlDbModule.outputs.databaseName
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}

module keyVaultSecret3 'keyvaultsecret.bicep' = {
  name: 'keyVaultSecret3${deploymentSuffix}'
  dependsOn: [ keyVaultModule, sqlDbModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'sqlAdminUser'
    secretValue: sqlAdminUser
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}

module keyVaultSecret4 'keyvaultsecret.bicep' = {
  name: 'keyVaultSecret4${deploymentSuffix}'
  dependsOn: [ keyVaultModule, sqlDbModule ]
  params: {
    keyVaultName: keyVaultModule.outputs.name
    secretName: 'sqlAdminPassword'
    secretValue: sqlAdminPassword
    existingSecretNames: keyVaultSecretList.outputs.secretNameList
  }
}

// --------------------------------------------------------------------------------
var fqdnSqlServer = '${sqlDbModule.outputs.serverName}${environment().suffixes.sqlServerHostname}'
output fqdnSqlServerName string = fqdnSqlServer
output sqlServerName string = sqlDbModule.outputs.serverName
output sqlDatabaseName string = sqlDatabaseName
