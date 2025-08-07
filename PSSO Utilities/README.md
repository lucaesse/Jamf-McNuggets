# PSSO Utilities for Jamf & Entra ID Integration

**PSSO Utilities** is a collection of scripts designed to enhance the integration between **macOS**, **Jamf Pro**, and **Microsoft Entra ID** (formerly Azure AD) using **Platform SSO**.

> Created by [lucaesse](https://github.com/lucaesse)  
> These scripts aim to fill the feature gaps in Platform SSO and improve synchronization and management of Mac devices in Entra ID environments.

---

## 💡 Why PSSO Utilities?

While Apple Platform SSO provides a strong foundation for federated authentication with Entra ID, it **lacks certain automation and user-level synchronization features**. This utility collection addresses those gaps by:

- Automating user profile synchronization
- Fetching and applying Entra ID user photos
- Updating Jamf inventory fields with Entra ID data
- Ensuring better identity consistency across macOS and Entra ID

---

## 🧰 Included Scripts

Each script serves a specific purpose in supporting a seamless Entra ID + Jamf experience. For example:

### 🔹 `macOS User - Entra ID Photo Sync`
Fetches the user's Entra ID profile photo and applies it as the local macOS account picture.

### 🔹 `Jamf Recon - User Data Update`
Populates Jamf computer inventory fields (e.g., job title, office, phone) by querying Entra ID.

> More scripts will be listed here as the utility library grows.

---

## 🖥️ Deployment via Jamf Pro

All scripts are designed to be deployed using **Jamf Pro Policies**

---

## ✅ Requirements

- macOS 12+ with Platform SSO enabled
- Devices enrolled in Jamf Pro
- Microsoft Entra ID (Azure AD)
- Azure App Registration
- Microsoft Graph API permissions (e.g., `User.Read.All`)

---

## 🧾 License

All content is released under the **MIT License**.  
That means you're free to use, modify, and share — just don’t forget to give credit where it's due. 😊

## 🙌 Contributions

Ideas, feedback, and suggestions are always welcome!  
If you find a bug or want to improve something, feel free to open an issue or submit a pull request.

Luca

![visitors](https://visitor-badge.laobi.icu/badge?page_id=lucaesse.Jamf-McNuggets)

<hr>
<p><i>Enjoying the content? Help me stay caffeinated while I try to make stuff ☕</i></p>
        <a href='https://ko-fi.com/N4N11G5OW8' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi6.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
