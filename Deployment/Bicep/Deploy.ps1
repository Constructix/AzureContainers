param (
	 [string] $ResourceGroup, 
     [string] $ContainerRepository,
     [string] $DeploymentEnv, 
     [string] $RepositoryName 
)
$bytes = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$subscriptionKey = [Convert]::ToBase64String($bytes)

Write-Host "Subscription Key value: '$subscriptionKey'"
Write-Host "ContainerAppFqdn param value: '$ContainerAppFqdn'"
Write-Host "Length: $($ContainerAppFqdn.Length)"



Write-Host "ResourceGroup=$ResourceGroup ContainerRepository=$ContainerRepository DeploymentEnv=$DeploymentEnv RepositoryName=$RepositoryName"
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group $ResourceGroup `
  --template-file main.bicep `
  --parameters main-$DeploymentEnv.bicepparam  
