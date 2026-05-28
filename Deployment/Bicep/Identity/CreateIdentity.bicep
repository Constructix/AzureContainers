param managedIdentityObject object
param containerApp object

// 1. Create user-assigned identity first
resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityObject.name
  location: containerApp.location
}

output principalId string = uami.properties.principalId
output resourceId string = uami.id
output clientId string = uami.properties.clientId
