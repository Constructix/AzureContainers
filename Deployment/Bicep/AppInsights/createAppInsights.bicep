param workspaceObject object
param appInsightsObject object

resource workspaceResource 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name                                                  : workspaceObject.name
  location                                              : workspaceObject.location
  tags                                                  : workspaceObject.tags
  properties: {
    sku: {
      name                                              : workspaceObject.sku
    }
  }
}

resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name                                                  : appInsightsObject.name
  location                                              : appInsightsObject.region
  properties: {
    Application_Type                                    : appInsightsObject.type        
    WorkspaceResourceId                                 : workspaceResource.id
  }  
}
