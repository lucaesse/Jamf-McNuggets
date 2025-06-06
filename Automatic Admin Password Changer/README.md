# Jamf Automatic Admin Password Generator

This script is designed to **generate a secure random password**, **assign it to a local admin account** on macOS, **encrypt it**, and **store it temporarily** so it can be retrieved by a Jamf Pro Extension Attribute (EA). It also triggers a Jamf inventory update to report the new encrypted password.

## ✨ Features

- Randomly generates strong passwords using two words and a creative suffix
- Applies leet-style substitutions for enhanced complexity
- Randomly mixes uppercase and lowercase letters
- Ensures password length is at least 20 characters
- Updates the local admin password
- Encrypts the password using AES-256-CBC
- Saves the encrypted password to a temporary file for EA retrieval
- Sends a `jamf recon` to update inventory in Jamf Pro

## 🔧 Configuration (script.sh)

### Variables
- `adminUser`: The local admin account to update (default: `admin`)
- `encryptionKey`: Custom encryption key used to encrypt the generated password

Make sure to **replace the `encryptionKey`** with a secure, private key known only to your environment.

## 📂 Output

- Encrypted password is saved to:  
  `/private/var/tmp/encrypted_localadmin_password.txt`

Use a custom Extension Attribute in Jamf Pro to read this file and report the encrypted password to the Jamf console.

## 🧩 Decryption Extension Attribute

If you want to **decrypt the password inside Jamf Pro**, you can configure a second **Extension Attribute** with the extension_attribute.sh script.

⚠️ **Caution:** This will expose the password in plaintext in Jamf Pro. Restrict access using Jamf's RBAC settings.

## 🖥️ Usage

1. Deploy the script to your macOS devices using a Jamf policy.
2. Ensure the `admin` user exists.
3. After execution, the script will:
   - Rotate the password
   - Encrypt and store it temporarily
   - Trigger an inventory update (`jamf recon`)

## 🔐 Security Notes

- The encryption key should be stored securely and rotated periodically.
- Run the script via a Jamf policy (e.g., weekly) to ensure regular password rotation.
- Ensure that the temporary file is read only by authorized scripts or tools.

## 📜 License

MIT License

---

Created by lucaesse
