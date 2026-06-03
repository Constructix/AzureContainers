$resourceGroupName = 'rg-constructix-dev-ae-03'
$templateFile = 'Create_VNET.bicep'
az deployment group create `
  --name DeployVNET `
  --resource-group $resourceGroupName `
  --template-file $templateFile `
