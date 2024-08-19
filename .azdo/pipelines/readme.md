# Azure DevOps Deployment Template Notes

## Azure DevOps Template Definitions

Typically, you would want to set up either Option (a), or Option (b) AND Option (c), but not all three jobs.

- [**infra-and-schema-pipeline.yml:**](infra-and-schema-pipeline.yml) Deploys the main.bicep template (which creates all of the resources in Azure), builds the database DACPAC, and then deploys the data structure to the Azure SQL Database.
- [**infra-only-pipeline.yml:**](infra-only-pipeline.yml) Deploys the main.bicep template (which creates all of the resources in Azure) and does nothing else.
- [**schema-only-pipeline.yml:**](schema-only-pipeline.yml) Builds the database DACPAC and then deploys the data structure to a pre-existing Azure SQL Database.
- [**run-sql-pipeline.yml:**](run-sql-pipeline.yml) Runs a specified SQL file against a pre-existing database.

## Warnings

Note that the folder, solution, and project name are coded into the pipelines, so if those are changed, the pipelines will need to be updated.

The SQL Server name is derived from the `sqlServerNamePrefix` and `environment` variables, so if you wish to have this a specific value other than that, you will have to change the bicep templates and the pipelines.

## Deploy Environments

These YML files were designed to run as a single-stage or as a multi-stage environment deploy (i.e. DEV/QA/PROD). Each Azure DevOps environment can have it's own permissions and approvals defined. For example, DEV can be published upon every change, and QA/PROD environments can require an approval before any changes are made.

## Setup Steps

1. [Create Azure DevOps Service Connection](https://docs.luppes.com/CreateServiceConnections/)

1. [Create Azure DevOps Environments](https://docs.luppes.com/CreateDevOpsEnvironments/)

1. Create Azure DevOps Variable Group -- see next step

1. [Create Azure DevOps Pipeline(s)](https://docs.luppes.com/CreateNewPipeline/)

1. Run the infra-and-data-pipeline.yml pipeline to deploy the project to an Azure subscription.

## Create a variable group named "SQLDeployDemo"

To create this variable group, create it manually in the portal with these variables, or customize and run this command in the Azure Cloud Shell:

``` bash
   az login
   az pipelines variable-group create 
     --organization=https://dev.azure.com/<yourAzDOOrg>/ 
     --project='<yourAzDOProject>' 
     --name SQLDeployDemo
     --variables 
         adminLoginTenantId='<adminTenantId>'
         adminLoginUserId='<adminUserId@domainId0>'
         adminLoginUserSid='<adminSID>'
         appName='<uniqueName>' 
         keyVaultOwnerUserId='<owner1SID>'
         location='eastus' 
         resourceGroupPrefix='rg_dacpac_demo'
         serviceConnectionName='<yourServiceConnection>' 
         sqlServerNamePrefix='<uniqueName>'
         sqlDatabaseName='dadabase'
         sqlAdminUser='yourAdminName'
         sqlAdminPassword='yourAdminPassword'
         sqlSkuFamily='Gen5'
         sqlSkuName='GP_S_Gen5'
         sqlSkuTier='GeneralPurpose'
         storageSku='Standard_LRS'
         subscriptionId='<yourSubscriptionId>' 
         subscriptionName='<yourAzureSubscriptionName>' 
```
