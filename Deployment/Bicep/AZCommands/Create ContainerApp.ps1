az containerapp create `
    --resource-group rg-constructix-dev-ae-02 `
    --name firstconstructixcontainerapp `
    --environment constructixtestappenvironment `
    --image constructixdockerregistry.azurecr.io/dockerimage:v1.0.0 `
    --ingress external `
    --target-port 80 `
    --registry-server constructixdockerregistry.azurecr.io `
    --registry-identity <USER_ASSIGNED_IDENTITY_RESOURCE_ID> `
    --user-assigned <USER_ASSIGNED_IDENTITY_RESOURCE_ID> `
    --env-vars `
    FUNCTIONS_WORKER_RUNTIME=dotnet-isolated `
    AzureWebJobsStorage__accountName=saconstructixaedev01 `
    AzureWebJobsStorage__credential=managedidentity `
    AzureWebJobsStorage__blobServiceUri=https://saconstructixaedev01.blob.core.windows.net `
    AzureWebJobsStorage__queueServiceUri=https://saconstructixaedev01.queue.core.windows.net `
    AzureWebJobsStorage__tableServiceUri=https://saconstructixaedev01.table.core.windows.net `
    AzureWebJobsStorage__fileServiceUri=https://saconstructixaedev01.file.core.windows.net

