# 🔐 MikroTik Firewall Setup

## 📌 Overview
Secure basic firewall configuration for MikroTik router

---

## ⚙️ Step 1 — Base rules

```rsc
/ip firewall filter
add chain=input action=accept connection-state=established,related
add chain=input action=drop in-interface=ether1
```
