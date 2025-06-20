targetScope = 'resourceGroup'

// Parameters
param location string = resourceGroup().location
param storageAccountSku string
param storageAdminPrincipalIDs string[]

// Variables
var storageAccountName string = 'azcostmgmt${take(uniqueString(subscription().id, resourceGroup().id), 6)}'
var storageBlobDataContributorRoleDefId string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

// Resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    isLocalUserEnabled: false
    isNfsV3Enabled: false
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    changeFeed: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: false
    }
    deleteRetentionPolicy: {
      enabled: false
      allowPermanentDelete: false
    }
    isVersioningEnabled: false
    restorePolicy: {
      enabled: false
    }
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  name: 'cost-exports'
  parent: blobService
  properties: {
    publicAccess: 'None'
    denyEncryptionScopeOverride: false
    defaultEncryptionScope: '$account-encryption-key'
  }
}

resource blobContributorRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for principalId in storageAdminPrincipalIDs: {
    name: guid(storageAccount.id, principalId, 'Blob Data Contributor')
    scope: storageAccount
    properties: {
      principalId: principalId
      principalType: 'User'
      roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleDefId)
    }
  }
]

output containerName string = container.name
output storageAccountName string = storageAccount.name
