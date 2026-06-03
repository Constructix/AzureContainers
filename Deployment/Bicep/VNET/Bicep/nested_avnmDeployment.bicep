@description('Array of IPAM pools.')
param ipamPools array = []

@description('Virtual Network Manager to deploy')
param networkManager object = {}
param createNetworkManager bool = false
param networkManagerName string = '##network-manager-name-not-set##'

resource networkManager_resource 'Microsoft.Network/networkManagers@2022-01-01' = if (createNetworkManager) {
  name: networkManagerName
  location: networkManager.location
  properties: {
    description: networkManager.properties.description
    networkManagerScopes: networkManager.properties.networkManagerScopes
    networkManagerScopeAccesses: networkManager.properties.networkManagerScopeAccesses
  }
}

resource ipamPools_name 'Microsoft.Network/networkManagers/ipamPools@2024-05-01' = [
  for item in ipamPools: if (length(ipamPools) > 0) {
    name: item.name
    location: item.location
    properties: item.properties
    dependsOn: [
      networkManager_resource
    ]
  }
]
