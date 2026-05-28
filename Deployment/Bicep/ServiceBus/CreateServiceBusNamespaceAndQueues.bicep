param ServicebusObject object


resource serviceBusResource 'Microsoft.ServiceBus/namespaces@2025-05-01-preview' = {
  name: ServicebusObject.name
  location: ServicebusObject.location
  sku: ServicebusObject.sku
  properties: {
    platformCapabilities: {
      confidentialCompute: {
        mode: 'Disabled'
      }
    }
    geoDataReplication: {
      maxReplicationLagDurationInSeconds: 0
      locations: [
        {
          locationName: 'australiaeast'
          roleType: 'Primary'
        }
      ]
    }
    premiumMessagingPartitions: 0
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    zoneRedundant: true
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
  parent: serviceBusResource
  name: 'default'  
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    virtualNetworkRules: []
    ipRules: []
    trustedServiceAccessEnabled: false
  }
}




resource createServiceBusQueues 'Microsoft.ServiceBus/namespaces/queues@2025-05-01-preview' = [
    for queueName in ServicebusObject.queues : {
  parent: serviceBusResource
  name: queueName  
  properties: {
    maxMessageSizeInKilobytes: 256
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P14D'
    deadLetteringOnMessageExpiration: false
    enableBatchedOperations: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    status: 'Active'
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }  
}
]
