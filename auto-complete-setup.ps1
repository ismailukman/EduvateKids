# Automated setup completion script
# This script completes all remaining manual steps automatically

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AUTOMATED SETUP COMPLETION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install GitHub CLI if not present
Write-Host "[STEP 1] Checking GitHub CLI..." -ForegroundColor Yellow
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if (-not $ghInstalled) {
    Write-Host "Installing GitHub CLI..." -ForegroundColor Yellow

    try {
        # Download GitHub CLI
        $url = "https://github.com/cli/cli/releases/download/v2.62.0/gh_2.62.0_windows_amd64.msi"
        $output = "$env:TEMP\gh-cli.msi"

        Write-Host "Downloading from GitHub..." -ForegroundColor Yellow
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $output)

        Write-Host "Installing GitHub CLI..." -ForegroundColor Yellow
        Start-Process msiexec.exe -ArgumentList "/i `"$output`" /quiet /norestart" -Wait -NoNewWindow

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Write-Host "[OK] GitHub CLI installed!" -ForegroundColor Green
        Write-Host ""
        Write-Host "IMPORTANT: Please close this window and run this script again!" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit
    }
    catch {
        Write-Host "[ERROR] Failed to install GitHub CLI automatically" -ForegroundColor Red
        Write-Host "Please install manually from: https://cli.github.com/" -ForegroundColor Yellow
        Start-Process "https://cli.github.com/"
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "[OK] GitHub CLI is installed" -ForegroundColor Green
Write-Host ""

# Step 2: Authenticate with GitHub
Write-Host "[STEP 2] Authenticating with GitHub..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Please login to GitHub..." -ForegroundColor Yellow
    Write-Host "A browser window will open. Follow the prompts." -ForegroundColor Cyan
    Write-Host ""

    gh auth login --web

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] GitHub authentication failed!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "[OK] Authenticated with GitHub" -ForegroundColor Green
Write-Host ""

# Step 3: Add GitHub Secrets
Write-Host "[STEP 3] Adding GitHub Secrets..." -ForegroundColor Yellow
Write-Host ""

Set-Location "C:\Users\ismailukman\Documents\B-Work\Eduvatekids\app"

$secrets = @{
    "NEXT_PUBLIC_FIREBASE_API_KEY" = "AIzaSyB0Bv529O2KODbqZX75j-Gl7GoPHJ5A6po"
    "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN" = "eduvatekids-store.firebaseapp.com"
    "NEXT_PUBLIC_FIREBASE_PROJECT_ID" = "eduvatekids-store"
    "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET" = "eduvatekids-store.firebasestorage.app"
    "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID" = "199688038921"
    "NEXT_PUBLIC_FIREBASE_APP_ID" = "1:199688038921:web:d3c8284655bfa094d426d8"
    "NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID" = "G-2DW5M7K8GR"
}

$count = 1
$totalSecrets = $secrets.Count

foreach ($key in $secrets.Keys) {
    Write-Host "[$count/$totalSecrets] Adding: $key" -ForegroundColor Cyan

    try {
        $secrets[$key] | gh secret set $key 2>&1 | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "    ✓ Success!" -ForegroundColor Green
        } else {
            Write-Host "    ✗ Failed (may already exist)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "    ✗ Error: $_" -ForegroundColor Red
    }

    $count++
}

Write-Host ""
Write-Host "[OK] All 7 Firebase config secrets processed!" -ForegroundColor Green
Write-Host ""

# Step 4: Service Account Setup
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[STEP 4] Firebase Service Account" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opening Firebase Service Accounts page..." -ForegroundColor Yellow
Start-Process "https://console.firebase.google.com/u/0/project/eduvatekids-store/settings/serviceaccounts/adminsdk"
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "Please complete these manual steps:" -ForegroundColor Cyan
Write-Host "1. Click 'Generate new private key' on the opened page" -ForegroundColor White
Write-Host "2. Click 'Generate key' in the popup" -ForegroundColor White
Write-Host "3. Note where the JSON file is downloaded" -ForegroundColor White
Write-Host ""

$response = Read-Host "Have you downloaded the service account JSON file? (y/n)"

if ($response -eq "y" -or $response -eq "Y") {
    Write-Host ""
    Write-Host "Please enter the full path to the downloaded JSON file:" -ForegroundColor Cyan
    Write-Host "Example: C:\Users\YourName\Downloads\eduvatekids-store-xxxxx.json" -ForegroundColor Gray
    Write-Host ""

    $jsonPath = Read-Host "Path"

    if (Test-Path $jsonPath) {
        Write-Host ""
        Write-Host "Adding FIREBASE_SERVICE_ACCOUNT secret..." -ForegroundColor Yellow

        try {
            Get-Content $jsonPath | gh secret set FIREBASE_SERVICE_ACCOUNT

            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Service account secret added!" -ForegroundColor Green
            } else {
                Write-Host "[ERROR] Failed to add secret" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "[ERROR] Failed to add secret: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[ERROR] File not found: $jsonPath" -ForegroundColor Red
        Write-Host ""
        Write-Host "You can add it manually later with:" -ForegroundColor Yellow
        Write-Host "  gh secret set FIREBASE_SERVICE_ACCOUNT < `"path-to-file.json`"" -ForegroundColor Cyan
    }
}
else {
    Write-Host ""
    Write-Host "You can add the service account secret later with:" -ForegroundColor Yellow
    Write-Host "  gh secret set FIREBASE_SERVICE_ACCOUNT < `"path-to-file.json`"" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SETUP COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Verify secrets at: https://github.com/ismailukman/EduvateKids/settings/secrets/actions" -ForegroundColor White
Write-Host "2. Run: COMPLETE_SETUP_NOW.bat" -ForegroundColor White
Write-Host "3. Test deployment with: git push origin master" -ForegroundColor White
Write-Host ""

$openGitHub = Read-Host "Open GitHub secrets page to verify? (y/n)"
if ($openGitHub -eq "y" -or $openGitHub -eq "Y") {
    Start-Process "https://github.com/ismailukman/EduvateKids/settings/secrets/actions"
}

Write-Host ""
Read-Host "Press Enter to exit"
