FROM mcr.microsoft.com/dotnet/sdk:10.0 AS installer-env

COPY . /src/dotnet-function-app
RUN cd /src/dotnet-function-app && \
mkdir -p /home/site/wwwroot && \
dotnet publish dockerDemo.csproj -c Release --output /home/site/wwwroot

# To enable ssh & remote debugging on app service change the base image to the one below
# FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated8.0-appservice
FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated10.0
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY --from=installer-env ["/home/site/wwwroot", "/home/site/wwwroot"]
#ENTRYPOINT ["dotnet", "dockerDemo.dll"]

## ============================
## 1. Build Stage
## ============================
#FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
#
#WORKDIR /src
#
## Copy everything into the container
#COPY . .
#
## Publish the Azure Function to /home/site/wwwroot
#RUN dotnet publish dockerDemo.csproj \
    #-c Release \
    #-o /home/site/wwwroot
#
#
## ============================
## 2. Runtime Stage
## ============================
#FROM mcr.microsoft.com/dotnet/sdk:10.0
#
## Required environment variables for isolated worker
#ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    #AzureFunctionsJobHost__Logging__Console__IsEnabled=true
#
## Copy published output from build stage
#COPY --from=build /home/site/wwwroot /home/site/wwwroot
#
## ENTRYPOINT must point to your function DLL
#ENTRYPOINT ["dotnet", "dockerDemo.dll"]
#
##COPY --from=build /home/site/wwwroot /home/site/wwwroot
