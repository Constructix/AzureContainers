param registryContainerObject object
param storageAccountObject object
param serviceBusObject object
param principalId string
param identityResourceId string
//ACR (EXISTING) //
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01' existing = {
  name: registryContainerObject.name
}
// STORAGE ACCOUNT (EXISTING)//
resource storageAccountResource 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name: storageAccountObject.name
}

resource svcBusNamespaceResource 'Microsoft.ServiceBus/namespaces@2025-05-01-preview' existing = {
    name: serviceBusObject.name
}


resource assignRolesToStorageAccount 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in storageAccountObject.roles: {
    name: guid(storageAccountResource.id, principalId, role.name)
    scope: storageAccountResource
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.id)
      principalId: principalId
      principalType: 'ServicePrincipal'
    }
  }  
]

//
// ROLE ASSIGNMENT — GIVE THE CONTAINER APP IDENTITY ACR PULL PERMISSION
//
resource acrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, principalId, 'AcrPull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
    )
    principalId                                         : principalId
    principalType                                       : 'ServicePrincipal'
  }
 
}

resource serviceBusAssignmentRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [ 
    for role in serviceBusObject.roles : {
        name: guid(svcBusNamespaceResource.id, principalId, role.name)
        scope:svcBusNamespaceResource
        properties: {
            roleDefinitionId                            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.id)
            principalId                                 : principalId
            principalType                               : 'ServicePrincipal'
        }
    }    
]