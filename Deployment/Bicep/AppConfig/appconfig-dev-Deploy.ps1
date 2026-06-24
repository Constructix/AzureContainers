param (
	 [string] $ResourceGroup     
)

az deployment group create `
  --name AzureConfigurationDeployment `
  --resource-group $ResourceGroup `
  --template-file createAppConfig.bicep `
  --parameters createAppconfig-dev.bicepparam  