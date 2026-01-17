# PowerShell script to automatically add GitHub secrets
# This requires GitHub CLI (gh) to be installed and authenticated

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  Adding GitHub Secrets" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if gh CLI is installed
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if (-not $ghInstalled) {
    Write-Host "[ERROR] GitHub CLI (gh) is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install GitHub CLI first:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://cli.github.com/" -ForegroundColor Yellow
    Write-Host "2. Or run: winget install GitHub.cli" -ForegroundColor Yellow
    Write-Host "3. Then run this script again" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to open GitHub CLI download page"
    Start-Process "https://cli.github.com/"
    exit 1
}

Write-Host "[OK] GitHub CLI is installed" -ForegroundColor Green

# Check if authenticated
Write-Host "Checking GitHub authentication..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "[INFO] Not authenticated with GitHub. Logging in..." -ForegroundColor Yellow
    gh auth login

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] GitHub authentication failed!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "[OK] Authenticated with GitHub" -ForegroundColor Green
Write-Host ""

# Navigate to repository
Set-Location "C:\Users\ismailukman\Documents\B-Work\Eduvatekids\app"

# Define secrets
$secrets = @{
    "NEXT_PUBLIC_FIREBASE_API_KEY" = "AIzaSyB0Bv529O2KODbqZX75j-Gl7GoPHJ5A6po"
    "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN" = "eduvatekids-store.firebaseapp.com"
    "NEXT_PUBLIC_FIREBASE_PROJECT_ID" = "eduvatekids-store"
    "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET" = "eduvatekids-store.firebasestorage.app"
    "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID" = "199688038921"
    "NEXT_PUBLIC_FIREBASE_APP_ID" = "1:199688038921:web:d3c8284655bfa094d426d8"
    "NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID" = "G-2DW5M7K8GR"
}

Write-Host "Adding 7 Firebase configuration secrets..." -ForegroundColor Cyan
Write-Host ""

$count = 1
foreach ($key in $secrets.Keys) {
    Write-Host "[$count/7] Adding secret: $key" -ForegroundColor Yellow

    # Use gh secret set command
    $secrets[$key] | gh secret set $key

    if ($LASTEXITCODE -eq 0) {
        Write-Host "    ✓ Success!" -ForegroundColor Green
    } else {
        Write-Host "    ✗ Failed!" -ForegroundColor Red
    }

    $count++
    Write-Host ""
}

Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Firebase Service Account" -ForegroundColor Yellow
Write-Host ""
Write-Host "You still need to add the FIREBASE_SERVICE_ACCOUNT secret manually." -ForegroundColor Yellow
Write-Host ""
Write-Host "Steps:" -ForegroundColor Cyan
Write-Host "1. Go to: https://console.firebase.google.com/u/0/project/eduvatekids-store/settings/serviceaccounts/adminsdk" -ForegroundColor White
Write-Host "2. Click 'Generate new private key'" -ForegroundColor White
Write-Host "3. Download the JSON file" -ForegroundColor White
Write-Host "4. Run this command in PowerShell:" -ForegroundColor White
Write-Host ""
Write-Host '   Get-Content "path\to\downloaded-file.json" | gh secret set FIREBASE_SERVICE_ACCOUNT' -ForegroundColor Green
Write-Host ""
Write-Host "Or add it manually at:" -ForegroundColor Cyan
Write-Host "https://github.com/ismailukman/EduvateKids/settings/secrets/actions" -ForegroundColor White
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Ask if user wants to open the service accounts page
$response = Read-Host "Open Firebase Service Accounts page now? (Y/n)"
if ($response -eq "" -or $response -eq "Y" -or $response -eq "y") {
    Start-Process "https://console.firebase.google.com/u/0/project/eduvatekids-store/settings/serviceaccounts/adminsdk"
    Start-Sleep -Seconds 2
    Start-Process "https://github.com/ismailukman/EduvateKids/settings/secrets/actions"
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "✓ 7 Firebase config secrets added" -ForegroundColor Green
Write-Host "○ 1 service account secret pending (needs manual download)" -ForegroundColor Yellow
Write-Host ""

Read-Host "Press Enter to exit"
