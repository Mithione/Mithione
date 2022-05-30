//-------------------------------------------------------------------------------------------------------------------------------
//  Microservices API - API management template
// 
//  See version history in ...
//-------------------------------------------------------------------------------------------------------------------------------

// Define parameters
param publisherName string //= 'Ørsted'
param publisherEmail string //= 'admtfred@orsted.dk'
param apimName string //= 'msoffice365devapiarmdeployed'
param apimBackendName string //= 'orsted-microapi-poc'
param apimBackendKeyname string //= 'orsted-microapi-poc-key'
param apiDefinitionName string //= 'orsted-provisioning-services'
param apiOperationName string //= 'CreateNewSite'
param apiOperationUrl string //= '/CreateNewSite'
param AIName string //= 'dev'
param apimLocation string //= 'westeurope'
param resourceTags object
var apiOperationPolicy = '''
<policies>
    <inbound>
        <base />
        <set-backend-service id="apim-generated-policy" backend-id="orsted-microapi-poc" />
        <set-body>@(context.Request.Body.As<string>(preserveContent: true))</set-body>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <set-body>@{  
          var response = context.Response.Body.As<JObject>();  
          return response.ToString(); 
        }</set-body>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
'''

// param resourceTags object = {
//   Environment: 'Dev'
//   Project: 'MicroserviceAPI'
// }

//-------------------------------------------------------------------------------------------------------------------------------
//  Define resources
//-------------------------------------------------------------------------------------------------------------------------------

// Create API
resource apim 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: '${apimName}'
  location: '${resourceGroup().location}'
  tags: resourceTags
  sku:{
    capacity: 1
    name: 'Developer'	
  }
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    publisherName: '${publisherName}'
    publisherEmail: '${publisherEmail}'
  }
}

// Create a product
resource apimProduct 'Microsoft.ApiManagement/service/products@2020-12-01' = {
  name: '${apimName}/Provisioning'
  properties: {
    displayName: 'Provisioning'
    approvalRequired: true
    subscriptionRequired: true
    description: 'Ørsted MicroServices API for Provisioning services'
    state: 'published'
    
  }
}

// Create named value
resource apimNamedValue 'Microsoft.ApiManagement/service/namedValues@2020-12-01' = {
  name: '${apimName}/${apimBackendKeyname}'
  properties: {
    displayName: '${apimBackendKeyname}'
    value: 'yItnbThbiiErKmc7jfKeaBFot9HiuIZTOpzgthjYP/+MNdJeDw/V1g=='
    tags: [
      'key'
      'function'
      'auto'
    ]
    secret: true
  }
}

// Create API backend
resource apimBackend 'Microsoft.ApiManagement/service/backends@2020-12-01' = {
  name: '${apimName}/${apimBackendName}'
  properties: {
    description: apimBackendName
    protocol: 'http'
    url: 'https://orsted-microapi-poc.azurewebsites.net/api'
    resourceId: 'https://management.azure.com/subscriptions/62c9cfc2-9023-40bd-bcce-6f11d9a98388/resourceGroups/MSOffice365-DEV/providers/Microsoft.Web/sites/orsted-microapi-poc'
    credentials:{
      header:{
        'x-functions-key': [ 
          '${apimBackendKeyname}' 
        ]
      }
      
    }
    
  }
}

// Create API definition
resource apimAPIDefinition 'Microsoft.ApiManagement/service/apis@2020-12-01' = {
  name : '${apimName}/${apiDefinitionName}'
  properties: {
    description: 'API that hosts a set of serverless microservices that facilitate functionality for provisioning sites and teams.'
    path: 'orsted-provisioning-services'
    displayName: 'Orsted Provisioning Services'
    apiRevision: '1'    
    subscriptionRequired: true
    protocols: [
      'https'
    ]
    isCurrent: true
  }
}

// Create a product defintion
resource apimAPIDefinitionProduct 'Microsoft.ApiManagement/service/products/apis@2020-12-01' = {
  name: 'msoffice365devapiarmdeployed/provisioning/orsted-provisioning-services'
}

// Create API operation
resource apimAPIOperation 'Microsoft.ApiManagement/service/apis/operations@2020-12-01' = {
  name: '${apimAPIDefinition.name}/${apiOperationName}'
  properties: {
    displayName: '${apiOperationName}'
    method: 'POST'
    urlTemplate: '${apiOperationUrl}'
    description: 'This operation creates a new SharePoint site based on parameters.'
  }
}

// Create policy
resource apimPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2020-12-01' = {
  name: '${apimAPIOperation.name}/policy'
  properties:{
    format: 'rawxml'
    value: apiOperationPolicy
  }
}


// // Add User
// resource apimUser 'Microsoft.ApiManagement/service/users@2019-12-01' = {
//   name: '${apim.name}/custom-user'
//   properties: {
//     firstName: 'Custom'
//     lastName: 'User'
//     state: 'active'
//     email: 'custom-user-email@address.com'
//   }
// }

// // Add Subscription
// resource apimSubscription 'Microsoft.ApiManagement/service/subscriptions@2019-12-01' = {
//   name: '${apim.name}/custom-subscription'
//   properties: {
//     displayName: 'Custom Subscription'
//     primaryKey: 'custom-primary-key-${uniqueString(resourceGroup().id)}'
//     secondaryKey: 'custom-secondary-key-${uniqueString(resourceGroup().id)}'
//     state: 'active'
//     scope: '/products/${apimProduct.id}'
//   }
// }
