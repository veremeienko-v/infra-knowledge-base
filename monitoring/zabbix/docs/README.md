Zabbix + Microsoft 365 OAuth2 налаштування пошти

🔵 КРОК 1. Створити додаток (в браузері)
Йди в 👉 Microsoft Entra ID
📍 Куди клікати:
App registrations → New registration
📥 Що вводити:
•	Name: Zabbix Mail 
•	Supported account types: Single tenant 
👉 Натисни Register
________________________________________
📌 Після створення скопіюй:
З головної сторінки:
•	Application (client) ID 
•	Directory (tenant) ID 
👉 Збережи їх (будуть потрібні)
________________________________________
🔵 КРОК 2. Дати доступ на відправку пошти
📍 Куди клікати:
API permissions → Add a permission
📥 Обрати:
•	Microsoft Graph 
•	Application permissions 
•	знайти → Mail.Send 
👉 Додати
________________________________________
❗ ОБОВ’ЯЗКОВО
Натисни:
👉 “Надати згоду адміністратора” (Grant admin consent)
✔ Статус має стати:
Granted
________________________________________
🔵 КРОК 3. Створити секрет (пароль для додатку)
📍 Куди:
Certificates & secrets → New client secret
📥 Що робити:
•	Description: zabbix 
•	Expires: будь-який термін 
👉 Натисни Create
________________________________________
❗ ВАЖЛИВО
Скопіюй:
👉 Value (значення секрета)
(потім його не покажуть)
________________________________________
🔵 КРОК 4. Перевірити поштову скриньку
У Microsoft 365 має бути:
•	user: alert@yourdomain.com 
•	з ліцензією Exchange 
________________________________________
🔵 КРОК 5. Отримати токен (НА СЕРВЕРІ)
👉 Підключись до сервера з Zabbix:
ssh user@your-server
________________________________________
📥 Встав команду:
curl -X POST https://login.microsoftonline.com/TENANT_ID/oauth2/v2.0/token \
 -d "client_id=CLIENT_ID" \
 -d "client_secret=CLIENT_SECRET" \
 -d "scope=https://graph.microsoft.com/.default" \
 -d "grant_type=client_credentials"
________________________________________
🔑 Замінити:
•	TENANT_ID → твій tenant ID 
•	CLIENT_ID → client ID 
•	CLIENT_SECRET → secret 
________________________________________
📤 Результат:
Отримаєш:
access_token
👉 якщо є токен — все ок
________________________________________
🔵 КРОК 6. Перевірити відправку листа
👉 Встав (на сервері):
curl -X POST https://graph.microsoft.com/v1.0/users/alert@yourdomain.com/sendMail \
 -H "Authorization: Bearer ТВОЙ_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{
  "message": {
    "subject": "Test Zabbix",
    "body": {
      "contentType": "Text",
      "content": "Hello from test"
    },
    "toRecipients": [
      {
        "emailAddress": {
          "address": "твоя_пошта@gmail.com"
        }
      }
    ]
  }
 }'
👉 Якщо лист прийшов — все налаштовано правильно
________________________________________
🔵 КРОК 7. Створити скрипт
На сервері:
nano /usr/lib/zabbix/alertscripts/send_mail_oauth.sh
________________________________________
📜 Встав код:
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
________________________________________
📌 Дати права:
chmod +x /usr/lib/zabbix/alertscripts/send_mail_oauth.sh
________________________________________
🔵 КРОК 8. Підключити в Zabbix
У веб-інтерфейсі Zabbix:
📍 Куди:
Administration → Media types → Create media type
________________________________________
📥 Заповни:
•	Type: Script 
•	Script name: 
send_mail_oauth.sh
•	Parameters: 
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}
________________________________________
🔵 КРОК 9. Додати ACTION (це дуже важливо)
Йди сюди:
Alerts → Actions → Trigger actions
Відкрий існуючий або створи новий:
Перейди на кладку:
📌 Operations:
•	Operations → вибери юзерів чи групу та додай:
Subject: 
🚨 PROBLEM: {TRIGGER.NAME}
Message: 
Problem: {TRIGGER.NAME}
Host: {HOST.NAME}
IP: {HOST.IP}
Severity: {TRIGGER.SEVERITY}
Time: {EVENT.DATE} {EVENT.TIME}
Last value:
{ITEM.LASTVALUE}
Description:
{TRIGGER.DESCRIPTION}
Event ID: {EVENT.ID} 

•	Recovery operations
Subject: 
✅ RECOVERY: {TRIGGER.NAME}
Message: 
Host: {HOST.NAME}
Time: {EVENT.RECOVERY.DATE} {EVENT.RECOVERY.TIME}
Duration: {EVENT.AGE}

•	Update operations
Subject: 
🛠 ACKNOWLEDGED: {TRIGGER.NAME}
Message: 
Інцидент підтверджено.
Trigger: {TRIGGER.NAME}
Host: {HOST.NAME}
Severity: {TRIGGER.SEVERITY}
Acknowledged by: {USER.FULLNAME}
Time: {EVENT.UPDATE.DATE} {EVENT.UPDATE.TIME}
Comment:
{EVENT.UPDATE.COMMENT}
________________________________________
🔵 КРОК 10. Додати користувачу email
Administration → Users → Admin → Media
•	Type: Script 
•	Send to: твій email 
________________________________________
🧪 КРОК 11. Тест
•	у Media type → Test 
•	або тригер у Zabbix

