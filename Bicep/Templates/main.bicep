//-------------------------------------------------------------------------------------------------------------------------------
//  Microservices API - Main template
// 
//  See version history in ...
//-------------------------------------------------------------------------------------------------------------------------------

// Define parameters
param location string = resourceGroup().location

//-------------------------------------------------------------------------------------------------------------------------------
//  Define modules
//-------------------------------------------------------------------------------------------------------------------------------

module api './API.bicep' = {
  name: 'Provisioning-APIManagement'
  params: {
    publisherName: 'Ørsted'
    publisherEmail:'admtfred@orsted.dk'
    apimName: 'msoffice365devapiarmdeployed'
    apimBackendName: 'orsted-microapi-poc'
    apimBackendKeyname: 'orsted-microapi-poc-key'
    apimBackendKeynameValue: 'yItnbThbiiErKmc7jfKeaBFot9HiuIZTOpzgthjYP/+MNdJeDw/V1g=='
    apiDefinitionName: 'orsted-provisioning-services'
    apiOperationName: 'CreateNewSite'
    apiOperationUrl: '/CreateNewSite'
    AIName: 'dev'
    apimLocation: location
    resourceTags: {
      Environment: 'Dev'
      Project: 'MicroserviceAPI'
    }
  }
}

module functionapp './FunctionApp.bicep' = {
  name: 'Provisioning-FunctionApp'
  params: {
    applicationName: 'orstedprovisioningservicespoc'
    functionCreateNewSiteName: 'CreatenewSite'
  }  
}

output outid string = api.outputs.outid
output outname string = api.outputs.outname
