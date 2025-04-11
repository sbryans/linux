#!/bin/bash
# Pass ipv4 list file as argument.
if [ -z "$1" ]; then
    echo "Usage: $0 your_file_with_local_ipv4s"
    exit 1
fi
IP_FILE="$1"
if [ ! -f "$IP_FILE" ]; then
    echo "Error: File '$IP_FILE' not found."
    exit 1
fi
while IFS= read -r IP; do
    if [[ -z "$IP" || "$IP" =~ ^# ]]; then
        continue
    fi
    CERT_FILE="/usr/local/share/ca-certificates/${IP}.crt"
    echo "Fetching certificate from ${IP}..."
    openssl s_client -connect "${IP}":443 -showcerts </dev/null | openssl x509 -outform PEM > "${CERT_FILE}"
    if [ $? -eq 0 ]; then
        echo "Certificate saved as ${CERT_FILE}"
    else
        echo "Oops... couldn't get the certificate from ${IP}. Maybe you're missing the port number."
        continue
    fi
done < "$IP_FILE"
echo "Updating CA certificates..."
sudo /usr/sbin/update-ca-certificates
echo "All done! Kill your browser and try visiting a local ip that leverages TLS."
