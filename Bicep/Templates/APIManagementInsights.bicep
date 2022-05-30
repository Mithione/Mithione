param AIName string = 'msoffice365dev'

// Create Application Insights
resource ai 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${AIName}'
  location: '${resourceGroup().location}'
  kind: 'web'
  properties:{
    Application_Type:'web'
  }
}
