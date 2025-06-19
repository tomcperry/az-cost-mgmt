using 'main.bicep'

param deploymentId = readEnvironmentVariable('DEPLOYMENT_ID', '')
param location = readEnvironmentVariable('AZ_LOCATION', 'westeurope')
param storageAccountSku = 'Standard_LRS'
