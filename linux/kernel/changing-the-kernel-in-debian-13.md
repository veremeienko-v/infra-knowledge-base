1. Подивитись список всіх встановлених ядер
```bash
grep -E "menuentry | submenu" /boot/grub/grub.cfg
```
2. Відредагувати файл, додати індефікатор потрібного ядра
```bash
nano /etc/default/grub
```
3. ℹ️ Для прикладу, назву беріть з:
```bash
grep -E "menuentry | submenu" /boot/grub/grub.cfg
```
> GRUB_DEFAULT="Advanced options for Debian GNU/Linux>Debian GNU/Linux, with Linux 6.12.73+deb13-amd64"

5. Застосувати зміни
```bash
sudo update-grub
```
