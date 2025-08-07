##################################################
# Created by lucaesse                            #
# https://github.com/lucaesse/Jamf-McNuggets     #
#  Works for:                                    #
#  - local short name                            #
#  - local short name with “@domain”             #
#  - local name without @ but with domain suffix #
#  - explicit UPN already matching Entra ID      #
##################################################
#!/bin/bash

# === CONFIGURATION ==================================================
CLIENT_ID="AZURE-APP-CLIENT-ID"
CLIENT_SECRET="AZURE-APP-CLIENT-SECRET"
TENANT_ID="YOUR-COMPANY-TENAND-ID"
DOMAIN="companydomain.com"
PHOTO_DIR="/Library/Application Support/Jamf/EntraIDPhotoSync"
PERM_PHOTO_DIR="/Library/User Pictures"
# -------------------------------------------------------------
# === GET LOGGED-IN USER =============================================
LOGGED_USER=$(stat -f%Su /dev/console)
echo "[INFO] Logged-in user (short name): $LOGGED_USER"

# === DETERMINE UPN ====================================================
# 1) if the local name already contains “@” we take it like this
if [[ "$LOGGED_USER" == *"@"* ]]; then
    UPN="$LOGGED_USER"
else
    # 2) if it ends with the domain without the “@” → we add the @ sign
    if [[ "$LOGGED_USER" == *"$DOMAIN" ]]; then
        CLEAN_USER=${LOGGED_USER%$DOMAIN}
        UPN="${CLEAN_USER}@${DOMAIN}"
    else
        # 3) normal short name → user@domain
        UPN="${LOGGED_USER}@${DOMAIN}"
    fi
fi
echo "[INFO] Resolved UPN for Graph: $UPN"

# === FILE NAMES ======================================================
SAFE_UPN=$(echo "$UPN" | sed 's/[^a-zA-Z0-9]/_/g')
PHOTO_FILE="$PHOTO_DIR/${SAFE_UPN}.jpg"
ETAG_FILE="$PHOTO_DIR/${SAFE_UPN}.etag"
mkdir -p "$PHOTO_DIR"

# === GET ACCESS TOKEN ===============================================
TOKEN=$(curl -s -X POST \
  "https://login.microsoftonline.com/${TENANT_ID}/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" \
  -d "scope=https://graph.microsoft.com/.default" | jq -r '.access_token')

[[ -z "$TOKEN" || "$TOKEN" == "null" ]] && { echo "[ERROR] Cannot get token"; exit 1; }

# === CHECK CURRENT PHOTO ETag =======================================
CURRENT_ETAG=$(curl -s \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://graph.microsoft.com/v1.0/users/${UPN}/photo" | jq -r '."@odata.mediaEtag"')

[[ "$CURRENT_ETAG" == "null" ]] && { echo "[INFO] No photo in Entra ID"; exit 0; }

if [[ -f "$ETAG_FILE" ]]; then
    PREV_ETAG=$(cat "$ETAG_FILE")
    [[ "$CURRENT_ETAG" == "$PREV_ETAG" ]] && { echo "[INFO] Photo unchanged"; exit 0; }
fi

# === DOWNLOAD PROFILE PHOTO =========================================
curl -s -L \
  -H "Authorization: Bearer ${TOKEN}" \
  "https://graph.microsoft.com/v1.0/users/${UPN}/photo/\$value" \
  --output "$PHOTO_FILE"

[[ ! -s "$PHOTO_FILE" ]] && { echo "[ERROR] Downloaded file empty"; exit 1; }

echo "$CURRENT_ETAG" > "$ETAG_FILE"
echo "[SUCCESS] Photo saved to: $PHOTO_FILE"

# === COPY TO PERMANENT LOCATION =====================================
PERM_PHOTO_FILE="${PERM_PHOTO_DIR}/${LOGGED_USER}.jpg"
sudo mkdir -p "$PERM_PHOTO_DIR"
sudo cp "$PHOTO_FILE" "$PERM_PHOTO_FILE"
sudo chmod 644 "$PERM_PHOTO_FILE"

# === SET ACCOUNT PICTURE (modern way) ===============================
TEMP_TIFF="/tmp/${LOGGED_USER}_128.tiff"
sips -Z 128 "$PERM_PHOTO_FILE" --out "$TEMP_TIFF" >/dev/null 2>&1 || {
    echo "[ERROR] Cannot resize image"; exit 1
}

sudo dscl . -create "/Users/$LOGGED_USER" JPEGPhoto "$(base64 < "$TEMP_TIFF")" && \
    echo "[SUCCESS] JPEGPhoto updated for $LOGGED_USER" || \
    echo "[ERROR] Failed to set JPEGPhoto"

# Optional: keep path attribute for legacy
sudo dscl . -create "/Users/$LOGGED_USER" picture "$PERM_PHOTO_FILE"

rm -f "$TEMP_TIFF"
exit 0
