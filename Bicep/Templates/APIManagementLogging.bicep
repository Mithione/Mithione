param AIName string = 'msoffice365dev'


// Create Logger and link logger
// resource apimLogger 'Microsoft.ApiManagement/service/loggers@2020-12-01' = {
//   name: '${apimName}/${apimName}-logger'
//   properties:{
//     resourceId: '${ai.id}'
//     loggerType: 'applicationInsights'
//     credentials:{
//       instrumentationKey: '${ai.properties.InstrumentationKey}'
//     }
//   }
// }
