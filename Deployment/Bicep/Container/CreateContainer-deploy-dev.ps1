param (
	[string] $ResourceGroup # Repository Group
	[string] $ContainerRepository #Respository Name query the latest tag, to passin and create the container app. 
)
$latestImageTag = az acr repository show-tags `
  --name crelectordevae `
  --repository $ContainerRepository `
  --orderby time_desc `
  --top 1 `
  --output tsv 
Write-Host "Latest Tag:$latestTag" 
az deployment group create `
  --name DeployContainerApp `
  --resource-group $ResourceGroup `
  --template-file CreateContainer.bicep `
  --parameters createContainer-dev.bicepparam latestImageTag=$latestImageTag