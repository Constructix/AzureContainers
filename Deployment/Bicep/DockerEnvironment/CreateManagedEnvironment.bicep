param containerAppsEnvironment object
//param managedEnvironments_dockercontainerdevenvironment_name string = 'dockercontainerdevenvironment'
param logAnalyticsCustomerId string // ← add this
@secure()
param logAnalyticsSharedKey string // ← add this

resource managedEnvironments_dockercontainerdevenvironment_name_resource 'Microsoft.App/managedEnvironments@2025-10-02-preview' = {
  name: containerAppsEnvironment.name 
  location: containerAppsEnvironment.location
  tags: containerAppsEnvironment.tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsCustomerId
        sharedKey: logAnalyticsSharedKey
        dynamicJsonColumns: false
      }
    }
    zoneRedundant: false
    kedaConfiguration: {}
    daprConfiguration: {}
    customDomainConfiguration: {}
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption'
        enableFips: false
      }
    ]
    peerAuthentication: {
      mtls: {
        enabled: false
      }
    }
    peerTrafficConfiguration: {
      encryption: {
        enabled: false
      }
    }
    publicNetworkAccess: 'Enabled'
  }
}
