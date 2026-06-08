// create storage account 
using 'main.bicep'

var location                                 = 'australiaeast'
var resourceGroup                            = 'rg-constructix-dev-ae-02'
var appConfigResourceGroup                   = 'rg-constructix-dev-ae-01'
var managedIdentityName                      = 'constructixcontainerappidentity01'

var registryContainerName                    = 'constructixdockerregistry'
var repositoryName                           = 'constructixonlineservicesfunctions'
var functionAppName                          = 'constructixonlineservices'
param assignRoleToAppConfig                  = false
param latestImageTag                         = ''

param workspaceObject = {
  name: 'wkspaceconstructixdockerdevae01'
  location: 'AustraliaEast'
  sku: 'pergb2018'
  tags: {
    Company: 'Constructix'
    Environment: 'dev'
    Purpose: 'Creating an application insights resource for container app environment'
  }
}
param appInsightsObject = {
  name: 'constructixdockerdevae01'
  type: 'web'
  region: 'australiaeast'
  requestSource: 'IbizaAIExtension'
  tags: {
    Company: 'Constructix'
    Environment: 'dev'
    Purpose: 'Creating an application insights resource for container app environment'
  }
}

param managedIdentityObject = {
  name: managedIdentityName
  resourceGroup: resourceGroup
  location: location
}

param registryContainerObject = {
  name                                      : registryContainerName
  repositoryName                            : repositoryName
  resourceGroup                             : resourceGroup
  location                                  : location
  tagValues: {
    Environment                             : 'dev'
    Company                                 : 'Constructix'
    Purpse                                  : 'Container registry for Constructix docker images'
  }
  sku: {
    name                                    : 'Basic'
    tier                                    : 'Basic'
  }
}
param storageAccountObject = {
  name: 'staazurefunc01'
  location: location
  sku: {
    name: 'Standard_GRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  roles: [
    {
      id: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
      name: 'Storage Blob Data Contributor'
    }
    {
      id: '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
      name: 'Storage Queue Data Contributor'
    }
    {
      id: '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'
      name: 'Storage Table Data Contributor'
    }
  ]
}
param containerApp = {
  name: functionAppName
  resourceGroup: resourceGroup
  location: location
}
param containerAppsEnvironment = {
  name: 'funcappenvv1'
  location: location
  tags: {
    Company: 'Constructix'
    Environment: 'dev'
    Purpose: 'Creating a container app environment'
  }
}

param appConfigurationObject = {
  name: 'apconfig-constructix-ae-dev-01'
  resourceGroup: appConfigResourceGroup
  roleDefinitionId: '516239f1-63e1-4d78-a4de-a74fb236a071'
  roles: [
    {
      id: '516239f1-63e1-4d78-a4de-a74fb236a071'
      name: 'App Configuration Data Reader'
    }
  ]
}

param serviceBusObject = {
    name: 'constructix-orders-ae-dev'
    location: location
     sku: {
                name: 'Standard'
                tier: 'Standard'
        }
    queues: ['neworders']
    roles: [
    {
      id: '090c5cfd-751d-490a-894a-3ce6f1109419'
      name: 'Azure Service Bus Data Owner'
    }
    
  ]
}
