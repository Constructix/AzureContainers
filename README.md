Demonstrate the use of github actions to deploy Azure resources. 
to enable deployment for the github. need to setup permissions 
### Container Registry
az role assignment create \
  --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b" \
  --role "User Access Administrator" \
  --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-02/providers/Microsoft.ContainerRegistry/registries/constructixdockerregistry"
Moving forward, will need to implement RBAC Registry + ABAC Repository Permissions

 Instead, in ABAC-enabled registries, use the Container Registry Repository Reader, Container Registry Repository Writer, and Container Registry Repository Contributor roles to grant either registry-wide or repository-specific image permissions.

Additionally, privileged roles such as Owner, Contributor, and Reader have different effects in an ABAC-enabled registry. In these repositories, these privileged roles grant only control plane permissions to create, update, and delete the registry itself, without granting data plane permissions to the repositories and images in the registry.

### Service Bus
az role assignment create   --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b" --role "User Access Administrator"  --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-02/providers/Microsoft.ServiceBus/namespaces/constructix-orders-ae-dev"  

### Storage Account
az role assignment create --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b"   --role "User Access Administrator"   --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-02/providers/Microsoft.Storage/storageAccounts/staazurefunc01" 

### AppConfig Resource
az role assignment create --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b"   --role "User Access Administrator"   --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-01/providers/Microsoft.AppConfiguration/configurationStores/apconfig-constructix-ae-dev-01" 
