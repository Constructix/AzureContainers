param (
	 [string] $ResourceGroup, 
     [string] $ContainerRepository,
     [string] $DeploymentEnv, 
     [string] $RepositoryName 
)
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group $ResourceGroup `
  --template-file main.bicep `
  --parameters main-$DeploymentEnv.bicepparam  
