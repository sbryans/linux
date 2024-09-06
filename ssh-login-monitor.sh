# /usr/local/bin/ssh-login-monitor.sh

#!/bin/bash

WEBHOOK_URL="https://discord.com/api/webhooks/<YOUR_GENERATED_ID>"

# Function to send webhook
send_webhook() {
    local user="$1"
    local id="$2"
    # Immediately firing will produce false positives.
    sleep 2
    recent_user=$(last -n 1 | awk '{print $1}' | head -n 1)
    if [ -z "$recent_user" ]; then
        recent_user="unknown"
    fi
    # Webhook payload (Designed for Discord)
    payload=$(cat <<EOF
{
  "content": "User ($recent_user) From: $user has logged into the server. ID: $id"
}
EOF
    )
    curl -X POST -H "Content-Type: application/json" -d "$payload" "$WEBHOOK_URL"
}
tail -F /var/log/auth.log | while read -r line; do
    if echo "$line" | grep -q "Accepted"; then
        user=$(echo "$line" | awk '{print $9}')
        ip=$(echo "$line" | awk '{print $11}')
        send_webhook "$user" "$ip"
    fi
done

