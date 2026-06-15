param (
	[string] $ResourceGroup,
	[string] $ContainerRegistry,
	[string] $RepositoryName,
	[string] $Environment
)
$latestTag = az acr repository show-tags `
  --name $ContainerRegistry `
  --repository $RepositoryName `
  --orderby time_desc `
  --top 1 `
  --output tsv 
Write-Host "Latest Tag:$latestTag" 
az deployment group create `
  --name DeployContainerApp `
  --resource-group $ResourceGroup `
  --template-file CreateContainer.bicep `
  --parameters createContainer-$Environment.bicepparam latestImageTag=$latestTag