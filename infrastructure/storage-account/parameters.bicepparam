using 'main.bicep'

param location = readEnvironmentVariable('AZ_LOCATION', 'westeurope')
param storageAccountSku = 'Standard_LRS'
