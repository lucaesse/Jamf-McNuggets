##############################################
# Created by lucaesse                        #
# https://github.com/lucaesse/Jamf-McNuggets #
##############################################

#!/bin/bash

adminUser="admin" # The name of you admin user account
encryptionKey="123456"  # Encryption key

# Lists of words and suffixes, you can add or modify words
words=(apple banana cherry lion tiger bear shark eagle fox dolphin giraffe elephant rocket bicycle avocado blueberry coconut dragonfruit eggplant grapefruit jackfruit lime peach plum pomegranate rhubarb starfruit)
suffixes=(!lemon .WHITE! -mint !grape .TEA! -ICE! !cookie .ZEBRA! -juice !berry .HONEY! -melon !fruit .SPICE! -nut !cream .SUGAR! -pie !cake .CANDY! -syrup !jam .JELLY! -pudding !tart .CRISP! -sorbet !mousse .FROSTING! -fudge)

# Leet-style substitutions
leet_subs="a4 e3 i1 o0 s5 t7"

# Function to replace letters with numbers (leetify)
leetify() {
    local input="$1"
    local output=""
    for (( i=0; i<${#input}; i++ )); do
        char=${input:$i:1}
        lower=$(echo "$char" | tr '[:upper:]' '[:lower:]')
        replace=$(echo "$leet_subs" | grep -o "$lower[0-9]" | cut -c2)
        if [ -n "$replace" ]; then
            output+="$replace"
        else
            output+="$char"
        fi
    done
    echo "$output"
}

# Generate password
while true; do
    word1=${words[$RANDOM % ${#words[@]}]}
    word2=${words[$RANDOM % ${#words[@]}]}
    suffix=${suffixes[$RANDOM % ${#suffixes[@]}]}
    basePassword="${word1}${word2}${suffix}"
    leetPassword=$(leetify "$basePassword")
    finalPassword=""
    for (( i=0; i<${#leetPassword}; i++ )); do
        char=${leetPassword:$i:1}
        if [[ $((RANDOM % 2)) -eq 0 ]]; then
            char=$(echo "$char" | tr '[:lower:]' '[:upper:]')
        fi
        finalPassword+="$char"
    done
    if [[ ${#finalPassword} -ge 20 ]]; then
        break
    fi
done

# Debug log
echo "Generated password: $finalPassword"

# Change the password
echo "Changing password..."
/usr/bin/dscl . -passwd /Users/$adminUser "$finalPassword"
echo "Password changed."

# Encrypt the password
echo "Encrypting password..."
encryptedPassword=$(echo "$finalPassword" | openssl enc -aes-256-cbc -a -salt -pass pass:"$encryptionKey")
echo "Password encrypted."

# Write the result to a file readable by the EA script
echo "Writing temporary file..."
echo "$encryptedPassword" > /private/var/tmp/encrypted_localadmin_password.txt
echo "Temporary file written."

# Update inventory to send value to EA
echo "Updating Jamf inventory..."
/usr/local/bin/jamf recon
echo "Inventory updated."

echo "Script completed."
