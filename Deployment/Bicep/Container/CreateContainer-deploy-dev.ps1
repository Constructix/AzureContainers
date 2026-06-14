$latestTag = az acr repository show-tags `
  --name crelectordevae `
  --repository electorservicesrepository `
  --orderby time_desc `
  --top 1 `
  --output tsv 
Write-Host "Latest Tag:$latestTag" 
az deployment group create `
  --name DeployContainerApp `
  --resource-group rg-ems-elector-ae-dev `
  --template-file CreateContainer.bicep `
  --parameters createContainer-dev.bicepparam latestImageTag=$latestTag