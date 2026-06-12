param name string = 'constructixdockerdevae01'
param location string = 'australiaeast'
param sku string = 'pergb2018'
param tags object = {
  Company: 'ECQ'
  Environment: 'dev'
  Purpose: 'Creating an application insights resource for container app environment'
}

resource name_resource 'Microsoft.OperationalInsights/workspaces@2017-03-15-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
  }
}
