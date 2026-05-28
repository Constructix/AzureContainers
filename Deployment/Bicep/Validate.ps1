$latestTag = az acr repository show-tags `
  --name constructixdockerregistry `
  --repository constructixonlineservicesfunctions `
  --orderby time_desc `
  --top 1 `
  --output tsv 
  Write-Host "Latest Tag:$latestTag" 
  # when put into the deployment pipeline will assign to 
  # Write-Host "##vso[task.setvariable variable=latestTag]$latestTag"
az deployment group validate `
    --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
    --resource-group rg-constructix-dev-ae-02 `
    --template-file main.bicep `
    --parameters main.bicepparam assignRoleToAppConfig=true latestImageTag=$latestTag
#az role assignment list --resource-group rg-constructix-dev-ae-02 --output table