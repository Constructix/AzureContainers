param latestImageTag string
param appInsightsObject object
param containerAppsEnvironment object
param managedIdentityObject object 
param containerApp object
param storageAccountObject object
param registryContainerObject object
param appConfigurationObject object

var repositoryName = '${registryContainerObject.name}.azurecr.io/${registryContainerObject.repositoryName}:${latestImageTag}'

output tagUsed string = latestImageTag
output RespositoryName string = repositoryName

resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' existing = {
  name                                                  : appInsightsObject.name
  scope                                                 : resourceGroup(appInsightsObject.resourceGroup)
}

resource dockerContainerAppEnvironmentModule 'Microsoft.App/managedEnvironments@2025-10-02-preview' existing = {
  name                                                  : containerAppsEnvironment.name
  scope                                                 : resourceGroup(containerAppsEnvironment.resourceGroup)
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name                                                  : storageAccountObject.name
  scope                                                 : resourceGroup(storageAccountObject.resourceGroup)
}
resource userAssignedManagedIdentityResource 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name                                                  : managedIdentityObject.name  
  scope                                                 : resourceGroup(managedIdentityObject.resourceGroup)
}

resource appConfigResource 'Microsoft.AppConfiguration/configurationStores@2025-08-01-preview' existing = {
    name                                                : appConfigurationObject.name
    scope                                               : resourceGroup(appConfigurationObject.resourceGroup)
}

resource containerAppResource 'Microsoft.App/containerApps@2025-10-02-preview' = {
  name: containerApp.name
  location                                              : resourceGroup().location
  kind                                                  : 'functionapp'
  identity: {
    type                                                : 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityResource.id}'       : {}
    }
  }
  properties: {
    managedEnvironmentId                                : dockerContainerAppEnvironmentModule.id
    environmentId                                       : dockerContainerAppEnvironmentModule.id
    workloadProfileName                                 : 'Consumption'
    configuration: {
      activeRevisionsMode                               : 'Single'
      ingress: {
        external                                        : true
        targetPort                                      : 80
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
              name                                      : 'FUNCTIONS_WORKER_RUNTIME'
              value                                     : 'dotnet-isolated'
            }
            {
              name                                      : 'AzureWebJobsStorage__accountName'
              value                                     : storageAccountObject.name
            }
            {
              name                                      : 'AzureWebJobsStorage__credential'
              value                                     : 'managedidentity'
            }
            {
              name                                      : 'AZURE_CLIENT_ID'
              value                                     :  userAssignedManagedIdentityResource.properties.clientId //userAssignedIdentityClientId
            }

            {
              name                                      : 'WEBSITE_SITE_NAME'
              value                                     : containerApp.name
            }
            {
              name                                      : 'WEBSITE_HOSTNAME'
              value                                     : containerApp.name
            }
            {
              name                                      : 'WEBSITE_INSTANCE_ID'
              value                                     : containerApp.name
            }
            {
              name                                      : 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value                                     : appInsightsResource.properties.ConnectionString
            }
            {
              name                                      : 'AzureWebJobsStorage__clientId' // only needed for user-assigned
              value                                     : userAssignedManagedIdentityResource.id
            }
            {
              name                                      : 'AzureWebJobsStorage__blobServiceUri'
              value                                     : storageAccountResource.properties.primaryEndpoints.blob
            }
            {
              name                                      : 'AzureWebJobsStorage__queueServiceUri'
              value                                     : storageAccountResource.properties.primaryEndpoints.queue
            }
            {
              name                                      : 'AzureWebJobsStorage__tableServiceUri'
              value                                     : storageAccountResource.properties.primaryEndpoints.table
            }
            {
              name                                      : 'AzureWebJobsStorage__fileServiceUri'
              value                                     : storageAccountResource.properties.primaryEndpoints.file
            }
            {
              name                                      : 'AppConfig'
              value                                     : appConfigResource.properties.endpoint
            }

          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
      scale: containerApp.scale
      // scale: {
      //   minReplicas: 1
      //   maxReplicas: 10
      //   cooldownPeriod: 300
      //   pollingInterval: 30
      // }
    }
  }
}
