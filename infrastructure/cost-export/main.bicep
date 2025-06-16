targetScope = 'subscription'

// Types
import { environmentType } from 'templates/cost-export.bicep'

type costManagementScopeType = {
  subscriptionId: string
  costExportSuffix: string
}

// Parameters
@description('The location for the cost export deployment.')
param location string

@description('Deployment environment. Used to differentiate non-production export names and the managed identity that will be created.')
param environment environmentType

@description('An array of cost management scopes to create exports for.')
param costManagementScopes costManagementScopeType[] 

@description('The name of the storage account where the cost export will be delivered.')
param storageAccountName string

@description('The subscription ID that contains the storage account.')
param storageAccountSubscriptionId string

@description('The resource group name that contains the storage account.')
param storageAccountResourceGroupName string

@description('The name of the container in the storage account where the cost export will be delivered.')
param containerName string

@description('A unique identifier for the deployment.')
param deploymentId string = take(uniqueString(sys.utcNow()), 6)

// Resources
module costExports 'templates/cost-export.bicep' = [for scope in costManagementScopes: if (length(scope.subscriptionId) > 0) {
  name: 'cost-export-${scope.costExportSuffix}-${deploymentId}'
  scope: subscription(scope.subscriptionId)
  params: {
    location: location
    environment: environment
    costExportNameSuffix: scope.costExportSuffix
    storageAccountName: storageAccountName
    storageAccountSubscriptionId: storageAccountSubscriptionId
    storageAccountResourceGroupName: storageAccountResourceGroupName
    containerName: containerName
  }
}]
