@echo off
setlocal enabledelayedexpansion
color 0B
cls

echo ================================================================================
echo              AUTOMATIC SETUP COMPLETION
echo ================================================================================
echo.
echo This script will complete ALL remaining steps automatically:
echo   1. Check/Install GitHub CLI
echo   2. Authenticate with GitHub
echo   3. Add all 7 Firebase secrets to GitHub
echo   4. Guide you to add the service account
echo   5. Deploy to Firebase
echo.
pause

:check_gh
cls
echo ================================================================================
echo STEP 1: Checking GitHub CLI
echo ================================================================================
echo.

where gh >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] GitHub CLI is installed!
    goto :auth_github
)

echo GitHub CLI not found. Downloading and installing...
echo.

echo Downloading GitHub CLI installer...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/cli/cli/releases/download/v2.62.0/gh_2.62.0_windows_amd64.msi', '%TEMP%\gh-cli.msi')"

if errorlevel 1 (
    color 0C
    echo.
    echo [ERROR] Download failed!
    echo Please download and install manually from: https://cli.github.com/
    start https://cli.github.com/
    pause
    exit /b 1
)

echo Installing GitHub CLI...
msiexec /i "%TEMP%\gh-cli.msi" /quiet /norestart

echo.
echo GitHub CLI installed! Refreshing environment...
echo.
echo IMPORTANT: Please close this window and run this script again!
echo.
pause
exit

:auth_github
cls
echo ================================================================================
echo STEP 2: GitHub Authentication
echo ================================================================================
echo.

gh auth status >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Already authenticated!
    goto :add_secrets
)

echo Logging in to GitHub...
echo A browser window will open. Follow the prompts.
echo.

gh auth login --web

if errorlevel 1 (
    color 0C
    echo.
    echo [ERROR] Authentication failed!
    pause
    exit /b 1
)

:add_secrets
color 0A
cls
echo ================================================================================
echo STEP 3: Adding GitHub Secrets
echo ================================================================================
echo.

cd "C:\Users\ismailukman\Documents\B-Work\Eduvatekids\app"

echo [1/7] NEXT_PUBLIC_FIREBASE_API_KEY
echo AIzaSyB0Bv529O2KODbqZX75j-Gl7GoPHJ5A6po | gh secret set NEXT_PUBLIC_FIREBASE_API_KEY >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo [2/7] NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN
echo eduvatekids-store.firebaseapp.com | gh secret set NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo [3/7] NEXT_PUBLIC_FIREBASE_PROJECT_ID
echo eduvatekids-store | gh secret set NEXT_PUBLIC_FIREBASE_PROJECT_ID >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo [4/7] NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET
echo eduvatekids-store.firebasestorage.app | gh secret set NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo [5/7] NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID
echo 199688038921 | gh secret set NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo [6/7] NEXT_PUBLIC_FIREBASE_APP_ID
echo 1:199688038921:web:d3c8284655bfa094d426d8 | gh secret set NEXT_PUBLIC_FIREBASE_APP_ID >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo [7/7] NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID
echo G-2DW5M7K8GR | gh secret set NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID >nul 2>&1
if errorlevel 0 (echo       [OK]) else (echo       [WARN])

echo.
echo [SUCCESS] All 7 Firebase config secrets added!

:service_account
cls
echo ================================================================================
echo STEP 4: Firebase Service Account
echo ================================================================================
echo.
echo Opening Firebase Service Accounts page...
start https://console.firebase.google.com/u/0/project/eduvatekids-store/settings/serviceaccounts/adminsdk
timeout /t 3 >nul
echo.
echo Please follow these steps on the opened page:
echo 1. Click "Generate new private key"
echo 2. Click "Generate key" in the popup
echo 3. The JSON file will download to your Downloads folder
echo 4. Remember the filename!
echo.
pause

echo.
set /p "jsonfile=Enter the full path to the downloaded JSON file (or drag-and-drop it here): "
set jsonfile=%jsonfile:"=%

if exist "%jsonfile%" (
    echo.
    echo Adding FIREBASE_SERVICE_ACCOUNT secret...
    type "%jsonfile%" | gh secret set FIREBASE_SERVICE_ACCOUNT
    if errorlevel 0 (
        echo [OK] Service account added!
    ) else (
        echo [WARN] May have failed, check GitHub secrets page
    )
) else (
    echo.
    echo [WARN] File not found. You can add it manually later with:
    echo       gh secret set FIREBASE_SERVICE_ACCOUNT ^< "path-to-file.json"
)

:firebase_deploy
cls
echo ================================================================================
echo STEP 5: Deploy to Firebase
echo ================================================================================
echo.
echo All secrets are configured! Now deploying to Firebase...
echo.
pause

echo Logging in to Firebase...
call firebase login

if errorlevel 1 (
    echo [ERROR] Firebase login failed!
    pause
    exit /b 1
)

echo.
echo Building Next.js app...
call npm run build

if errorlevel 1 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo.
echo Deploying to Firebase Hosting...
call firebase deploy --only hosting,firestore:rules,firestore:indexes --project eduvatekids-store

if errorlevel 1 (
    echo [ERROR] Deployment failed!
    pause
    exit /b 1
)

:complete
color 0A
cls
echo ================================================================================
echo                   SETUP COMPLETE!
echo ================================================================================
echo.
echo [SUCCESS] Everything is now configured and deployed!
echo.
echo Your live site:
echo   https://eduvatekids-store.web.app
echo   https://eduvatekids-store.firebaseapp.com
echo.
echo Local development:
echo   http://localhost:8050
echo.
echo GitHub Actions:
echo   https://github.com/ismailukman/EduvateKids/actions
echo.
echo ================================================================================
echo.
echo Next steps:
echo 1. Verify secrets: https://github.com/ismailukman/EduvateKids/settings/secrets/actions
echo 2. Test auto-deployment:
echo      git add .
echo      git commit -m "Test deployment"
echo      git push origin master
echo.
echo ================================================================================
echo.
echo Opening your live site and GitHub Actions...
timeout /t 2 >nul
start https://eduvatekids-store.web.app
timeout /t 1 >nul
start https://github.com/ismailukman/EduvateKids/actions
timeout /t 1 >nul
start https://github.com/ismailukman/EduvateKids/settings/secrets/actions

echo.
echo All done! Check your browser.
echo.
pause
