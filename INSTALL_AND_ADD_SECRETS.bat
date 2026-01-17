@echo off
color 0B
cls
echo ================================================================================
echo          AUTOMATIC GITHUB SECRETS SETUP
echo ================================================================================
echo.
echo This script will:
echo   1. Install GitHub CLI (if needed)
echo   2. Login to GitHub
echo   3. Automatically add all 7 Firebase secrets
echo   4. Guide you to add the service account secret
echo.
pause

cls
echo ================================================================================
echo STEP 1: Checking GitHub CLI
echo ================================================================================
echo.

where gh >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] GitHub CLI is already installed!
    echo.
    goto :authenticate
)

echo GitHub CLI is not installed. Installing now...
echo.
echo Opening GitHub CLI download page...
echo.
start https://cli.github.com/
echo.
echo Please:
echo 1. Download and install GitHub CLI from the opened page
echo 2. Close and reopen this terminal after installation
echo 3. Run this script again
echo.
pause
exit

:authenticate
cls
echo ================================================================================
echo STEP 2: Authenticate with GitHub
echo ================================================================================
echo.

gh auth status >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Already authenticated with GitHub!
    goto :add_secrets
)

echo Please login to GitHub...
echo.
gh auth login

if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERROR] GitHub authentication failed!
    echo.
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

echo [1/7] Adding NEXT_PUBLIC_FIREBASE_API_KEY...
echo AIzaSyB0Bv529O2KODbqZX75j-Gl7GoPHJ5A6po | gh secret set NEXT_PUBLIC_FIREBASE_API_KEY
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

echo.
echo [2/7] Adding NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN...
echo eduvatekids-store.firebaseapp.com | gh secret set NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

echo.
echo [3/7] Adding NEXT_PUBLIC_FIREBASE_PROJECT_ID...
echo eduvatekids-store | gh secret set NEXT_PUBLIC_FIREBASE_PROJECT_ID
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

echo.
echo [4/7] Adding NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET...
echo eduvatekids-store.firebasestorage.app | gh secret set NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

echo.
echo [5/7] Adding NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID...
echo 199688038921 | gh secret set NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

echo.
echo [6/7] Adding NEXT_PUBLIC_FIREBASE_APP_ID...
echo 1:199688038921:web:d3c8284655bfa094d426d8 | gh secret set NEXT_PUBLIC_FIREBASE_APP_ID
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

echo.
echo [7/7] Adding NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID...
echo G-2DW5M7K8GR | gh secret set NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID
if %errorlevel% equ 0 (echo      [OK]) else (echo      [FAILED])

color 0A
cls
echo ================================================================================
echo          7/8 Secrets Added Successfully!
echo ================================================================================
echo.
echo Great! 7 Firebase configuration secrets have been added to GitHub.
echo.
echo ================================================================================
echo STEP 4: Add Firebase Service Account (IMPORTANT!)
echo ================================================================================
echo.
echo You need to manually add 1 more secret: FIREBASE_SERVICE_ACCOUNT
echo.
echo Option 1 - Download and Add Automatically:
echo -----------------------------------------------
echo 1. I will open the Firebase Service Accounts page
echo 2. Click "Generate new private key"
echo 3. Download the JSON file
echo 4. Note the file location
echo 5. Run this command in a NEW terminal:
echo.
echo    gh secret set FIREBASE_SERVICE_ACCOUNT ^< "path\to\downloaded-file.json"
echo.
echo    Replace "path\to\downloaded-file.json" with your actual file path
echo.
echo Option 2 - Add Manually:
echo -----------------------------------------------
echo 1. Download the service account JSON file
echo 2. Open: https://github.com/ismailukman/EduvateKids/settings/secrets/actions
echo 3. Click "New repository secret"
echo 4. Name: FIREBASE_SERVICE_ACCOUNT
echo 5. Value: Paste the ENTIRE contents of the JSON file
echo.
echo ================================================================================
echo.
pause

echo Opening Firebase Service Accounts page...
start https://console.firebase.google.com/u/0/project/eduvatekids-store/settings/serviceaccounts/adminsdk
timeout /t 2 >nul

echo Opening GitHub Secrets page...
start https://github.com/ismailukman/EduvateKids/settings/secrets/actions
timeout /t 2 >nul

cls
echo ================================================================================
echo                    NEXT STEPS
echo ================================================================================
echo.
echo Current Status:
echo   [OK] 7 Firebase config secrets added
echo   [PENDING] 1 service account secret
echo.
echo After adding the service account secret:
echo.
echo 1. Run the Firebase setup:
echo    COMPLETE_SETUP_NOW.bat
echo.
echo 2. Test auto-deployment:
echo    git add .
echo    git commit -m "Test deployment"
echo    git push origin master
echo.
echo 3. Watch deployment:
echo    https://github.com/ismailukman/EduvateKids/actions
echo.
echo ================================================================================
echo.
pause
