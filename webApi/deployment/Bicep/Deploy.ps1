param (
	 [string] $ResourceGroup, 
     [string] $ContainerRepository,
     [string] $DeploymentEnv, 
     [string] $RepositoryName 
)

Write-Host "ResourceGroup=$ResourceGroup ContainerRepository=$ContainerRepository DeploymentEnv=$DeploymentEnv RepositoryName=$RepositoryName"
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group $ResourceGroup `
  --template-file main.bicep `
  --parameters main-$DeploymentEnv.bicepparam  
