# По даному керівництву ви зможете встановити UOS Server на Ubuntu 24.04 

## 1. Оновлюємо ОС та встановлюємо ПО podman
```bash
sudo apt update && sudo apt install -y podman slirp4netns
```
## 2. Додаємо до автозапуску
```bash
sudo systemctl enable podman
```
## 3. Запускаємо podman
```bash
sudo systemctl start podman
```
## 4. Завантажуємо скрипт інсталяції Unifi OS Server
> ℹ️ На момент завантаження, перевірте чи не вийшла нова версія UOS Server
```bash
wget -O unifi-os-server.run https://fw-download.ubnt.com/data/unifi-os-server/1856-linux-x64-5.0.6-33f4990f-6c68-4e72-9d9c-477496c22450.6-x64
```
## 5. Даємо права на запуск
```bash
sudo chmod +x unifi-os-server.run
```
## 6. Запускаємо скрипт
```bash
sudo ./unifi-os-server.run
```
## 7. Готово. Можно заходити в Web інтерфейс та конфігурувати Wi-Fi точки доступу 
