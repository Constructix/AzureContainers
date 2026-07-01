
param principalId  string      
param serviceBusObject object 

resource svcBusNamespaceResource 'Microsoft.ServiceBus/namespaces@2025-05-01-preview' existing = {
    name                                                : serviceBusObject.name
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