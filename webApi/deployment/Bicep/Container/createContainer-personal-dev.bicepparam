// create storage account 
using 'CreateContainer-personal.bicep'

var resourceGroup                                       = 'rg-ems-elector-ae-dev'
var monitoringResourceGroupName                         = 'rg-monitoring-ems-dev-ae'
var appConfigurationResourceGroupName                   = 'rg-constructix-dev-ae-01'
var managedIdentityName                                 = 'electorcontainerappidentity01'
var registryContainerName                               = 'creqemselectordev'
var repositoryName                                      = 'rpqemselectordev'
param latestImageTag                                    = ''

param appInsightsObject = {
  name                                                  : 'appiemscommondevae' 
  resourceGroup                                         : monitoringResourceGroupName
}

param containerAppsEnvironment = {
  name                                                  : 'caeelectordevae'
  resourceGroup                                         : resourceGroup
}

param managedIdentityObject = {
  name                                                  : managedIdentityName
  resourceGroup                                         : resourceGroup
}

param containerApp = {
  name                                                  : 'caelectordevae'
  resourceGroup                                         : resourceGroup
  scale: {
	 minReplicas                                        : 1
     maxReplicas                                        : 10
     cooldownPeriod                                     : 300
     pollingInterval                                    : 30
  }
}


param registryContainerObject = {
  name                                                  : registryContainerName
  repositoryName                                        : repositoryName

}

param appConfigurationObject = {
  name                                                  : 'apconfig-constructix-ae-dev-01'
  resourceGroup                                         : appConfigurationResourceGroupName 
}

