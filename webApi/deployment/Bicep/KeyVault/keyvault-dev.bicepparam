// Resource Group: rg-qems-hub-ae-sandbox'
using 'CreateKeyvault.bicep'

type TagValues = {
  Environment                                           : 'DEV' | 'Test' | 'PREPROD' | 'PROD'
  Company                                               : string
}

var tags TagValues = {
  Company                                               : 'ECQ'
  Environment                                           : 'DEV'
}


param keyVaultObject = {
  name                                                  : 'kv-qems-dev'
  tags                                                  : tags            
}
