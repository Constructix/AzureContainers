param serviceBusNamespaceObject object


resource serviceBusResource 'Microsoft.ServiceBus/namespaces@2025-05-01-preview' = {
  name                                                          : serviceBusNamespaceObject.name
  location                                                      : serviceBusNamespaceObject.location
  sku                                                           : serviceBusNamespaceObject.sku
  properties: {
    platformCapabilities: {
      confidentialCompute: {
        mode                                                    : 'Disabled'
      }
    }
    geoDataReplication: {
      maxReplicationLagDurationInSeconds: 0
      locations: [
        {
          locationName                                          : 'australiaeast'
          roleType                                              : 'Primary'
        }
      ]
    }
    premiumMessagingPartitions                                  : 0
    minimumTlsVersion                                           : '1.2'
    publicNetworkAccess                                         : 'Enabled'
    disableLocalAuth                                            : false
    zoneRedundant                                               : true
  }
}

resource serviceBusResourceRootSharedAccessKey 'Microsoft.ServiceBus/namespaces/authorizationrules@2025-05-01-preview' = {
  parent: serviceBusResource
  name: 'RootManageSharedAccessKey'
  
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource serviceBusNamespaceNetworkRulesResource 'Microsoft.ServiceBus/namespaces/networkrulesets@2025-05-01-preview' = {
  parent                                                         : serviceBusResource
  name                                                           : 'default'  
  properties: {
    publicNetworkAccess                                          : 'Enabled'
    defaultAction                                                : 'Allow'
    virtualNetworkRules                                          : []
    ipRules                                                      : []
    trustedServiceAccessEnabled                                  : false
  }
}




resource createServiceBusQueues 'Microsoft.ServiceBus/namespaces/queues@2025-05-01-preview' = [
    for currentQueue in serviceBusNamespaceObject.queues : {
  parent                                                        : serviceBusResource
  name                                                          : currentQueue.queueName
  properties                                                    : currentQueue.properties  
}
]
