az deployment  group create --name DeployContainerRegistry `
    --resource-group rg-constructix-dev-ae-02 `
    --template-file deploy-dev.bicep `
    --parameters deploy-dev.bicepparam