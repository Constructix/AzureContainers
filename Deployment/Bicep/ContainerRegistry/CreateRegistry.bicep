// param registries_constructixfirstcontainerregistry_name string = 'constructixfirstcontainerregistry'
param registryContainerObject object

resource registries_constructixfirstcontainerregistry_name_resource 'Microsoft.ContainerRegistry/registries@2025-11-01' = {
  name                                                      : registryContainerObject.name
  location                                                  : registryContainerObject.location
  tags                                                      : registryContainerObject.tagValues
  sku: registryContainerObject.sku
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    adminUserEnabled: true
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
      azureADAuthenticationAsArmPolicy: {
        status: 'enabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    networkRuleBypassAllowedForTasks: false
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
    roleAssignmentMode: 'LegacyRegistryPermissions'
  }
}

// resource registries_constructixfirstcontainerregistry_name_repositories_admin 'Microsoft.ContainerRegistry/registries/scopeMaps@2025-11-01' = {
//   parent: registries_constructixfirstcontainerregistry_name_resource
//   name: '_repositories_admin'
//   properties: {
//     description: 'Can perform all read, write and delete operations on the registry'
//     actions: [
//       'repositories/*/metadata/read'
//       'repositories/*/metadata/write'
//       'repositories/*/content/read'
//       'repositories/*/content/write'
//       'repositories/*/content/delete'
//     ]
//   }
// }

// resource registries_constructixfirstcontainerregistry_name_repositories_pull 'Microsoft.ContainerRegistry/registries/scopeMaps@2025-11-01' = {
//   parent: registries_constructixfirstcontainerregistry_name_resource
//   name: '_repositories_pull'
//   properties: {
//     description: 'Can pull any repository of the registry'
//     actions: [
//       'repositories/*/content/read'
//     ]
//   }
// }

// resource registries_constructixfirstcontainerregistry_name_repositories_pull_metadata_read 'Microsoft.ContainerRegistry/registries/scopeMaps@2025-11-01' = {
//   parent: registries_constructixfirstcontainerregistry_name_resource
//   name: '_repositories_pull_metadata_read'
//   properties: {
//     description: 'Can perform all read operations on the registry'
//     actions: [
//       'repositories/*/content/read'
//       'repositories/*/metadata/read'
//     ]
//   }
// }

// resource registries_constructixfirstcontainerregistry_name_repositories_push 'Microsoft.ContainerRegistry/registries/scopeMaps@2025-11-01' = {
//   parent: registries_constructixfirstcontainerregistry_name_resource
//   name: '_repositories_push'
//   properties: {
//     description: 'Can push to any repository of the registry'
//     actions: [
//       'repositories/*/content/read'
//       'repositories/*/content/write'
//     ]
//   }
// }

// resource registries_constructixfirstcontainerregistry_name_repositories_push_metadata_write 'Microsoft.ContainerRegistry/registries/scopeMaps@2025-11-01' = {
//   parent: registries_constructixfirstcontainerregistry_name_resource
//   name: '_repositories_push_metadata_write'
//   properties: {
//     description: 'Can perform all read and write operations on the registry'
//     actions: [
//       'repositories/*/metadata/read'
//       'repositories/*/metadata/write'
//       'repositories/*/content/read'
//       'repositories/*/content/write'
//     ]
//   }
// }
