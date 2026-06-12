$latestTag = az acr repository show-tags `
  --name crelectordevae `
  --repository electorservicesrepository `
  --orderby time_desc `
  --top 1 `
  --output tsv 
Write-Host "Latest Tag:$latestTag" 
# when put into the deployment pipeline will assign to 
# Write-Host "##vso[task.setvariable variable=latestTag]$latestTag"
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group rg-ems-elector-ae-dev `
  --template-file main.bicep `
  --parameters main-dev.bicepparam latestImageTag=$latestTag assignRoleToAppConfig=true
