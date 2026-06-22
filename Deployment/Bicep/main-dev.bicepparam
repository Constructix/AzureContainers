// create storage account 
using 'main.bicep'
type TagValues = {
    Environment                              : 'DEV'|'Test'|'PREPROD'|'PROD'
    Company                                  : string
}
type RoleValues = {
    id                                       : string
    name                                     : string
}

type serviceBusQueueProperties ={
    maxMessageSizeInKilobytes                : int
    lockDuration                             : string
    maxSizeInMegabytes                       : int
    requiresDuplicateDetection               : bool                   
    requiresSession                          : bool                     
    defaultMessageTimeToLive                 : string                       
    deadLetteringOnMessageExpiration         : bool
    enableBatchedOperations                  : bool
    duplicateDetectionHistoryTimeWindow      : string
    maxDeliveryCount                         : int
    status                                   : string
    autoDeleteOnIdle                         : string
    enablePartitioning                       : bool
    enableExpress                            : bool                            
}

type serviceBusQueue ={
    queueName                               : string
    properties                              : serviceBusQueueProperties
}

var location                                 = 'australiaeast'
var resourceGroup                            = 'rg-ems-elector-ae-dev'

var managedIdentityName                      = 'electorcontainerappidentity01'

var registryContainerName                    = 'crelectordevae'
var repositoryName                           = 'electorservicesrepository'
var tags TagValues = {
     Company                                 : 'ECQ'
     Environment                             : 'DEV'
}
var functionAppName                          = 'caelectordevae'


var registryContainerRole RoleValues        = { 
    id                                      : '7f951dda-4ed3-4680-a7ca-43fe172d538d'
    name                                    : 'AcrPull'
}
var storageAccountBlobRole RoleValues       =  {
    id                                      : 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    name                                    : 'Storage Blob Data Contributor'           
}

var storageAccountQueueRole RoleValues       =  {
    id                                      : '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
    name                                    : 'Storage Queue Data Contributor'          
}

var storageAccountTableRole RoleValues       =  {
    id                                      : '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'
    name                                    : 'Storage Table Data Contributor'          
}

var appConfigReaderRole RoleValues          = {
    id                                      : '516239f1-63e1-4d78-a4de-a74fb236a071'   
    name                                    : 'App Configuration Data Reader'
}

var serviceBusDataOwner RoleValues          = {
    id                                      : '090c5cfd-751d-490a-894a-3ce6f1109419'
    name                                    : 'Azure Service Bus Data Owner'
}

var keyVaultSecretuserRole RoleValues       = {         
     id                                     : '4633458b-17de-408a-b874-0445c86b69e6'
     name                                   : 'Key Vault Secrets User'
}



param workspaceObject = {
  name                                      : 'logemscommondevae'
  resourceGroup                             : 'rg-monitoring-ems-dev-ae'
  location                                  : 'AustraliaEast'
  sku                                       : 'pergb2018'
  tags                                      : tags
}
param appInsightsObject = {
  name                                      : 'appiemscommondevae'
  resourceGroup                             : 'rg-monitoring-ems-dev-ae'  
  kind                                      : 'web'
  region                                    : 'australiaeast'
  requestSource                             : 'IbizaAIExtension'
  tags                                      : tags
  ingestMode                                : 'LogAnalytics'
}

param managedIdentityObject = {
  name                                      : managedIdentityName
  resourceGroup                             : resourceGroup
  location                                  : location
}


param registryContainerObject = {
  name                                      : registryContainerName
  repositoryName                            : repositoryName
  resourceGroup                             : resourceGroup
  location                                  : location
  tagValues                                 : tags
  sku: {
    name                                    : 'Basic'
    tier                                    : 'Basic'
  }
  roles                                     : [ registryContainerRole]     
}
param storageAccountObject = {
  name                                      : 'stelectoraedev'
  resourceGroup                             : 'rg-ems-elector-ae-dev'
  location                                  : location
  sku: {
    name                                    : 'Standard_GRS'
    tier                                    : 'Standard'
  }
  kind                                      : 'StorageV2'
  roles                                     : [ storageAccountBlobRole, storageAccountQueueRole, storageAccountTableRole]  
  tags                                      : tags
}
param containerApp = {
  name                                      : functionAppName
  resourceGroup                             : 'rg-ems-elector-ae-dev'
  location: location
}
param containerAppsEnvironment = {
  name                                      : 'caeelectordevae'
  resourceGroup                             : 'rg-ems-elector-ae-dev'
  location                                  : location
  tags                                      : tags
}

param appConfigurationObject = {
  name                                      : 'apconfig-constructix-ae-dev-01'
  resourceGroup                             : 'rg-constructix-dev-ae-01'
  roleDefinitionId                          : '516239f1-63e1-4d78-a4de-a74fb236a071'
  roles                                     : [ appConfigReaderRole]
}


var epollmarkoffsQueue  serviceBusQueue ={
    queueName                               : 'epollmarkoffs'
    properties: {
        maxMessageSizeInKilobytes           : 256
        lockDuration                        : 'PT1M'
        maxSizeInMegabytes                  : 1024
        requiresDuplicateDetection          : false
        requiresSession                     : false
        defaultMessageTimeToLive            : 'P14D'
        deadLetteringOnMessageExpiration    : true
        enableBatchedOperations             : true
        duplicateDetectionHistoryTimeWindow : 'PT10M'
        maxDeliveryCount                    : 10
        status                              : 'Active'
        autoDeleteOnIdle                    : 'P10675199DT2H48M5.4775807S'
        enablePartitioning                  : false
        enableExpress                       : false
}
}

var testqueue  serviceBusQueue ={
    queueName                               : 'testqueue'
    properties: {
        maxMessageSizeInKilobytes           : 256
        lockDuration                        : 'PT1M'
        maxSizeInMegabytes                  : 1024
        requiresDuplicateDetection          : false
        requiresSession                     : false
        defaultMessageTimeToLive            : 'P14D'
        deadLetteringOnMessageExpiration    : true
        enableBatchedOperations             : true
        duplicateDetectionHistoryTimeWindow : 'PT10M'
        maxDeliveryCount                    : 10
        status                              : 'Active'
        autoDeleteOnIdle                    : 'P10675199DT2H48M5.4775807S'
        enablePartitioning                  : false
        enableExpress                       : false
}
}

param serviceBusNamespaceObject = {
    name                                    : 'sbns-selectors-ae-dev'
    resourceGroup                           : 'rg-shared-ems-dev-ae'
    location                                : location
    enableDeadLetterQueue                   : true
    sku: {
            name                            : 'Standard'
            tier                            : 'Standard'
        }
    queues                                  : [epollmarkoffsQueue, testqueue]
    roles                                   : [serviceBusDataOwner]
}

param keyVaultObject = {
    name                                    : 'kvconstructixaedev02'
    resourceGroup                           : 'rg-constructix-dev-ae-01'
    roles                                   : [ keyVaultSecretuserRole ]
}
