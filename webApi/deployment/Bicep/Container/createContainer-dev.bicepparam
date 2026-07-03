// create storage account 
using 'CreateContainer.bicep'

var resourceGroup                                       = 'rg-qems-dev-conn-sandbox'
var monitoringResourceGroupName                         = 'rg-qems-dev-monitor'
var appConfigurationResourceGroupName                   = 'rg-qems-hub-ae-sandbox'
var managedIdentityName                                 = 'electorcontainerappidentity01'
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
  name                                                  : 'crelectordevae'
  repositoryName                                        : 'electorservicesrepository'

}

param appConfigurationObject = {
  name                                                  : 'apconfig-constructix-ae-dev-01'
  resourceGroup                                         : appConfigurationResourceGroupName 
}

