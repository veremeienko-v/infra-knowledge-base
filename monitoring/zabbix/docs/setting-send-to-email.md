# Zabbix + Microsoft 365 OAuth2 налаштування пошти

## КРОК 1. Отримати токен (НА СЕРВЕРІ)
👉 Підключись до сервера з Zabbix:
```bash
ssh user@your-server
```

📥 Встав команду:
```bash
curl -X POST https://login.microsoftonline.com/TENANT_ID/oauth2/v2.0/token \
 -d "client_id=CLIENT_ID" \
 -d "client_secret=CLIENT_SECRET" \
 -d "scope=https://graph.microsoft.com/.default" \
 -d "grant_type=client_credentials"
```

🔑 Замінити:
- TENANT_ID → твій tenant ID 
- CLIENT_ID → client ID 
- CLIENT_SECRET → secret 

📤 Результат:
Отримаєш:
access_token
👉 якщо є токен — все ок

## КРОК 2. Перевірити відправку листа
👉 Встав (на сервері):
```bash
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
```
👉 Якщо лист прийшов — все налаштовано правильно

## КРОК 3. Створити скрипт
На сервері:
```bash
nano /usr/lib/zabbix/alertscripts/send-mail-oauth.sh
```
📌 Дати права:
```bash
chmod +x /usr/lib/zabbix/alertscripts/send-mail-oauth.sh
```
## КРОК 4. Підключити в Zabbix
У веб-інтерфейсі Zabbix:
📍 Куди:
Media types → Create media type

📥 Заповни:
- Type: Script 
- Script name: 
send-mail-oauth.sh
- Parameters: 
{ALERT.SENDTO}
{ALERT.SUBJECT}
{ALERT.MESSAGE}

## КРОК 5. Додати ACTION (це дуже важливо)
Йди сюди:
Alerts → Actions → Trigger actions
Відкрий існуючий або створи новий:
Перейди на кладку:
📌 Operations:
- Operations → вибери юзерів чи групу та додай:
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

- Recovery operations
Subject: 
✅ RECOVERY: {TRIGGER.NAME}
Message: 
Host: {HOST.NAME}
Time: {EVENT.RECOVERY.DATE} {EVENT.RECOVERY.TIME}
Duration: {EVENT.AGE}

- Update operations
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

## КРОК 6. Додати користувачу email
Administration → Users → Admin → Media
- Type: Script 
- Send to: твій email 

## КРОК 7. Тест
- у Media type → Test 
- або тригер у Zabbix

