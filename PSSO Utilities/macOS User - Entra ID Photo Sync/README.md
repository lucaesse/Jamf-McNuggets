# macOS User – Entra ID Photo Sync

This script syncs the Microsoft Entra ID (Azure AD) **profile picture** of a user to their **local macOS user account**. It supports various username formats and uses the Microsoft Graph API to fetch and apply the photo.

> Created by [lucaesse](https://github.com/lucaesse)  
---

## 📸 What It Does

- Detects the logged-in user on macOS
- Resolves the appropriate UPN (User Principal Name) from the local account name
- Authenticates with Microsoft Graph using `client_credentials`
- Downloads the user's profile photo from Entra ID (if available)
- Saves the photo to a local directory
- Copies the photo to a permanent location
- Resizes the photo and sets it as the user's account picture using `dscl`

---

## 💡 Supported Username Formats

This script works with:

- Local short name (e.g., `jdoe`)
- Short name with domain suffix (e.g., `jdoecompanydomain.com`)
- Full UPN (e.g., `jdoe@companydomain.com`)

---

## ⚙️ Configuration

At the top of the script, update the following variables with your Azure app and domain info:

```bash
CLIENT_ID="AZURE-APP-CLIENT-ID"
CLIENT_SECRET="AZURE-APP-CLIENT-SECRET"
TENANT_ID="YOUR-COMPANY-TENANT-ID"
DOMAIN="companydomain.com"
```

Other paths can be customized as needed:

```bash
PHOTO_DIR="/Library/Application Support/Jamf/EntraIDPhotoSync"
```

---

## ✅ Requirements

- [`sips`](https://ss64.com/osx/sips.html) for image resizing (included in macOS)
- Valid Azure AD App Registration with:
  - `User.Read.All` Graph API permission (application-level)
- The script must be run as **root** (e.g., via Jamf)

---

## 🖥️ Deployment via Jamf

> **⚠️ This script must be deployed on macOS devices using a Jamf Pro Policy.**

### Recommended Policy Settings:
- **Trigger:** At login or recurring check-in
- **Frequency:** Ongoing

---

## 📦 How It Works (Behind the Scenes)

1. Resolve UPN from the logged-in user
2. Get a Graph API token via client credentials
3. Check if a photo is present in Entra ID
4. Compare current ETag with the last saved to avoid re-downloading unchanged images
5. Download and save the photo locally
6. Copy it to a system directory
7. Resize to 128x128 and apply it using `dscl` as the macOS user picture

---

## 🧪 Example Output

```bash
[INFO] Logged-in user (short name): jdoe
[INFO] Resolved UPN for Graph: jdoe@companydomain.com
[SUCCESS] Photo saved to: /Library/Application Support/Jamf/EntraIDPhotoSync/jdoe_companydomain_com.jpg
[SUCCESS] JPEGPhoto updated for jdoe
```

---

## 📜 License

MIT License

---

Created by lucaesse <br /><br />
<img src="https://img.shields.io/badge/macOS-383838?logo=apple&logoColor=white" alt="macOS">
<img src="https://img.shields.io/badge/Shell_Script-%23121011.svg?logo=gnu-bash&logoColor=white" alt="Shell Script">
<img src="https://img.shields.io/badge/Jamf-002163?logo=devbox&logoColor=white" alt="Jamf">
![visitors](https://visitor-badge.laobi.icu/badge?page_id=lucaesse.Jamf-McNuggets)

<hr>
<p><i>Enjoying the content? Help me stay caffeinated while I try to make stuff ☕</i></p>
        <a href='https://ko-fi.com/N4N11G5OW8' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi6.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
