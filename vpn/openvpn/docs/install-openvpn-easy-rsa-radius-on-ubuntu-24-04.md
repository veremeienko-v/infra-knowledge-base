## 1.	Встановлення OpenVPN та Easy-RSA, Radius плагіна
```bash
sudo apt update
sudo apt install openvpn easy-rsa -y
sudo apt install openvpn-auth-radius
```
## 2.	Створення PKI (сертифікаційного центру)
#За потреби можно збільшити терміни дії сертифікатів (опціонально)
#sudo nano /openvpn-ca /vars
#set_var EASYRSA_CA_EXPIRE 3660 (10 років - CA)
#set_var EASYRSA_CERT_EXPIRE 1825 (5 років - серверний та клієнтські)
```bash
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
./easyrsa init-pki
./easyrsa build-ca nopass
```
## 3.	Налаштування серверного сертифіката
```bash
./easyrsa gen-req server nopass
./easyrsa sign-req server server
```
## 4.	Створити конфіг OpenVPN server.conf (приклад в папці Configs OpenVPN)
Перемістити його в /etc/openvpn/server

## 5.	Преремістити всі сертифікати в /etc/openvpn/server/
```bash
sudo cp /home/vrmnk/openvpn-ca/pki/ca.crt /etc/openvpn/server/
sudo cp /home/vrmnk/openvpn-ca/pki/issued/server.crt /etc/openvpn/server/
sudo cp /home/vrmnk/openvpn-ca/pki/private/server.key /etc/openvpn/server/
sudo cp /home/vrmnk/openvpn-ca/pki/dh.pem /etc/openvpn/server/
```
## 6.	Дати права на файли
```bash
sudo chown root:root /etc/openvpn/server/*
sudo chmod 600 /etc/openvpn/server/*.key
sudo chmod 644 /etc/openvpn/server/*.crt /etc/openvpn/server/dh.pem
```
## 7.	Створити файл конфігурації радіуса /etc/openvpn/radiusplugin.cnf

⚙️ Приклад конфіга [Radius config](../configs/radiusplugin.cnf)

## 8.	Дати прафа на конфіг
```bash
sudo chown root:root /etc/openvpn/radiusplugin.cnf
sudo chmod 600 /etc/openvpn/radiusplugin.cnf
```
## 9.	Створити скрипти для автоматично створення та відгуку сертифікатів
⚙️ Приклад конфігів:
- [Створення *.ovpn файлу та сертифікатів](../scripts/create-user-vpn.sh)
- [Віднук *.ovpn файлу та сертифікатів](../scripts/revoke-user-vpn.sh)

## 10. Зробити їх виконуваними
```bash
chmod +x create_user_vpn.sh
chmod +x revoke_user_vpn.sh
```
## 11. Створити папки для клієнтських конфігів
```bash
mkdir -p ~/openvpn-ca
mkdir -p /etc/openvpn/clients
mkdir -p /etc/openvpn/ccd
```
## 12. Дозволити запуск скрипта без пароля
```bash
sudo visudo
vrmnk ALL=(ALL) NOPASSWD: /home/vrmnk/create_user_vpn.sh
vrmnk ALL=(ALL) NOPASSWD: /home/vrmnk/revoke_user.sh
```
13.	Запустити сервер openvpn та додати до автозапуску
```bash
sudo systemctl enable openvpn-server@server
sudo systemctl start openvpn-server@server
```
