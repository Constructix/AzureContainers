az deployment  group create --name DeployContainerRegistry `
    --resource-group rg-constructix-dev-ae-02 `
    --template-file CreateOnLineServicesRegistry.bicep  