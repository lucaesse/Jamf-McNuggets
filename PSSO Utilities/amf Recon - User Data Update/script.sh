##############################################
# Created by lucaesse                        #
# https://github.com/lucaesse/Jamf-McNuggets #
##############################################
#!/bin/bash

# --- CONFIG -------------------------------------------------------
CLIENT_ID="AZURE-APP-CLIENT-ID"
CLIENT_SECRET="AZURE-APP-CLIENT-SECRET"
TENANT_ID="YOUR-COMPANY-TENAND-ID"
DOMAIN="companydomain.com"
JAMF_BINARY="/usr/local/bin/jamf"

# --- GET LOGGED-IN USER UPN --------------------------------------
LOGGED_USER=$(stat -f%Su /dev/console)

if [[ "$LOGGED_USER" == *"@"* ]]; then
  UPN="$LOGGED_USER"
else
  UPN="${LOGGED_USER}@${DOMAIN}"
fi

SAFE_UPN=$(echo "$UPN" | sed 's/[^a-zA-Z0-9]/_/g')  # Normalize for filenames

# --- GET ACCESS TOKEN ---------------------------------------------
TOKEN=$(curl -s -X POST \
  "https://login.microsoftonline.com/${TENANT_ID}/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" \
  -d "scope=https://graph.microsoft.com/.default" | jq -r '.access_token')

[[ -z "$TOKEN" || "$TOKEN" == "null" ]] && { echo "[ERROR] Unable to get access token."; exit 1; }

# --- GET USER INFO -----------------------------------------------
USER_DATA=$(curl -s -G \
  "https://graph.microsoft.com/v1.0/users/${UPN}" \
  --data-urlencode "\$select=officeLocation,jobTitle,businessPhones" \
  -H "Authorization: Bearer ${TOKEN}")

OFFICE_LOCATION=$(echo "$USER_DATA" | jq -r '.officeLocation')
JOB_TITLE=$(echo "$USER_DATA" | jq -r '.jobTitle')
BUSINESS_PHONE=$(echo "$USER_DATA" | jq -r '.businessPhones[0]')

# --- LOG VALUES --------------------------------------------------
echo "[INFO] Office location: ${OFFICE_LOCATION:-Not set}"
echo "[INFO] Job title:        ${JOB_TITLE:-Not set}"
echo "[INFO] Business phone:   ${BUSINESS_PHONE:-Not set}"

# --- UPDATE JAMF COMPUTER RECORD ---------------------------------
"$JAMF_BINARY" recon \
  -room "$OFFICE_LOCATION" \
  -position "$JOB_TITLE" \
  -phone "$BUSINESS_PHONE"
