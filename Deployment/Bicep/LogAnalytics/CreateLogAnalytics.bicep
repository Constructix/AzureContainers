param workspaceObject object

resource workspaceResource 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: workspaceObject.name
  location: workspaceObject.location
  tags: workspaceObject.tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      legacy: 0
      searchVersion: 1
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: json('-1')
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Add these two outputs at the end of CreateLogAnalytics.bicep
output customerId string = workspaceResource.properties.customerId
//output sharedKey string = workspaceResource.listKeys().primarySharedKey
