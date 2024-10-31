// ----------------------------------------------------------------------------------------------------
// Bicep Parameter File
// ----------------------------------------------------------------------------------------------------

using './main.bicep'

param adminLoginUserId = '#{adminLoginUserId}#'
param adminLoginUserSid = '#{adminLoginUserSid}#'
param adminLoginTenantId = '#{adminLoginTenantId}#'
param environmentCode = '#{environmentNameLower}#'
param keyVaultOwnerUserId = '#{keyVaultOwnerUserId}#'
param location = '#{location}#'
param sqlServerNamePrefix = '#{sqlServerNamePrefix}#'
param sqlAdminUser = '#{sqlAdminUser}#'
param sqlAdminPassword = '#{sqlAdminPassword}#'
param sqlDatabaseName = '#{sqlDatabaseName}#'
param sqlSkuTier = '#{sqlSkuTier}#'
param sqlSkuFamily = '#{sqlSkuFamily}#'
param sqlSkuName = '#{sqlSkuName}#'
param storageSku = '#{storageSku}#'
