param(
    [Parameter(Mandatory = $true)]
    [string] $AcrName
)

Write-Host "Fetching repositories from ACR: $AcrName..." -ForegroundColor Cyan

$repos = az acr repository list `
    --name $AcrName `
    --output tsv

if (-not $repos) {
    Write-Host "No repositories found. ACR is already empty." -ForegroundColor Yellow
    return
}

Write-Host "Found repositories:" -ForegroundColor Green
$repos | ForEach-Object { Write-Host " - $_" }

foreach ($repo in $repos) {
    Write-Host "Deleting repository: $repo" -ForegroundColor Magenta

    az acr repository delete `
        --name $AcrName `
        --repository $repo `
        --yes

    Write-Host "Deleted: $repo" -ForegroundColor DarkGreen
}

Write-Host "ACR flush complete." -ForegroundColor Cyan
