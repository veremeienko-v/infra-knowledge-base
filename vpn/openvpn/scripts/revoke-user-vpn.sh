#!/bin/bash

USERNAME="$1"

if [ -z "$USERNAME" ]; then
    echo "Usage: $0 username"
    exit 1
fi

PKI_DIR=/home/vrmnk/openvpn-ca
CLIENTS_DIR=/etc/openvpn/clients
CCD_DIR=/etc/openvpn/ccd

cd "$PKI_DIR" || exit 1

echo "🔐 Revoking certificate for $USERNAME..."

# Перевірка чи сертифікат існує
if [ -f "pki/issued/$USERNAME.crt" ]; then
    ./easyrsa --batch revoke "$USERNAME"
    ./easyrsa gen-crl

    # Копіюємо CRL у папку OpenVPN
    cp pki/crl.pem /etc/openvpn/crl.pem
    chmod 644 /etc/openvpn/crl.pem

    echo "✅ Certificate revoked"
else
    echo "⚠️ Certificate not found — skipping revoke"
fi

echo "🧹 Removing config files..."

# Видалення ovpn
rm -f "$CLIENTS_DIR/$USERNAME.ovpn"

# Видалення CCD файлу користувача (ВАЖЛИВО — файл, не папка!)
rm -f "$CCD_DIR/$USERNAME"

echo "✅ Cleanup complete"
