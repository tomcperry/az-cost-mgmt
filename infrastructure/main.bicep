targetScope = 'subscription'

// Types
type storageAccountSkuType = 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_ZRS'

// Parameters
param location string
param storageAccountSku storageAccountSkuType
param deploymentId string = take(uniqueString(sys.utcNow()), 6)

// Resources
resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-cost-management'
  location: location
}

module storageAccount 'storage-account/storage-account.bicep' = {
  name: 'cost-mgmt-storageAccount-${deploymentId}'
  scope: rg
  params: {
    location: location
    storageAccountSku: storageAccountSku
  }
}
