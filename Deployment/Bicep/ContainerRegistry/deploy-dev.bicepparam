using 'deploy-dev.bicep'
var location = 'Australia East'
var resourceGroup = 'rg-constructix-dev-ae-02'
/* ----------------- Registry ------------------- */
var registryContainerName = 'constructixdockerregistry'
var repositoryName = 'constructixonlineservicesfunctions'

param registryContainerObject = {
  name: registryContainerName
  repositoryName: repositoryName
  tag: 'latest'
  resourceGroup: resourceGroup
  location: location
  tagValues: {
    Environment: 'dev'
    Company: 'Constructix'
    Purpse: 'Container registry for Constructix docker images'
  }
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}