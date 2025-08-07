# Jamf-McNuggets: Auto-Update Jamf Computer Info from Microsoft Entra ID

This script automatically updates the Jamf computer record with the user's **office location**, **job title**, and **business phone number** by querying Microsoft Graph API using the logged-in user's UPN.

> Created by [lucaesse](https://github.com/lucaesse)  
> Inspired by the need to bridge the gap between Microsoft Entra ID (Azure AD) and Jamf Pro.

---

## 🔧 What It Does

- Detects the currently logged-in user on macOS.
- Constructs their UPN (User Principal Name) using your domain if needed.
- Requests an access token from Microsoft Entra ID using a registered app (client credentials flow).
- Queries Microsoft Graph for:
  - `officeLocation`
  - `jobTitle`
  - `businessPhones`
- Updates the Jamf computer inventory with this information using the `jamf recon` command.

---

## 🚀 Requirements

- Valid Azure AD app registration with:
  - `client_id`
  - `client_secret`
  - `tenant_id`
- The app must have permissions to read user profiles:
  - `User.Read.All` (application-level)

---

## ⚙️ Configuration

Edit the following values at the top of the script:

```bash
CLIENT_ID="AZURE-APP-CLIENT-ID"
CLIENT_SECRET="AZURE-APP-CLIENT-SECRET"
TENANT_ID="YOUR-COMPANY-TENANT-ID"
DOMAIN="companydomain.com"
```

---

## 🖥️ Deployment via Jamf

> **⚠️ This script must be deployed on macOS devices using a Jamf Pro Policy.**

### Recommended Policy Settings:
- **Trigger:** At login, recurring check-in or manual if you want to run it at a specific time (e.g. during an onboarding script)
- **Frequency:** Ongoing or the option that best suits your needs

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

