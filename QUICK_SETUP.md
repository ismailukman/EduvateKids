# Quick Setup - 2 Minutes

I've opened these pages for you. Just follow the clicks below:

## Tab 1: Enable Firestore (30 seconds)

**URL:** https://console.firebase.google.com/u/0/project/eduvatekids-store/firestore

**Steps:**
1. Click **"Create Database"**
2. Click **"Production mode"**
3. Select any location (e.g., us-central)
4. Click **"Enable"**

✅ Done!

---

## Tab 2: Add GitHub Secrets (90 seconds)

**URL:** https://github.com/ismailukman/EduvateKids/settings/secrets/actions

For each secret below, click **"New repository secret"**, copy the name and value, then click **"Add secret"**:

### Secret 1
**Name:** `NEXT_PUBLIC_FIREBASE_API_KEY`
**Value:** `AIzaSyB0Bv529O2KODbqZX75j-Gl7GoPHJ5A6po`

### Secret 2
**Name:** `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN`
**Value:** `eduvatekids-store.firebaseapp.com`

### Secret 3
**Name:** `NEXT_PUBLIC_FIREBASE_PROJECT_ID`
**Value:** `eduvatekids-store`

### Secret 4
**Name:** `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET`
**Value:** `eduvatekids-store.firebasestorage.app`

### Secret 5
**Name:** `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID`
**Value:** `199688038921`

### Secret 6
**Name:** `NEXT_PUBLIC_FIREBASE_APP_ID`
**Value:** `1:199688038921:web:d3c8284655bfa094d426d8`

### Secret 7
**Name:** `NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID`
**Value:** `G-2DW5M7K8GR`

### Secret 8
**Name:** `FIREBASE_SERVICE_ACCOUNT`
**Value:**
1. Open: https://console.firebase.google.com/u/0/project/eduvatekids-store/settings/serviceaccounts/adminsdk
2. Click **"Generate new private key"**
3. Download the JSON file
4. Open it in notepad
5. Copy **ALL** the text
6. Paste here

---

## That's It!

After adding these secrets, just push any change to GitHub and your site will automatically deploy to:

**https://eduvatekids-store.web.app**
