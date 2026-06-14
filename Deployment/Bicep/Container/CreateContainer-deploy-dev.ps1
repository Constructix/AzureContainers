param (
	[string] $ResourceGroup,
	[string] $ContainerRepository 
)
$latestImageTag = az acr repository show-tags `
  --name crelectordevae `
  --repository $ContainerRepository `
  --orderby time_desc `
  --top 1 `
  --output tsv 
if (-not $latestImageTag) {
	Write-Error "Failed to retrieve latest image tag from ACR."
	exit 1
}

Write-Host "Latest Tag:$latestImageTag" 
az deployment group create `
  --name DeployContainerApp `
  --resource-group $ResourceGroup `
  --template-file CreateContainer.bicep `
  --parameters createContainer-dev.bicepparam latestImageTag=$latestImageTag