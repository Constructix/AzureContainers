using 'createAppInsights.bicep'

var tagObject object = {
    company : 'ECQ'
    environment : 'DEV'
}

param workspaceObject = {
  name                                                  : 'wkspaceconstructixdockerdevae01'
  location                                              : 'AustraliaEast'
  sku                                                   : 'pergb2018'
  tags: {
    Company                                             : 'ECQ'
    Environment                                         : 'dev'    
  }
}
param appInsightsObject = {
  name                                                  : 'constructixdockerdevae01'
  type                                                  : 'web'
  region                                                : 'australiaeast'
  requestSource                                         : 'IbizaAIExtension'
  tags                                                  : tagObject
}
