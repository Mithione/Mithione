param apimName string = 'msoffice365devapiarmdeployed'

resource apimPolicy 'Microsoft.ApiManagement/service/policies@2020-12-01' = {
  name: '${apimName}/policy'
  properties:{
    format: 'rawxml'
    value: '<policies><inbound><base /><set-backend-service id="apim-generated-policy" backend-id="orsted-microapi-poc" /><set-body>@(context.Request.Body.As<string>(preserveContent: true))</set-body></inbound><backend><base /></backend><outbound><base /><set-body>@{var response=context.Response.Body.As<JObject>(); return response.ToString();}</set-body></outbound><on-error><base /></on-error></policies>'
  }
}
//'<policies><inbound /><backend><forward-request /></backend><outbound /><on-error /></policies>'
