#!/bin/bash

USERNAME="$1"
EASYRSA_DIR="/home/vrmnk/openvpn-ca"
CLIENTS_DIR="/etc/openvpn/clients"

if [ -z "$USERNAME" ]; then
    echo "Usage: $0 username"
    exit 1
fi

cd "$EASYRSA_DIR" || exit 1

# 🔎 Перевірка чи сертифікат уже існує
if [ -f "pki/issued/$USERNAME.crt" ]; then
    echo "⚠ Certificate already exists for $USERNAME — skipping creation"
    exit 0
fi

rm -f pki/reqs/$USERNAME.req
rm -f pki/private/$USERNAME.key
rm -f pki/issued/$USERNAME.crt

echo "🔐 Generating certificate for $USERNAME..."

./easyrsa --batch build-client-full "$USERNAME" nopass

mkdir -p "$CLIENTS_DIR"

cat > "$CLIENTS_DIR/$USERNAME.ovpn" <<EOF
client
dev tun
proto udp
remote 192.168.10.4 1194
# pull
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth-user-pass
cipher AES-256-GCM
verb 3

<ca>
$(cat pki/ca.crt)
</ca>

<cert>
$(cat pki/issued/$USERNAME.crt)
</cert>

<key>
$(cat pki/private/$USERNAME.key)
</key>
EOF

echo "✅ Config created: $CLIENTS_DIR/$USERNAME.ovpn"
