# syntax=docker/dockerfile:1

# ============================================================
# Build stage
# ============================================================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy csproj first to leverage Docker layer caching on restore
COPY ["QEMS.SampleWebApi.Demo.csproj", "."]
RUN dotnet restore "QEMS.SampleWebApi.Demo.csproj"

# Copy remaining source and build
COPY . .
RUN dotnet build "QEMS.SampleWebApi.Demo.csproj" -c $BUILD_CONFIGURATION -o /app/build --no-restore

# ============================================================
# Publish stage
# ============================================================
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "QEMS.SampleWebApi.Demo.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    --no-restore \
    /p:UseAppHost=false

# ============================================================
# Final runtime stage
# ============================================================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app

# Azure Container Apps routes to this port via the Container App's targetPort.
# Make sure the Bicep/ARM ingress targetPort matches this value.
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 8080

# Run as non-root for security/ISO 27001 hardening alignment.
# The aspnet base image ships a built-in unprivileged "app" user (UID 64198).
USER app

COPY --from=publish /app/publish .

# Optional: container-level health check (Azure Container Apps also uses its
# own liveness/readiness probes defined in the Container App Bicep config,
# but this helps with local `docker run` / `docker compose` testing).
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

ENTRYPOINT ["dotnet", "QEMS.SampleWebApi.Demo.dll"]