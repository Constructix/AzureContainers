// creating app configuration resource

param appConfigObject object

resource configStore 'Microsoft.AppConfiguration/configurationStores@2025-08-01-preview' = {
  name                                                  : appConfigObject.name
  location                                              : resourceGroup().location
  tags                                                  : appConfigObject.tags
  sku: {
    name: 'standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// create a keyvalue
resource configurationKeyValueResource 'Microsoft.AppConfiguration/configurationStores/keyValues@2025-08-01-preview' ={
    name                                                : 'systemAdminEmail'
    parent                                              : configStore
    properties: {
        value                                           : 'richard.jones.aadadmin@ecq.qld.gov.au'
        contentType                                     :'text/plain'        
    }
}
