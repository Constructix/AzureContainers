param (
	 [string] $ResourceGroup,
  [string] $DeploymentEnv
)  
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group $ResourceGroup `
  --template-file main.bicep `
  --parameters main-$DeploymentEnv.bicepparam  
