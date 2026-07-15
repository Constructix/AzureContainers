param latestImageTag string
param appInsightsObject object
param containerAppsEnvironment object
param managedIdentityObject object
param containerApp object

param registryContainerObject object
param appConfigurationObject object

var repositoryName                                      = '${registryContainerObject.name}.azurecr.io/${registryContainerObject.repositoryName}:${latestImageTag}'

output tagUsed string                                   = latestImageTag
output RespositoryName string                           = repositoryName

resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' existing = {
  name                                                  : appInsightsObject.name
  scope                                                 : resourceGroup(appInsightsObject.resourceGroup)
}

resource dockerContainerAppEnvironmentModule 'Microsoft.App/managedEnvironments@2025-10-02-preview' existing = {
  name                                                  : containerAppsEnvironment.name
  scope                                                 : resourceGroup(containerAppsEnvironment.resourceGroup)
}


resource userAssignedManagedIdentityResource 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name                                                  : managedIdentityObject.name
  scope                                                 : resourceGroup(managedIdentityObject.resourceGroup)
}

resource appConfigResource 'Microsoft.AppConfiguration/configurationStores@2025-08-01-preview' existing = {
  name                                                  : appConfigurationObject.name
  scope                                                   : resourceGroup(appConfigurationObject.resourceGroup)
}

resource containerAppResource 'Microsoft.App/containerApps@2025-10-02-preview' = {
  name                                                  : containerApp.name
  location                                              : resourceGroup().location
  // If deploying a function app need to add kind = functionapp
  //kind                                                  : 'functionapp'
  identity: {
    type                                                : 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityResource.id}': {}
    }
  }
  properties: {
    managedEnvironmentId                                : dockerContainerAppEnvironmentModule.id
    environmentId                                       : dockerContainerAppEnvironmentModule.id
    workloadProfileName                                 : 'Consumption'
    configuration: {
      activeRevisionsMode                               : 'Multiple'
      ingress: {
        external                                        : true
        targetPort                                      : 8080
        exposedPort                                     : 0
        transport                                       : 'Auto'
        traffic: [
          {
            weight                                      : 100
            latestRevision                              : true
          }
        ]
        allowInsecure                                   : false
      }
      registries: [
        {
          server                                        : '${registryContainerObject.name}.azurecr.io'
          identity                                      : userAssignedManagedIdentityResource.id //'system'
        }
      ]
      identitySettings: []
    }
    template: {
      containers: [
        {
          image                                         : repositoryName
          imageType                                     : 'ContainerImage'
          name                                          : containerApp.name
          env: [
            
            {
              name                                      : 'AZURE_CLIENT_ID'
              value                                     : userAssignedManagedIdentityResource.properties.clientId //userAssignedIdentityClientId
            }            
            {
                name                                    : 'ASPNETCORE_ENVIRONMENT'
                value                                   : 'Production'  // or per-environment via bicepparam
            }
            {
                name                                    : 'ASPNETCORE_URLS'
                value                                   : 'http://+:8080'  // must match Dockerfile EXPOSE + Container App ingress targetPort
            }
          
            {
              name                                      : 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value                                     : appInsightsResource.properties.ConnectionString
            }
           
            {
              name                                      : 'AppConfig'
              value                                     : appConfigResource.properties.endpoint
            }
           
            {
                name                                    : 'DOTNET_RUNNING_IN_CONTAINER'
                value                                   : 'true'
            }
           
          ]
          resources: {
            cpu                                         : json('0.5')
            memory                                      : '1Gi'
          }
        }
      ]
      scale                                             : containerApp.scale      
    }
  }
}

output containerAppId string                            = containerAppResource.id
output containerAppIdentity object                      = containerAppResource.identity
output containerAppPrincipalId string                   = userAssignedManagedIdentityResource.properties.principalId

// Bonus helpful outputs
output containerAppClientId string                      = userAssignedManagedIdentityResource.properties.clientId
output containerAppName string                          = containerAppResource.name