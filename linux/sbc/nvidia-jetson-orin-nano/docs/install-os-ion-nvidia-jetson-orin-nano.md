## Інсталяція ОС на Nvidia Jetson Orin Nano Super Developer Kit

1. Завантажити образ ОС з https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/jp62-orin-nano-sd-card-image.zip
2. Записати на SD карту за допомогою Rufus або будь яким іншим ПО
3. Вставити SD карту в Jetson Orin Nano, підключити монітор, клавіатуру та мишу
4. При підключенні живлення на пристрій зазвичай автоматично відбудеться завантаження з SD карти, провести стандартне початкове налаштування системи
5. Для переносу ОС з SD карти на SSD:
  - клонуємо Git репозиторій
    ```bash 
		sudo git clone https://github.com/jetsonhacks/migrate-jetson-to-ssd
    ```
  - переходимо в папку репозиторію
    ```bash
		cd migrate-jetson-to-ssd
    ```
  - копіювання структури розділів
    ```bash
		sudo bash make_partitions.sh
    ```
  - копіювання данних розділів
    ```bash
		sudo bash copy_partitions.sh
    ```
  - налаштування завантаження з SSD
    ```bash
		sudo bash configure_ssd_boot.sh
    ```
6. Після цього можно вимкнути пристрій, вийняти SD карту та ввімкнути знову пристрій, завантаження вже відбудеться з SSD диска.
