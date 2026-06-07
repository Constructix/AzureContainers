// create storage account 
using 'CreateContainer.bicep'

param latestImageTag                         = ''


param appInsightsObject = {
  name: 'constructixdockerdevae01' 
}

param managedIdentityObject = {
  name: 'constructixcontainerappidentity01'
}

param registryContainerObject = {
  name                                      : 'constructixdockerregistry'
  repositoryName                            : 'constructixonlineservicesfunctions'
}
param storageAccountObject = {
  name: 'staazurefunc01' 
}
param containerApp = {
  name: 'constructixonlineservices'


}
param containerAppsEnvironment = {
  name: 'funcappenvv1' 
}
param appConfigurationObject = {
  name: 'apconfig-constructix-ae-dev-01'
  resourceGroup: 'rg-constructix-dev-ae-01'  
}

