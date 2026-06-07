$latestTag = az acr repository show-tags `
  --name constructixdockerregistry `
  --repository constructixonlineservicesfunctions `
  --orderby time_desc `
  --top 1 `
  --output tsv 
Write-Host "Latest Tag:$latestTag" 
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group rg-constructix-dev-ae-02 `
  --template-file CreateContainer.bicep `
  --parameters createContainer-dev.bicepparam latestImageTag=$latestTag