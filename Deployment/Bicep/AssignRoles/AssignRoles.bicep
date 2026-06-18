param registryContainerObject object
param storageAccountObject object

param principalId string
param identityResourceId string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01' existing = {
  name                                                  : registryContainerObject.name 
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name                                                  : storageAccountObject.name
}

resource assignRolesToStorageAccount 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in storageAccountObject.roles: {
    name: guid(storageAccountResource.id, principalId, role.name)
    scope: storageAccountResource
    properties: {
      roleDefinitionId                                  : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.id)
      principalId                                       : principalId
      principalType                                     : 'ServicePrincipal'
    }
  }  
]

resource assignRolesToRegistryContainer 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in registryContainerObject.roles: {
    name: guid(acr.id, principalId, role.name)
    scope: acr
    properties: {
      roleDefinitionId                                  : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.id)
      principalId                                       : principalId
      principalType                                     : 'ServicePrincipal'
    }
  }  
]