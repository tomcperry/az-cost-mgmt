targetScope = 'subscription'

// Types
type storageAccountSkuType = 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_ZRS'
import { environmentType } from 'cost-export/cost-export.bicep'

type costManagementScopeType = {
  subscriptionId: string
  costExportSuffix: string
}

// Parameters
param location string
param environment environmentType
param storageAccountSku storageAccountSkuType
param costManagementScopes costManagementScopeType[]
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

module costExports 'cost-export/cost-export.bicep' = [for costManagementScope in costManagementScopes: if (length(costManagementScope.subscriptionId) > 0) {
  name: 'cost-export-${costManagementScope.costExportSuffix}-${deploymentId}'
  scope: subscription(costManagementScope.subscriptionId)
  params: {
    environment: environment
    costExportNameSuffix: costManagementScope.costExportSuffix
    location: location
    storageAccountName: storageAccount.name
    storageAccountSubscriptionId: subscription().subscriptionId
    storageAccountResourceGroupName: rg.name
    containerName: storageAccount.outputs.containerName
  }
}]
