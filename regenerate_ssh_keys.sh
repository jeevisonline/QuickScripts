#!/bin/bash

# Path to the SSH key directory
KEY_DIR="/etc/ssh"

# Check each type of key, and generate it if it's not present
for key_type in rsa dsa ecdsa ed25519; do
    key_file="$KEY_DIR/ssh_host_${key_type}_key"
    if [ ! -f "$key_file" ]; then
        ssh-keygen -t $key_type -f $key_file -N ''
    fi
done

# Restart SSH service
systemctl restart ssh

# Remove the script from startup
update-rc.d -f regenerate_ssh_keys.sh remove

# Delete the script
rm -- "$0"
