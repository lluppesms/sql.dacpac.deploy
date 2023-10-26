// --------------------------------------------------------------------------------
// This BICEP file will create a KeyVault
// FYI: To purge a KV with soft delete enabled: > az keyvault purge --name kvName
// --------------------------------------------------------------------------------
// Remaining Cloud Defender Issue: Medium - Private endpoint should be configured for Key Vault
// --------------------------------------------------------------------------------
param keyVaultName string = 'mykeyvaultname'
param location string = resourceGroup().location
param commonTags object = {}

@description('Administrators that should have access to administer key vault')
param adminUserObjectIds array = []
@description('Application that should have access to read key vault secrets')
param applicationUserObjectIds array = []

@description('Administrator UserId that should have access to administer key vault')
param keyVaultOwnerUserId string = ''
@description('Ip Address of the KV owner so they can read the vault, such as 254.254.254.254/32')
param keyVaultOwnerIpAddress string = ''

@description('Determines if Azure can deploy certificates from this Key Vault.')
param enabledForDeployment bool = true
@description('Determines if templates can reference secrets from this Key Vault.')
param enabledForTemplateDeployment bool = true
@description('Determines if this Key Vault can be used for Azure Disk Encryption.')
param enabledForDiskEncryption bool = true
@description('Determine if soft delete is enabled on this Key Vault.')
param enableSoftDelete bool = false
@description('Determine if purge protection is enabled on this Key Vault.')
param enablePurgeProtection bool = true
@description('The number of days to retain soft deleted vaults and vault objects.')
param softDeleteRetentionInDays int = 7
@description('Determines if access to the objects granted using RBAC. When true, access policies are ignored.')
param useRBAC bool = false

@allowed(['Enabled','Disabled'])
param publicNetworkAccess string = 'Enabled'
@allowed(['Allow','Deny'])
param allowNetworkAccess string = 'Allow'

param createUserAssignedIdentity bool = true
param userAssignedIdentityName string = '${keyVaultName}-cicd'

@description('The workspace to store audit logs.')
@metadata({
  strongType: 'Microsoft.OperationalInsights/workspaces'
  example: '/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.OperationalInsights/workspaces/<workspace_name>'
})
param workspaceId string = ''

// --------------------------------------------------------------------------------
var templateTag = { TemplateFile: '~keyvault.bicep' }
var tags = union(commonTags, templateTag)

var skuName = 'standard'
var subTenantId = subscription().tenantId

var ownerAccessPolicy = keyVaultOwnerUserId == '' ? [] : [
  {
    objectId: keyVaultOwnerUserId
    tenantId: subTenantId
    permissions: {
      certificates: [ 'all' ]
      secrets: [ 'all' ]
      keys: [ 'all' ]
    }
  } 
]
var adminAccessPolicies = [for adminUser in adminUserObjectIds: {
  objectId: adminUser
  tenantId: subTenantId
  permissions: {
    certificates: [ 'all' ]
    secrets: [ 'all' ]
    keys: [ 'all' ]
  }
}]
var applicationUserPolicies = [for appUser in applicationUserObjectIds: {
  objectId: appUser
  tenantId: subTenantId
  permissions: {
    secrets: [ 'get' ]
    keys: [ 'get', 'wrapKey', 'unwrapKey' ] // Azure SQL uses these permissions to access TDE key
  }
}]
var accessPolicies = union(ownerAccessPolicy, adminAccessPolicies, applicationUserPolicies)

var kvIpRules = keyVaultOwnerIpAddress == '' ? [] : [
  {
    value: keyVaultOwnerIpAddress
  }
] 

// --------------------------------------------------------------------------------
resource keyVaultResource 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }
    tenantId: subTenantId

    // Use Access Policies model
    enableRbacAuthorization: useRBAC
    // add function app and web app identities in the access policies so they can read the secrets
    accessPolicies: accessPolicies

    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableSoftDelete: enableSoftDelete

    enablePurgeProtection: enablePurgeProtection // Not allowing to purge key vault or its objects after deletion
    createMode: 'default'                        // Creating or updating the key vault (not recovering)
    softDeleteRetentionInDays: softDeleteRetentionInDays

    publicNetworkAccess: publicNetworkAccess   // Allow access from all networks

    networkAcls: {
      defaultAction: allowNetworkAccess
      bypass: 'AzureServices'
      ipRules: kvIpRules
      virtualNetworkRules: []
    }
  }
}

// this creates a user assigned identity that can be used to verify and update secrets in future steps
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = if (createUserAssignedIdentity) {
  name: userAssignedIdentityName
  location: location
}
resource userAssignedIdentityKeyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = if (createUserAssignedIdentity) {
  name: 'add'
  parent: keyVaultResource
  properties: {
    accessPolicies: [
      {
        permissions: {
          secrets: ['get','list','set']
        }
        tenantId: userAssignedIdentity.properties.tenantId
        objectId: userAssignedIdentity.properties.principalId
      }
    ]
  }
}

resource keyVaultAuditLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (workspaceId != '') {
  name: '${keyVaultResource.name}-auditlogs'
  scope: keyVaultResource
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        // retentionPolicy: {
        //   days: 180
        //   enabled: true 
        // }
      }
    ]
  }
}

resource keyVaultMetricLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (workspaceId != '') {
  name: '${keyVaultResource.name}-metrics'
  scope: keyVaultResource
  properties: {
    workspaceId: workspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        // retentionPolicy: {
        //   days: 30
        //   enabled: true 
        // }
      }
    ]
  }
}

// --------------------------------------------------------------------------------
output name string = keyVaultResource.name
output id string = keyVaultResource.id
output userManagedIdentityId string = userAssignedIdentity != null ? userAssignedIdentity.id : ''
output subscriptionId string = subscription().subscriptionId
