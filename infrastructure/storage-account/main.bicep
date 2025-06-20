targetScope = 'subscription'

// Types
type storageAccountSkuType = 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_ZRS'

// Parameters
param location string
param storageAccountSku storageAccountSkuType
param deploymentId string
param commaSeperatedstorageAdminPrincipalIDs string

// Variables
var deploymentIdValidated = length(deploymentId) > 0 ? deploymentId : take(uniqueString(sys.utcNow()), 6)
var storageAdminPrincipalIDs = split(commaSeperatedstorageAdminPrincipalIDs, ',')

// Resources
resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-cost-management'
  location: location
}

module storageAccount 'templates/storage-account.bicep' = {
  name: 'cost-mgmt-storageAccount-${deploymentIdValidated}'
  scope: rg
  params: {
    location: location
    storageAccountSku: storageAccountSku
    storageAdminPrincipalIDs: storageAdminPrincipalIDs
  }
}

// Outputs
output storageAccountName string = storageAccount.outputs.storageAccountName
output storageAccountResourceGroupName string = rg.name
output storageAccountSubscriptionId string = subscription().subscriptionId
output containerName string = storageAccount.outputs.containerName
