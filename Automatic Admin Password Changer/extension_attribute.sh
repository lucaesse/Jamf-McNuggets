##############################################
# Created by lucaesse                        #
# https://github.com/lucaesse/Jamf-McNuggets #
##############################################
#!/bin/bash

# Path to the encrypted file
file="/Library/Application Support/Jamf/encrypted_localadmin_password.txt"
key="123456"  # Encryption key

# Check if the file exists and contains data
if [ -f "$file" ] && [ -s "$file" ]; then
    encrypted=$(cat "$file")
    # Decrypt the password
    decrypted=$(echo "$encrypted" | openssl enc -aes-256-cbc -a -d -salt -pass pass:"$key" 2>/dev/null)
    if [ -n "$decrypted" ]; then
        echo "<result>$decrypted</result>"
    else
        echo "<result>Decryption Failed</result>"
    fi
else
    echo "<result>Not Set</result>"
fi
