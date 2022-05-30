param StorageAccountName string = 'tfredbiceptest2'
param StorageAccountLocation string = 'westeurope'
param StorageAccountKind string = 'StorageV2'
param StorageAccountSKU object = { 
  name: 'Standard_LRS' 
  tier: 'Standard'
 }

resource sa 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name : StorageAccountName
  location : StorageAccountLocation
  kind : StorageAccountKind
  sku : StorageAccountSKU
  properties:{
    supportsHttpsTrafficOnly: true
  }
}
