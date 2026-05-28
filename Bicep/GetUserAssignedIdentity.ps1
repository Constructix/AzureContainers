#az identity show  --name constructixcontainerappidentity01 --resource-group "rg-constructix-dev-ae-02"
$registryName='constructixdockerregistry'
$identityName='constructixcontainerappidentity01'
$rg='rg-constructix-dev-ae-02'
$storageAccount = 'staazurefunc01'
$json = az identity show `
    --name $identityName `
    --resource-group $rg `
    | ConvertFrom-Json

$clientId = $json.clientId
Write-Host 'Client Id: '+ $clientId
az role assignment delete --assignee  $clientId --scope $(az acr show -n $registryName --query id -o tsv)

az role assignment delete --assignee $clientId --scope $(az storage account show -n $storageAccount -g $rg --query id -o tsv)

az role assignment delete --assignee $clientId --scope $(az appconfig show -n 'apconfig-constructix-ae-dev-01' -g 'rg-constructix-dev-ae-01' --query id -o tsv)
