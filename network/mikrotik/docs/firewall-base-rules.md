# 🔐 MikroTik Firewall Setup

## 📌 Overview
Secure basic firewall configuration for MikroTik router

---

## ⚙️ Step 1 — Base rules

```rsc
/ip firewall filter
add action=accept chain=input comment=\
    "Allow established, related, untracked connections" connection-state=\
    established,related,untracked
add action=drop chain=input comment="Drop invalid connections" \
    connection-state=invalid
add action=accept chain=input comment="Allow ICMP" protocol=icmp
add action=add-src-to-address-list address-list=port-scan-detection \
    address-list-timeout=2w chain=input comment="Port scan detection TCP" \
    protocol=tcp psd=21,3s,3,1
add action=add-src-to-address-list address-list=port-scan-detection \
    address-list-timeout=2w chain=input comment="Port scan detection UDP" \
    protocol=udp psd=21,3s,3,1
add action=drop chain=input comment="Drop all not coming from LAN" \
    connection-state="" in-interface-list=!LAN
add action=accept chain=forward comment=\
    "Allow established, related, untracked forwarding" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="Drop invalid forward" \
    connection-state=invalid
add action=drop chain=forward comment="Drop all from WAN not DSTNATed" \
    connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="masquerade via ISP" \
    out-interface=ether8
/ip firewall raw
add action=drop chain=prerouting comment="DROP port scan detection" \
    src-address-list=port-scan-detection
```
## ⚠️ Step 2 — Змініть інтерфейс в NAT на свій, та додайте його в interface list WAN за потреби.
