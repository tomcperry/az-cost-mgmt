using 'main.bicep'

param deploymentId = readEnvironmentVariable('DEPLOYMENT_ID', '')
param location = readEnvironmentVariable('AZ_LOCATION', 'westeurope')
param environment = readEnvironmentVariable('AZ_ENVIRONMENT', 'default')
param storageAccountName = readEnvironmentVariable('AZ_STORAGE_ACCOUNT_NAME', '')
param storageAccountSubscriptionId = readEnvironmentVariable('AZ_STORAGE_ACCOUNT_SUBSCRIPTION_ID', '')
param storageAccountResourceGroupName = readEnvironmentVariable('AZ_STORAGE_ACCOUNT_RESOURCE_GROUP_NAME', '')
param containerName = readEnvironmentVariable('AZ_CONTAINER_NAME', 'cost-export')

param costManagementScopes = [
  {
    costExportSuffix: 'dev'
    subscriptionId: 'aa4cd3f4-9214-4a5c-b246-762072c8fa04'
  }
  {
    costExportSuffix: 'test'
    subscriptionId: '62ce1c5b-da96-421c-bb37-6c8b3b722b74'
  }
  {
    costExportSuffix: 'prod'
    subscriptionId: '92011101-7063-4491-9c31-0fe6e54b7515'
  }
]
