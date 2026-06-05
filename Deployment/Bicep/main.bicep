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

output storageAccountName string        = storageAccountObject.name
output containerAppName string          = containerApp.name
output workspaceName string             = workspaceObject.name

module createAppInsightsModule 'AppInsights/createAppInsights.bicep' = {
  name: 'createAppInsightsModule'
  params: {
    workspaceObject: workspaceObject
    appInsightsObject: appInsightsObject
  }
}

/* ------- Create Log Analytics -------- */
module logAnalyticsModule 'LogAnalytics/CreateLogAnalytics.bicep' = {
  name: 'logAnalyticsModule'
  params: {
    workspaceObject: workspaceObject
  }
  dependsOn: [createAppInsightsModule]
}
output logAnalyticsCustomerId string = logAnalyticsModule.outputs.customerId
output logAnalyticsSharedKey string = logAnalyticsModule.outputs.sharedKey
/* -------- End Create Log Analytics -------- */

// this should be in a seperate task, after the build then check if the registry exists, 
// if not then create it, if it does then skip to pushing the image to the registry. 
// This is because we dont want to have to build the image every time we want to deploy, 
// only when there are changes to the dockerfile or codebase that should trigger a new image build 
// and push to the registry. If we have the registry creation in the same bicep file as the container app, 
// then it will try to create the registry every time we deploy, which will cause issues 
// if the registry already exists. By separating the registry creation into its own bicep file and deployment task, 
// we can ensure that the registry is only created when it doesn't already exist, and we can also handle any errors that may occur during registry creation more gracefully.
/*  ------- Create Registry  ------------------------*/
module registryContainerModule 'ContainerRegistry/CreateRegistry.bicep' = {
  name: 'registryContainerModule'
  params: {
    registryContainerObject: registryContainerObject
  }
}

/* CREATE SERVICE BUS */
module createServiceBusNamespaceAndQueuesModule 'ServiceBus/CreateServiceBusNamespaceAndQueues.bicep' ={
    name: 'createServiceBusAndQueues'
    params: {
        ServicebusObject                    : serviceBusObject
    }
dependsOn:[registryContainerModule]
}


/* -------- Create Storage Account -------- */
module storageAccountModule 'StorageAccount/CreateStorageAccount.bicep' = {
  name                                      : 'storageAccountModule'
  params: {
    storageAccountObject                    : storageAccountObject
  }
  dependsOn:[createServiceBusNamespaceAndQueuesModule]
}
// identity module should be deployed before the container app, because we need the principalId of the identity to assign roles to it, and the role assignment needs to be done before the container app can pull images from the registry or access the storage account. By deploying the identity module first, we can ensure that the necessary permissions are in place for the container app to function correctly when it is deployed.
module identityModule 'Identity/CreateIdentity.bicep' = {
  name                                      : 'identityModule'
  params: {
    managedIdentityObject                   : managedIdentityObject
    containerApp                            : containerApp
  } 
}


module createDockerContainerEnvionmentModule 'DockerEnvironment/CreateManagedEnvironment.bicep' = {
  name: 'createDockerContainerEnvionmentModule'
  params: {
    containerAppsEnvironment                : containerAppsEnvironment
    logAnalyticsCustomerId                  : logAnalyticsModule.outputs.customerId // ← wire in
    logAnalyticsSharedKey                   : logAnalyticsModule.outputs.sharedKey // ← wire in
  }
  dependsOn:[assignRolesModule,registryContainerModule]
}

module containerAppModule 'Container/CreateContainer.bicep' = {
  name: 'containerAppModule'
  params: {
    userAssignedIdentityClientId            : identityModule.outputs.clientId
    uamiResourceId                          : identityModule.outputs.resourceId
    containerApp                            : containerApp
    storageAccountObject                    : storageAccountObject
    registryContainerObject                 : registryContainerObject
    appConfigObject                         : appConfigurationObject
    containerAppsEnvironment                : containerAppsEnvironment
    appInsightsObject                       : appInsightsObject
    latestImageTag                          : latestImageTag
  }
  dependsOn: [createDockerContainerEnvionmentModule, assignRolesModule, createAppInsightsModule, identityModule ]
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
  dependsOn: [containerAppModule, assignRolesModule]
}
