using 'main.bicep'

param environment = readEnvironmentVariable('AZ_ENVIRONMENT', 'default')
param location = readEnvironmentVariable('AZ_LOCATION', 'westeurope')
param storageAccountSku = 'Standard_LRS'
param costManagementScopes = [
//  {
//    subscriptionId: 'aa4cd3f4-9214-4a5c-b246-762072c8fa04'
//    costExportSuffix: 'dev'
//  }
  {
    subscriptionId: '62ce1c5b-da96-421c-bb37-6c8b3b722b74'
    costExportSuffix: 'test'
  }
//  {
//    subscriptionId: '92011101-7063-4491-9c31-0fe6e54b7515'
//    costExportSuffix: 'prod'
//  }
]
