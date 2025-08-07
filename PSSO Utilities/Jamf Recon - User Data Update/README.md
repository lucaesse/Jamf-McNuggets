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
