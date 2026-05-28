using 'createAppInsights.bicep'

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
