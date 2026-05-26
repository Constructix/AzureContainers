# Builds the docker image.
docker build --tag ecq/azurefunctionsimage:v1.0.0 .

# For Azure Container app need to specify what OS 
docker buildx build --platform linux/amd64 --provenance=false -tag ecq/azurefunctionsimage:v1.0.0 .

# Starts the docker image
docker run -p 8087:80 -e AzureWebJobsSecretStorageType=files -e FUNCTIONS_WORKER_RUNTIME=dotnet-isolated -it ecq/azurefunctionsimage:v1.0.0

# to publish to Docker container registry
docker tag ecq/azurefunctionsimage:v1.0.0 constructixfirstcontainerregistry.azurecr.io/azurefunctionsimage:v1.0.0 
#push to container registry
docker push constructixfirstcontainerregistry.azurecr.io/azurefunctionsimage:v1.0.0


az functionapp function show --resource-group DefaultResourceGroup-EA --name firstcontainerdemo --function-name firstcontainerdemo --query invokeUrlTemplate

