// create storage account 
using 'main.bicep'
type TagValues = {
  Environment                                           : 'DEV' | 'Test' | 'PREPROD' | 'PROD'
  Company                                               : string
}
type RoleValues = {
  id                                                    : string
  name                                                  : string
}

type serviceBusQueueProperties = {
  maxMessageSizeInKilobytes                             : int
  lockDuration                                          : string
  maxSizeInMegabytes                                    : int
  requiresDuplicateDetection                            : bool
  requiresSession                                       : bool
  defaultMessageTimeToLive                              : string
  deadLetteringOnMessageExpiration                      : bool
  enableBatchedOperations                               : bool
  duplicateDetectionHistoryTimeWindow                   : string
  maxDeliveryCount                                      : int
  status                                                : string
  autoDeleteOnIdle                                      : string
  enablePartitioning                                    : bool
  enableExpress                                         : bool
}

type serviceBusQueue = {
  queueName                                             : string
  properties                                            : serviceBusQueueProperties
}
/* ------------------ Values need to be Updated for Each Environment ------------------ */
var tags TagValues = {
  Company                                               : 'ECQ'
  Environment                                           : 'DEV'
}

var location                                            = 'australiaeast'
var containerAppSubscriptionId                          = 'fa7941a8-d614-416c-8bae-6e4a36930017' 
var containerAppResourcegroup                           = 'rg-ems-elector-ae-dev'
var containerAppEnvironment                             = 'caeelectordevae'
var containerAppName                                    = 'caelectordevae'

var monitoringSubscriptionId                            = 'fa7941a8-d614-416c-8bae-6e4a36930017' 
var monitoringResourceGroupName                         = 'rg-monitoring-ems-dev-ae'

var appInsightsName                                     = 'appiemscommondevae'

var storageAccountResourceGroup                         = containerAppResourcegroup
var storageAccountName                                  = 'stqemsdev'

var serviceBusNamespaceResourceGroupName                = 'rg-shared-ems-dev-ae'
var serviceBusNameSpace                                 = 'sbns-qems-electors-dev'

var appConfigurationResourceGroupName                   = 'rg-constructix-dev-ae-01'
var appConfigName                                       = 'apconfig-constructix-ae-dev-01'                 

var keyVaultResourceGroupName                           = 'rg-constructix-dev-ae-01'
var keyVaultName                                        = 'kvconstructixaedev02'

var managedIdentityName                                 = 'electorcontainerappidentity01'

var registryContainerName                               = 'creqemselectordev'
var repositoryName                                      = 'rpqemselectordev'




/* -----------------End of alues need to be Updated for Each Environment -------------- */

var registryContainerRole RoleValues = {
  id                                                    : '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  name                                                  : 'AcrPull'
}
var storageAccountBlobRole RoleValues = {
  id                                                    : 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  name                                                  : 'Storage Blob Data Contributor'
}

var storageAccountQueueRole RoleValues = {
  id                                                    : '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
  name                                                  : 'Storage Queue Data Contributor'
}

var storageAccountTableRole RoleValues = {
  id                                                    : '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'
  name                                                  : 'Storage Table Data Contributor'
}

var appConfigReaderRole RoleValues = {
  id                                                    : '516239f1-63e1-4d78-a4de-a74fb236a071'
  name                                                  : 'App Configuration Data Reader'
}

var serviceBusDataOwner RoleValues = {
  id                                                    : '090c5cfd-751d-490a-894a-3ce6f1109419'
  name                                                  : 'Azure Service Bus Data Owner'
}

var keyVaultSecretuserRole RoleValues = {
  id                                                    : '4633458b-17de-408a-b874-0445c86b69e6'
  name                                                  : 'Key Vault Secrets User'
}

param workspaceObject = {
  name                                                  : appInsightsName
  subscriptionId                                        : monitoringSubscriptionId
  resourceGroup                                         : monitoringResourceGroupName
  location                                              : appInsightsName
  sku                                                   : 'pergb2018'
  tags                                                  : tags
}
param appInsightsObject = {
  name                                                  : 'appiemscommondevae'
  subscriptionId                                        : monitoringSubscriptionId 
  resourceGroup                                         : monitoringResourceGroupName
  kind                                                  : 'web'
  region                                                : 'australiaeast'
  requestSource                                         : 'IbizaAIExtension'
  tags                                                  : tags
  ingestMode                                            : 'LogAnalytics'
}

