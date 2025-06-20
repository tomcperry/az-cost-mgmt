targetScope = 'subscription'

@export()
type environmentType = 'production' | 'staging' | 'dev' | 'default'

// Parameters
@description('Deployment environment. Used to differentiate non-production export names and the managed identity that will be created.')
param environment environmentType

@description('The suffix for the cost export name. Also used in the export path. Examples could include environment such as prod, dev, etc.')
param costExportNameSuffix string

@description('The location of the managed identity used for the cost export.')
param location string

@description('The storage account name where the cost export will be delivered.')
param storageAccountName string

@description('The subscription ID that contains the storage account.')
param storageAccountSubscriptionId string

@description('The resource group name that contains the storage account.')
param storageAccountResourceGroupName string

@description('The name of the container in the storage account where the cost export will be delivered.')
param containerName string

@description('The focus dataset version to use. Defaults to "1.0r2".')
param focusDatasetVersion string = '1.0r2'

// Variables
var costExportNamePrefix = environment == 'production' ? 'cost-export' : '${environment}-cost-export'

// Existing resources
resource storageAccountResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: storageAccountResourceGroupName
  scope: subscription(storageAccountSubscriptionId)
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: storageAccountName
  scope: storageAccountResourceGroup
}

// Resources
resource MtdCostExport 'Microsoft.CostManagement/exports@2025-03-01' = {
  name: '${costExportNamePrefix}-mtd-${costExportNameSuffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    compressionMode: 'snappy'
    format: 'Parquet'
    dataOverwriteBehavior: 'OverwritePreviousReport'
    definition: {
      type: 'FocusCost'
      dataSet: {
        granularity: 'Daily'
        configuration: {
          dataVersion: focusDatasetVersion
        }
      }
      timeframe: 'MonthToDate'
    }
    deliveryInfo: {
      destination: {
        type: 'AzureBlob'
        resourceId: storageAccount.id
        container: containerName
        rootFolderPath: 'exports/mtd/${costExportNameSuffix}'
      }
    }
    partitionData: true
    schedule: {
      recurrence: 'Daily'
      recurrencePeriod: {
        from: '2024-01-01'
        to: '2050-12-31'
      }
      status: 'Active'
    }
  }
}

resource MonthlyCostExport 'Microsoft.CostManagement/exports@2025-03-01' = {
  name: '${costExportNamePrefix}-monthly-${costExportNameSuffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    compressionMode: 'snappy'
    format: 'Parquet'
    dataOverwriteBehavior: 'OverwritePreviousReport'
    definition: {
      type: 'FocusCost'
      dataSet: {
        granularity: 'Daily'
        configuration: {
          dataVersion: focusDatasetVersion
        }
      }
      timeframe: 'TheLastMonth'
    }
    deliveryInfo: {
      destination: {
        type: 'AzureBlob'
        resourceId: storageAccount.id
        container: containerName
        rootFolderPath: 'exports/monthly/${costExportNameSuffix}'
      }
    }
    partitionData: true
    schedule: {
      recurrence: 'Monthly'
      recurrencePeriod: {
        from: '2024-01-01'
        to: '2050-12-31'
      }
      status: 'Active'
    }
  }
}
