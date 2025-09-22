# 🕶️ NIGHTMARE 

![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)
![OS](https://img.shields.io/badge/supported_OS-parrot_os_6.4-red.svg)

**Nightmare** is a stealth-focused command-line tool for privacy-conscious users, hackers, and cyber wanderers. Spoof your identity, vanish from the grid, lock down your network — and helps you to ...

## _Become the GHOST of a NIGHTMARE._
### Important !!!
> This tool specially built for Parrot OS 6.4. It will not work fine on othe operating system. But if you can install all the dependencies then it will work !

## Features

- **Ghost Mode**
  - MAC address spoofing (via `macchanger`)
  - Dynamic IP reassignment
  - IPv6 disabling for privacy hardening
  - Optional routing through Anonsurf (Tor)
  - UFW firewall lockdown (localhost only)

-  **Status Mode**
  - Check MAC spoof status
  - Confirm firewall, Anonsurf, and IP state
  - Instant ghost/human mode audit

-  **Human Mode**
  - Revert spoofed MAC to original
  - Restore IPv6, disable firewall & Anonsurf
  - Reset to normal state

- 📋️ **Nightmare CLI**
  - `nightmare start` – Enter ghost mode
  - `nightmare status` – Check your current stealth state
  - `nightmare stop` – Return to human mode
  - Stylish ASCII banners via `toilet` or `figlet`

---

## 📦 Installation

### 💻 From `.deb` package:
#### Download the latest `.deb` file from releases page:
[Click this link to download the latest version of Nightmare from releases page](https://github.com/antman-quantamuniverse/nightmare/releases) 

#### After downloading the `.deb` file run this command:

```bash
sudo dpkg -i nightmare_1.0.deb
```
#### Install with dependencies (If you need):

```bash
sudo apt install macchanger network-manager anonsurf ufw wget toilet
```
#### Then launch:

```bash
nightmare 
```
#### Use CLI commands or 
```bash
nightmare help
```
---

## ⚙️ Requirements

Make sure these are installed:

- `bash`
- `macchanger`
- `network-manager`
- `anonsurf`
- `ufw`
- `wget`
- `toilet` or `figlet` (optional for banner)

Install with (If You Haven't Installed Already ):

```bash
sudo apt install macchanger network-manager anonsurf ufw wget toilet
```

---

## 📁 Folder Structure

Installed locations:

```
/usr/local/bin/nightmare         # CLI wrapper
/opt/nightmare/beghost.sh        # Ghost mode
/opt/nightmare/isghost.sh        # Status checker
/opt/nightmare/behuman.sh        # Revert script
```

---

## 🙏 Credits

This tool leverages the power of:

- **[Anonsurf](https://github.com/ParrotSec/anonsurf)** – For Tor anonymization
- **[macchanger](https://github.com/alobbs/macchanger)** – For MAC spoofing
- **NetworkManager** – For Wi-Fi and IP control
- **ufw** – For firewall lockdown
- **figlet/toilet** – For badass banners

---

## 📜 License

MIT License  
Copyright (c) 2025 [@antman-quantamUniverse](https://github.com/antman-quantamUniverse)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software...

[→ View full license](./license)

---

> _This is just the beginning..._  
> 🧠👻 **Nightmare will be continued...**
