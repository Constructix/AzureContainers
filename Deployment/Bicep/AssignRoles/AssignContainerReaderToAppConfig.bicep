param appConfigurationObject object
param principalId string
param identityResourceId string

resource appConfigurationResource 'Microsoft.AppConfiguration/configurationStores@2024-06-01' existing = {
  name: appConfigurationObject.name
}

resource assignAppConfigRoles 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in appConfigurationObject.roles: {
    name: guid(appConfigurationResource.id, identityResourceId, role.name)
    scope: appConfigurationResource
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.id)
      principalId: principalId
      principalType: 'ServicePrincipal'
    }
  }
]
