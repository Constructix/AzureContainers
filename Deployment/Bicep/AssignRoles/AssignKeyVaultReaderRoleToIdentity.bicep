param keyVaultObject object
param principalId string


resource keyVaultResource 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name                                                  : keyVaultObject.name
}

resource assignAppConfigRoles 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in keyVaultObject.roles: {
    name                                                : guid(keyVaultResource.id, principalId, role.name)
    scope                                               : keyVaultResource
    properties: {
      roleDefinitionId                                  : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.id)
      principalId                                       : principalId
      principalType                                     : 'ServicePrincipal'
    }
  }
]
