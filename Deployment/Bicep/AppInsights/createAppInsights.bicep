param workspaceObject object
param appInsightsObject object

resource workspaceResource 'Microsoft.OperationalInsights/workspaces@2017-03-15-preview' = {
  name: workspaceObject.name
  location: workspaceObject.location
  tags: workspaceObject.tags
  properties: {
    sku: {
      name: workspaceObject.sku
    }
  }
}

resource appInsightsResource 'microsoft.insights/components@2020-02-02-preview' = {
  name: appInsightsObject.name
  location: appInsightsObject.region
  properties: {
    Application_Type: appInsightsObject.type
    Flow_Type: 'Redfield'
    Request_Source: appInsightsObject.requestSource
    WorkspaceResourceId: workspaceResource.id
  }
  dependsOn: [workspaceResource]
}
