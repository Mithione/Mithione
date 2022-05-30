//-------------------------------------------------------------------------------------------------------------------------------
//  Microservices API - FunctionApp template
// 
//  See version history in ...
//-------------------------------------------------------------------------------------------------------------------------------

// Define parameters
param applicationName string
param functionCreateNewSiteName string
var location = resourceGroup().location
var storageAccountName = '${substring(applicationName,0,10)}${uniqueString(resourceGroup().id)}' 
var hostingPlanName = '${applicationName}${uniqueString(resourceGroup().id)}'
var appInsightsName = '${applicationName}${uniqueString(resourceGroup().id)}'
var functionAppName = '${applicationName}'
//var functionCreateNewSiteName = 'CreatenewSite'

//-------------------------------------------------------------------------------------------------------------------------------
//  Define resources
//-------------------------------------------------------------------------------------------------------------------------------



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: { 
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  tags: {
    // circular dependency means we can't reference functionApp directly  /subscriptions/<subscriptionId>/resourceGroups/<rg-name>/providers/Microsoft.Web/sites/<appName>"
     'hidden-link:/subscriptions/${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/sites/${functionAppName}': 'Resource'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'Y1' 
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    enabled: true
    httpsOnly: true
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~3'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        // WEBSITE_CONTENTSHARE will also be auto-generated - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#website_contentshare
        // WEBSITE_RUN_FROM_PACKAGE will be set to 1 by func azure functionapp publish
      ]
    }
  }
  dependsOn: [
    appInsights
    hostingPlan
    storageAccount
  ]
}

// resource functionCreateNewSite 'Microsoft.Web/sites/functions@2020-12-01' = {
//   name: '${functionAppName}/${functionCreateNewSiteName}'
//   properties: {
//     script_root_path_href : 'https:/${functionAppName}.azurewebsites.net/admin/vfs/site/wwwroot/${functionCreateNewSiteName}/'
//     script_href: 'https:/${functionAppName}.azurewebsites.net/admin/vfs/site/wwwroot/${functionCreateNewSiteName}/run.ps1'
//     config_href: 'https:/${functionAppName}.azurewebsites.net/admin/vfs/site/wwwroot/${functionCreateNewSiteName}/function.json'
//     href: 'https:/${functionAppName}.azurewebsites.net/admin/functions/${functionCreateNewSiteName}/'
//     test_data: ''
//   }
// }
