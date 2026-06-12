// create storage account 
using 'CreateContainer.bicep'

var managedIdentityName                                 = 'electorcontainerappidentity01'
param latestImageTag                                    = ''

param appInsightsObject = {
  name                                                  : 'appiemscommondevae' 
  resourceGroup                                         : 'rg-monitoring-ems-dev-ae'
}

param containerAppsEnvironment = {
  name                                                  : 'caeelectordevae'
  resourceGroup                                         : 'rg-ems-elector-ae-dev'
}

param managedIdentityObject = {
  name                                                  : managedIdentityName
  resourceGroup                                         : 'rg-ems-elector-ae-dev'
}

param containerApp = {
  name                                                  : 'caelectordevae'
  resourceGroup                                         : 'rg-ems-elector-ae-dev'
  scale: {
	 minReplicas                                        : 1
     maxReplicas                                        : 10
     cooldownPeriod                                     : 300
     pollingInterval                                    : 30
  }
}

param storageAccountObject = {
  name                                                  : 'stelectoraedev' 
  resourceGroup                                         : 'rg-ems-elector-ae-dev'
}
param registryContainerObject = {
  name                                                  : 'crelectordevae'
  repositoryName                                        : 'electorservicesrepository'

}

param appConfigurationObject = {
  name                                                  : 'apconfig-constructix-ae-dev-01'
  resourceGroup                                         : 'rg-constructix-dev-ae-01'  
}

