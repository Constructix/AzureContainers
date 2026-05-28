Demonstrate the use of github actions to deploy Azure resources. 
to enable deployment for the github. need to setup permissions 
#### Container Registry
az role assignment create \
  --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b" \
  --role "User Access Administrator" \
  --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-02/providers/Microsoft.ContainerRegistry/registries/constructixdockerregistry"

###Service Bus
az role assignment create   --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b" --role "User Access Administrator"  --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-02/providers/Microsoft.ServiceBus/namespaces/constructix-orders-ae-dev"  

###Storage Account
az role assignment create --assignee "2d1bf4e7-d795-4154-a124-540697f51d2b"   --role "User Access Administrator"   --scope "/subscriptions/fa7941a8-d614-416c-8bae-6e4a36930017/resourceGroups/rg-constructix-dev-ae-02/providers/Microsoft.Storage/storageAccounts/staazurefunc01" 
