## Налаштування Dual WAN (Active-Backup)

Скопіювати скрипти [ISP1](../scripts/dhcp-recursive-isp-1) [ISP2](../scripts/dhcp-recursive-isp-2) [ISP3](../scripts/dhcp-recursive-isp-3), до DHCP клієнтів в мікротіку (в данному прикладі розглядаєть підключеня 3-х провайдерів), необхідно вимкнути маршрути за замовчуванням. Скрипт автоматично додає та видаляє необхідні маршрути та правило маскарадинга.
На іншому DHCP Client додаємо все теж саме, але змінюємо 9.9.9.9 наприклад на 8.8.8.8, distance в рекурсивних маршрутах залишаємо 1, в маршрутах за замовчування distance ставимо по пріорітету провайдера.

Далі в таблицю маршрутизації, додаємо правила для балансування між провайдерами (на приклад один vlan ходить через одного провайдера, інший vlan, через другого провайдера, провайдерів може бути і більше, все робиться по аналогію до прикладу).

Спочатку додамо правило, щоб локальний трафік ходим через таблицю main (не додавши це правило втратиться зв'язок з маршрутизатором в подальшому):
```rsc
/routing rule
add dst-address=192.168.10.0/24 table=main
```
Вище написане правило для прикладу, відповідно якщо у вас декілька підмереж, додаємо всі інші по аналогії.

Далі створюємо таблиці (для прикладу 2, але може бути і більше в залежності від вашого завдання):
```rsc
/routing table
add name=to_ISP1 fib
add name=to_ISP2 fib
```
Після цього додаємо свої підмережі до вище створених таблиць (всі підмережі вказані для прикладу):
```rsc
/routing rule
add src-address=192.168.10.0/24 action=lookup table=to_ISP1
add src-address=192.168.20.0/24 action=lookup table=to_ISP2
```
Останнім шагом буде додавання маршрутів за замовчування (в прикладі ми маємо три ISP та два vlan, все налаштовано, через рекурсивну маршрутизацію, маршрути до шлюзів провайдерів ми додали через скрип в DHCP сервери, вони створюються автоматично разом з правилами маскарада):

```rsc
/ip route 
add check-gateway=ping comment="Route vlan10 via ISP-1" distance=1 \
        gateway=8.8.8.8 routing-table=to_ISP1 target-scope=11
add check-gateway=ping comment="Route vlan10 via ISP-1" distance=2 \
        gateway=1.1.1.1 routing-table=to_ISP1 target-scope=11
add check-gateway=ping comment="Route vlan10 via ISP-1" distance=3 \
        gateway=9.9.9.9 routing-table=to_ISP1 target-scope=11


/ip route
add check-gateway=ping comment="Route vlan20 via ISP-2" distance=1 \
        gateway=1.1.1.1 routing-table=to_ISP2 target-scope=11
add check-gateway=ping comment="Route vlan20 via ISP-2" distance=2 \
        gateway=8.8.8.8 routing-table=to_ISP2 target-scope=11
add check-gateway=ping comment="Route vlan20 via ISP-2" distance=3 \
        gateway=9.9.9.9 routing-table=to_ISP2 target-scope=11
```




