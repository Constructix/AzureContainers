# firstly get the the named identity and make sure to delete it. 


#$registryName='constructixdockerregistry'
#$identityName='constructixcontainerappidentity01'
#$rg='rg-constructix-dev-ae-02'
#$storageAccount = 'staazurefunc01'
#$json = az identity show `
#    --name $identityName `
#    --resource-group $rg `
#    | ConvertFrom-Json

#$clientId = $json.clientId

#if($null -eq $clientId) {
#    Write-Host 'NO Client Id Found, will not delete existing roles for  $identityName'
#}
#else {
#    Write-Host '*************************************************************************************************'
#    Write-Host 'Client Id: $clientId'
#    Write-Host '*************************************************************************************************'
#    az role assignment delete --assignee  $clientId --scope $(az acr show -n $registryName --query id -o tsv)
#    az role assignment delete --assignee $clientId --scope $(az storage account show -n $storageAccount -g $rg --query id -o tsv)
#    az role assignment delete --assignee $clientId --scope $(az appconfig show -n 'apconfig-constructix-ae-dev-01' -g 'rg-constructix-dev-ae-01' --query id -o tsv)     
#}
#az identity delete --name "constructixcontainerappidentity01" --resource-group "rg-constructix-dev-ae-02"

$latestTag = az acr repository show-tags `
  --name constructixdockerregistry `
  --repository constructixonlineservicesfunctions `
  --orderby time_desc `
  --top 1 `
  --output tsv 
Write-Host "Latest Tag:$latestTag" 
# when put into the deployment pipeline will assign to 
# Write-Host "##vso[task.setvariable variable=latestTag]$latestTag"
az deployment group create `
  --name AzureFunctionsOnContainerAppsDeploymentUserAssigned `
  --resource-group rg-constructix-dev-ae-02 `
  --template-file main.bicep `
  --parameters main.bicepparam latestImageTag=$latestTag assignRoleToAppConfig=true
#az role assignment list --resource-group rg-constructix-dev-ae-02 --output table