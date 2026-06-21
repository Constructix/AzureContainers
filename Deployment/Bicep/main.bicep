// main.bicep

param workspaceObject object
param appInsightsObject object
param managedIdentityObject object
param registryContainerObject object
param storageAccountObject object

param containerApp object
param containerAppsEnvironment object
param appConfigurationObject object
param serviceBusNamespaceObject object
param keyVaultObject object 
output storageAccountName string                        = storageAccountObject.name
output containerAppName string                          = containerApp.name
output workspaceName string                             = workspaceObject.name

module createAppInsightsModule 'AppInsights/createAppInsights.bicep' = {
  name                                                  : 'createAppInsightsModule'
  scope                                                 : resourceGroup(appInsightsObject.resourceGroup)
  params: {
    workspaceObject                                     : workspaceObject
    appInsightsObject                                   : appInsightsObject
  }
}

module logAnalyticsModule 'LogAnalytics/CreateLogAnalytics.bicep' = {
  name                                                  : 'logAnalyticsModule'
  scope                                                 : resourceGroup(workspaceObject.resourceGroup)
  params: {
    workspaceObject                                     : workspaceObject
  }
  dependsOn: [createAppInsightsModule]
}
output logAnalyticsCustomerId string                    = logAnalyticsModule.outputs.customerId
//output logAnalyticsSharedKey string                     = logAnalyticsModule.outputs.sharedKey

module registryContainerModule 'ContainerRegistry/CreateRegistry.bicep' = {
  name                                                  : 'registryContainerModule'
  scope                                                 : resourceGroup(registryContainerObject.resourceGroup)
  params: {
    registryContainerObject                             : registryContainerObject
  }
}


module createServiceBusNamespaceAndQueuesModule 'ServiceBus/CreateServiceBusNamespaceAndQueues.bicep' ={
    name                                                : 'createServiceBusAndQueues'
    scope                                               : resourceGroup(serviceBusNamespaceObject.resourceGroup)
    params: {
        serviceBusNamespaceObject                       : serviceBusNamespaceObject
    }

}



module storageAccountModule 'StorageAccount/CreateStorageAccount.bicep' = {
  name                                                  : 'storageAccountModule'
  scope                                                 : resourceGroup(storageAccountObject.resourceGroup)
  params: {
    storageAccountObject                                : storageAccountObject
  }
  dependsOn:[createServiceBusNamespaceAndQueuesModule]
}

module identityModule 'Identity/CreateIdentity.bicep' = {
  name                                                  : 'identityModule'
  scope                                                 : resourceGroup(managedIdentityObject.resourceGroup)
  params: {
    managedIdentityObject                               : managedIdentityObject
    containerApp                                        : containerApp
  } 
}

resource logAnalyticsResource 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = {
  name: workspaceObject.name
}

module createDockerContainerEnvionmentModule 'DockerEnvironment/CreateManagedEnvironment.bicep' = {
  name                                                  : 'createDockerContainerEnvionmentModule'
  scope                                                 : resourceGroup(containerAppsEnvironment.resourceGroup)
  params: {
    containerAppsEnvironment                            : containerAppsEnvironment
    logAnalyticsCustomerId                              : logAnalyticsModule.outputs.customerId // ← wire in
    logAnalyticsSharedKey                               : logAnalyticsResource.listkeys().properties.primarySharedKey //logAnalyticsModule.outputs.sharedKey // ← wire in
  }
  dependsOn:[assignRolesModule]
}



module assignRolesModule 'AssignRoles/AssignRoles.bicep' = {
  name                                                  : 'assignRolesModule'
  scope                                                 : resourceGroup()
  params: {
    registryContainerObject                             : registryContainerObject
    storageAccountObject                                : storageAccountObject    
    principalId                                         : identityModule.outputs.principalId    
  }
  dependsOn: [
    storageAccountModule, identityModule, createServiceBusNamespaceAndQueuesModule
  ]
}

module assignServiceBusRoleModule 'AssignRoles/AssignServiceBusDataOwnerTo.bicep' = {
    name                                                : 'AssignServiceBusRoles'
    scope                                               : resourceGroup(serviceBusNamespaceObject.resourceGroup)
    params : {
        serviceBusObject                                : serviceBusNamespaceObject
        principalId                                     : identityModule.outputs.principalId        
    }
}



module appConfigurationModule 'AssignRoles/AssignContainerReaderToAppConfig.bicep' = {
  name                                                  : 'appConfigurationModule'
  scope                                                 : resourceGroup(appConfigurationObject.resourceGroup)
  params: {
    appConfigurationObject                              : appConfigurationObject
    principalId                                         : identityModule.outputs.principalId
    
  }
  dependsOn: [ assignRolesModule]
}

module keyVaultModule  'AssignRoles/AssignKeyVaultReaderRoleToIdentity.bicep' ={
    name                                                : 'AssignIdentityToKeyVaultModule'
    scope                                               : resourceGroup(keyVaultObject.resourceGroup)
    params: {
        keyVaultObject                                  : keyVaultObject
        principalId                                     : identityModule.outputs.principalId
    }
}


