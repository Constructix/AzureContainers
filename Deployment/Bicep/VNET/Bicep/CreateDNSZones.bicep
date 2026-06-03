param vnetId string

var dnsZones = [
  'privatelink.azurecr.io'
  'privatelink.vaultcore.azure.net'
  'privatelink.azconfig.io'
  'privatelink.blob.core.windows.net'
  'privatelink.queue.core.windows.net'
  'privatelink.table.core.windows.net'
  'privatelink.file.core.windows.net'
  'privatelink.servicebus.windows.net'
]

// Create all DNS zones
resource privateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [
  for zone in dnsZones: {
    name: zone
    location: 'global'
  }
]

// Link all DNS zones to VNet
resource vnetLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [
  for (zone, i) in dnsZones: {
    parent: privateDnsZones[i]
    name: '${replace(zone, '.', '-')}-link'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: vnetId
      }
      registrationEnabled: false
    }
  }
]
