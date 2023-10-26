// --------------------------------------------------------------------------------
// Creates a Log Analytics Workspace
// --------------------------------------------------------------------------------
param logAnalyticsWorkspaceName string = 'myLogAnalyticsWorkspaceName'
param location string = resourceGroup().location
param commonTags object = {}

// --------------------------------------------------------------------------------
var templateTag = { TemplateFile: '~loganalytics.bicep' }
var tags = union(commonTags, templateTag)

// --------------------------------------------------------------------------------
resource logWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    sku: {
        name: 'PerGB2018' // Standard
    }
    retentionInDays: 90
    //you can limit the maximum daily ingestion on the Workspace by providing a value for dailyQuotaGb. 
    // Note: Bicep expects an integer, however in order to set the minimum possible value of 0.023 GB
    // you need to pass it as a string which will work just fine in AzDO (but will fail in GHA!)
    workspaceCapping: {
      dailyQuotaGb: 1 // '0.023'
    }
  }
}

// --------------------------------------------------------------------------------
output id string = logWorkspaceResource.id
output name string = logWorkspaceResource.name
