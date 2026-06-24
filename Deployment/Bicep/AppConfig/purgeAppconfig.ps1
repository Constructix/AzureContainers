param (	 
	 [string] $AppConfigName, 
	 [string] $ResourceGroup
)
Write-Host "Deleting $AppConfigName"
az appconfig delete  --name $AppConfigName --resource-group $ResourceGroup
Write-host "Waiting 3 minutes for AppConfig to be deleted, then purge the Appconfig"
Start-Sleep -Duration (New-TimeSpan -Minutes 3)
# configuration name eg- constructixServicesConfig
Write-host "Purging Appconfig, please wait.."
az appconfig purge --name $AppConfigName
Write-host "Purge Appconfig was successful."