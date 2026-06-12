// main.bicep
param assignRoleToAppConfig bool = false
param latestImageTag string
param workspaceObject object
param appInsightsObject object
param managedIdentityObject object
param registryContainerObject object
param storageAccountObject object

param containerApp object
param containerAppsEnvironment object
param appConfigurationObject object
param serviceBusObject object

output storageAccountName string            = storageAccountObject.name
output containerAppName string              = containerApp.name
output workspaceName string                 = workspaceObject.name

module createAppInsightsModule 'AppInsights/createAppInsights.bicep' = {
  name                                      : 'createAppInsightsModule'
  scope                                     : resourceGroup(appInsightsObject.resourceGroup)
  params: {
    workspaceObject                         : workspaceObject
    appInsightsObject                       : appInsightsObject
  }
}

/* ------- Create Log Analytics -------- */
module logAnalyticsModule 'LogAnalytics/CreateLogAnalytics.bicep' = {
  name                                      : 'logAnalyticsModule'
  scope                                     : resourceGroup(workspaceObject.resourceGroup)
  params: {
    workspaceObject                         : workspaceObject
  }
  dependsOn: [createAppInsightsModule]
}
output logAnalyticsCustomerId string        = logAnalyticsModule.outputs.customerId
output logAnalyticsSharedKey string         = logAnalyticsModule.outputs.sharedKey

module registryContainerModule 'ContainerRegistry/CreateRegistry.bicep' = {
  name                                      : 'registryContainerModule'
  scope                                     : resourceGroup(registryContainerObject.resourceGroup)
  params: {
    registryContainerObject                 : registryContainerObject
  }
}


module createServiceBusNamespaceAndQueuesModule 'ServiceBus/CreateServiceBusNamespaceAndQueues.bicep' ={
    name                                    : 'createServiceBusAndQueues'
    scope                                   : resourceGroup(serviceBusObject.resourceGroup)
    params: {
        ServicebusObject                    : serviceBusObject
    }

}


/* -------- Create Storage Account -------- */
module storageAccountModule 'StorageAccount/CreateStorageAccount.bicep' = {
  name                                      : 'storageAccountModule'
  scope                                     : resourceGroup(storageAccountObject.resourceGroup)
  params: {
    storageAccountObject                    : storageAccountObject
  }
  dependsOn:[createServiceBusNamespaceAndQueuesModule]
}

module identityModule 'Identity/CreateIdentity.bicep' = {
  name                                      : 'identityModule'
  params: {
    managedIdentityObject                   : managedIdentityObject
    containerApp                            : containerApp
  } 
}


module createDockerContainerEnvionmentModule 'DockerEnvironment/CreateManagedEnvironment.bicep' = {
  name                                      : 'createDockerContainerEnvionmentModule'
  scope                                     : resourceGroup(containerAppsEnvironment.resourceGroup)
  params: {
    containerAppsEnvironment                : containerAppsEnvironment
    logAnalyticsCustomerId                  : logAnalyticsModule.outputs.customerId // ← wire in
    logAnalyticsSharedKey                   : logAnalyticsModule.outputs.sharedKey // ← wire in
  }
  dependsOn:[assignRolesModule]
}



module assignRolesModule 'AssignRoles/AssignRoles.bicep' = if (assignRoleToAppConfig) {
  name                                      : 'assignRolesModule'
  params: {
    registryContainerObject                 : registryContainerObject
    storageAccountObject                    : storageAccountObject
    serviceBusObject                        : serviceBusObject
    principalId                             : identityModule.outputs.principalId
    identityResourceId                      : identityModule.outputs.resourceId
  }
  dependsOn: [
    storageAccountModule, identityModule
  ]
}

module appConfigurationModule 'AssignRoles/AssignContainerReaderToAppConfig.bicep' = if (assignRoleToAppConfig) {
  name                                      : 'appConfigurationModule'
  scope                                     : resourceGroup(appConfigurationObject.resourceGroup)
  params: {
    appConfigurationObject                  : appConfigurationObject
    principalId                             : identityModule.outputs.principalId
    identityResourceId                      : identityModule.outputs.resourceId
  }
  dependsOn: [ assignRolesModule]
}
