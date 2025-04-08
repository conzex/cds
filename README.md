# Conzex Development Studio (CDS) 🚀

![CDS Logo](https://github.com/conzex/cds/raw/main/assets/cds-logo.png)

**Conzex Development Studio (CDS)** is a powerful, trackable, GUI-driven PowerShell-based provisioning tool that automates the installation of a complete Windows development environment in one go.

> 🧩 Fast. 💡 Beautiful. ⚙️ Powerful.

---

## 🎯 Features

- ✅ One-click provisioning for Windows development environment
- 🎨 Modern Light-Themed GUI (Material UI styled)
- 📊 Live task timeline with percentage & real-time PowerShell console
- 📦 Auto-uninstalls old conflicting software
- 🛠 Installs latest versions of:
  - Git
  - Python
  - Node.js
  - PuTTY
  - CMake
  - WiX Toolset
  - Windows SDK
  - XAMPP (v8.5)
  - FileZilla (Client + Server)
  - Chrome (latest)
  - WinRAR
  - PS2EXE
- 🔒 Disables Windows Defender & Updates (optional)
- 🧹 Auto cleans up temp/cache files
- 🔁 Optional reboot after completion
- 📦 Converts to `.EXE` using PS2EXE with logo/icon support

---

## 🖥 System Requirements

- OS: Windows 10/11 (x64)
- CPU: 4–8 cores
- RAM: 8–12 GB recommended
- Disk: 100 GB free

---

## 📦 Installation

### 🧪 1. Manual Script Execution

```powershell
git clone https://github.com/conzex/cds.git
cd cds
.\dev-env-setup.ps1
