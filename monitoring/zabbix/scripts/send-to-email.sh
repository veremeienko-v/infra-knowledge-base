#!/bin/bash

TO=$1
SUBJECT=$2
BODY=$3

TENANT="ТУТ_TENANT_ID"
CLIENT_ID="ТУТ_CLIENT_ID"
CLIENT_SECRET="ТУТ_SECRET"
SENDER="alert@yourdomain.com"

TOKEN=$(curl -s -X POST https://login.microsoftonline.com/$TENANT/oauth2/v2.0/token \
 -d "client_id=$CLIENT_ID" \
 -d "client_secret=$CLIENT_SECRET" \
 -d "scope=https://graph.microsoft.com/.default" \
 -d "grant_type=client_credentials" | jq -r .access_token)

curl -s -X POST https://graph.microsoft.com/v1.0/users/$SENDER/sendMail \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d "{
  \"message\": {
    \"subject\": \"$SUBJECT\",
    \"body\": {
      \"contentType\": \"Text\",
      \"content\": \"$BODY\"
    },
    \"toRecipients\": [{
      \"emailAddress\": {\"address\": \"$TO\"}
    }]
  }
 }"
