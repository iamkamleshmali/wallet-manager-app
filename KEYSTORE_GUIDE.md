# Keystore Setup & Consistent Package Signing Guide

## Why Consistent Keystore Signing is Critical for OTA Updates
When Android installs an APK update over an existing installed app, Android's Package Manager strictly verifies:
1. **Application ID match** (`com.kamlesh.moneymanager`)
2. **Package Signature match** (Certificate SHA-256 fingerprint)

If the update APK was signed with a different key or debug keystore:
- Android will reject the update with `INSTALL_FAILED_UPDATE_INCOMPATIBLE` ("App not installed as package appears to be invalid or conflicts with existing package").
- The user would be forced to manually uninstall the app, wiping out local SQLite data.

By establishing a permanent release keystore and signing every GitHub Actions release build with the same key, **OTA In-App Force-Updates install directly and seamlessly with zero data loss**.

---

## 1. How to Generate Your Release Keystore

Run the following command in terminal:

### On Windows (PowerShell / Command Prompt):
```powershell
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### On macOS / Linux:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You will be prompted to enter a password and organization information. **Keep note of your password and alias (`upload`)!**

---

## 2. Configure `android/key.properties` for Local Builds

Create a file named `android/key.properties` (this file is git-ignored for security):

```properties
storePassword=YourKeystorePassword
keyPassword=YourKeyPassword
keyAlias=upload
storeFile=upload-keystore.jks
```

Place `upload-keystore.jks` inside `android/app/`.

---

## 3. Configure GitHub Actions Secrets for Automated Releases

To sign release APKs automatically in GitHub Actions CI:
1. Convert your keystore file to Base64:
   ```bash
   base64 -w 0 android/app/upload-keystore.jks
   ```
   *(On Windows PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/upload-keystore.jks")) | Set-Clipboard`)*
2. In your GitHub repository, navigate to **Settings > Secrets and variables > Actions**.
3. Add the following repository secrets:
   - `KEYSTORE_BASE64`: The full base64 string copied above
   - `KEYSTORE_PASSWORD`: Your keystore password
   - `KEY_PASSWORD`: Your key password
   - `KEY_ALIAS`: `upload`
