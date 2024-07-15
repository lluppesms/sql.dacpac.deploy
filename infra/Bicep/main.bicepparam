// ----------------------------------------------------------------------------------------------------
// Bicep Parameter File
// ----------------------------------------------------------------------------------------------------

using './main.bicep'

param adminLoginUserId = '#{adminLoginUserId}#'
param adminLoginUserSid = '#{adminLoginUserSid}#'
param adminLoginTenantId = '#{adminLoginTenantId}#'
param appName = '#{appName}#'
param environmentCode = '#{environmentNameLower}#'
param keyVaultOwnerUserId = '#{keyVaultOwnerUserId}#'
param location = '#{location}#'
param sqlAdminUser = '#{sqlAdminUser}#'
param sqlAdminPassword = '#{sqlAdminPassword}#'
param sqlDatabaseName = '#{sqlDatabaseName}#'
param sqlServerNamePrefix = '#{sqlServerNamePrefix}#'
param sqlSkuTier = '#{sqlSkuTier}#'
param sqlSkuFamily = '#{sqlSkuFamily}#'
param sqlSkuName = '#{sqlSkuName}#'
param storageSku = '#{storageSku}#'
