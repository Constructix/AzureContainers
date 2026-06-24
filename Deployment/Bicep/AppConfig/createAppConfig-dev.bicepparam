using 'createAppConfig.bicep'

param appConfigObject = {
  name: 'emssharedev'
  sku: {
    name: 'Standard'
  }
  tags: {
    environment: 'dev'
  }
}