param managedIdentityObject = {
  name                                                  : managedIdentityName
  resourceGroup                                         : containerAppResourcegroup
  location                                              : location
}

param registryContainerObject = {
  name                                                  : registryContainerName
  subscriptionId                                        : containerAppSubscriptionId
  repositoryName                                        : repositoryName
  resourceGroup                                         : containerAppResourcegroup
  location                                              : location
  tagValues                                             : tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  roles: [registryContainerRole]
}
param storageAccountObject = {
  name                                                  : storageAccountName
  resourceGroup                                         : storageAccountResourceGroup
  location                                              : location
  sku: {
    name                                                : 'Standard_GRS'
    tier                                                : 'Standard'
  }
  kind                                                  : 'StorageV2'
  roles                                                 : [storageAccountBlobRole, storageAccountQueueRole, storageAccountTableRole]
  tags                                                  : tags
}
param containerApp = {
  name                                                  : containerAppName
  resourceGroup                                         : containerAppResourcegroup
  location                                              : location
}
param containerAppsEnvironment = {
  name                                                  : 'caeelectordevae'
  resourceGroup                                         : containerAppResourcegroup
  location                                              : location
  tags                                                  : tags
}

param appConfigurationObject = {
  name                                                  : appConfigName
  subscriptionId                                        : containerAppSubscriptionId
  resourceGroup                                         : appConfigurationResourceGroupName
  roleDefinitionId                                      : appConfigReaderRole
  roles                                                 : [appConfigReaderRole]
}

var epollmarkoffsQueue serviceBusQueue = {
  queueName                                             : 'epollmarkoffs'
  properties: {
    maxMessageSizeInKilobytes                           : 256
    lockDuration                                        : 'PT1M'
    maxSizeInMegabytes                                  : 1024
    requiresDuplicateDetection                          : false
    requiresSession                                     : false
    defaultMessageTimeToLive                            : 'P14D'
    deadLetteringOnMessageExpiration                    : true
    enableBatchedOperations                             : true
    duplicateDetectionHistoryTimeWindow                 : 'PT10M'
    maxDeliveryCount                                    : 10
    status                                              : 'Active'
    autoDeleteOnIdle                                    : 'P10675199DT2H48M5.4775807S'
    enablePartitioning                                  : false
    enableExpress                                       : false
  }
}

var testqueue serviceBusQueue = {
  queueName                                             : 'testqueue'
  properties: {
    maxMessageSizeInKilobytes                           : 256
    lockDuration                                        : 'PT1M'
    maxSizeInMegabytes                                  : 1024
    requiresDuplicateDetection                          : false
    requiresSession                                     : false
    defaultMessageTimeToLive                            : 'P14D'
    deadLetteringOnMessageExpiration                    : true
    enableBatchedOperations                             : true
    duplicateDetectionHistoryTimeWindow                 : 'PT10M'
    maxDeliveryCount                                    : 10
    status                                              : 'Active'
    autoDeleteOnIdle                                    : 'P10675199DT2H48M5.4775807S'
    enablePartitioning                                  : false
    enableExpress                                       : false
  }
}

param serviceBusNamespaceObject = {
  name                                                  : serviceBusNameSpace
  subscriptionId                                        : containerAppSubscriptionId
  resourceGroup                                         : serviceBusNamespaceResourceGroupName
  location                                              : location
  enableDeadLetterQueue                                 : true
  sku: {
    name                                                : 'Standard'
    tier                                                : 'Standard'
  }
  queues                                                : [epollmarkoffsQueue, testqueue]
  roles                                                 : [serviceBusDataOwner]
}

param keyVaultObject = {
  name                                                  : keyVaultName
  subscriptionId                                        : containerAppSubscriptionId
  resourceGroup                                         : keyVaultResourceGroupName
  roles                                                 : [keyVaultSecretuserRole]
}
