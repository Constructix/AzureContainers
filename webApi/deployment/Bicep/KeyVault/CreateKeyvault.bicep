param keyVaultObject object
resource keyVaultResource 'Microsoft.KeyVault/vaults@2024-10-01' = {
  name                                                  : keyVaultObject.name
  location                                              : keyVaultObject.location
  tags                                                  : keyVaultObject.tags
 
  properties: {
    sku: {
      family                                            : 'A'
      name                                              : 'standard'
    }
    tenantId                                            : subscription().tenantId
    enableSoftDelete                                    : true
    enablePurgeProtection                               : true
    enableRbacAuthorization                             : true
    networkAcls: {
      defaultAction                                     : 'Deny'
      bypass                                            : 'AzureServices'
      virtualNetworkRules                               : []
      ipRules                                           : []
    }
  }
 
}
