## 📋 Documentation: Setting Up code-server on Windows 11 Using WSL

## 📚 Table of Contents

* [📌 Goal](#-goal)
* [🛠️ Step 1: Initial Attempt – Using the Prebuilt .zip File](#-step-1-initial-attempt--using-the-prebuilt-zip-file)
* [🛠️ Step 2: Setting Up WSL on Windows 11](#-step-2-setting-up-wsl-on-windows-11)
* [🧱 Step 3: Installing code-server in WSL (Ubuntu)](#-step-3-installing-code-server-in-wsl-ubuntu-and-running-it-for-the-first-time)
* [🧱 Step 4: Configuring Windows Firewall Port](#-step-4-configuring-windows-firewall-port)
* [🧱 Step 5: PowerShell Script Setup](#-step-5-windows-powershell-script-to-get-wsl-ip-and-updates-the-portproxy-rule-automatically)
* [🧱 Step 6: Start code-server in WSL](#-step-6-start-code-server-in-wsl)
* [🧱 Step 7: Manual Alternative If Script Fails](#-step-7-alternatively-if-the-script-does-not-work-do-the-following)
* [📝 Final Summary](#-final-summary)

---

## 📌 Goal

To use Visual Studio Code (VS Code) on an iPad by running code-server (a web-accessible version of VS Code) on a local Windows 11 laptop.

---

## 🛠️ Step 1: Initial Attempt – Using the Prebuilt .zip File

### 🔍 Actions Taken

* Visited the official code-server GitHub repository.
* Downloaded the prebuilt release `.zip` file for Windows.
* Extracted the contents.

### ❌ Issue Faced

Running the executable failed with the error:

> There was no executable to run from the .zip I downloaded.

### 💡 Decision

Switched to using **Windows Subsystem for Linux (WSL)** for better compatibility and a Unix-like environment.

---

## 🛠️ Step 2: Setting Up WSL on Windows 11

```bash
wsl --install
```

* After installation, go to the Microsoft Store and install:

  > **Ubuntu 24.04.1 LTS**

```bash
wsl --list --verbose
```

---

## 🧱 Step 3: Installing code-server in WSL (Ubuntu) and Running It

```bash
# Update & upgrade packages
sudo apt update && sudo apt upgrade -y

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh

# Start code-server
code-server
```

<details>
<summary>⚠️ Initial WSL Setup Notes</summary>

* When Ubuntu is first launched, you'll be asked to set a username and password.
* This password is required for all `sudo` commands.

</details>

---

## 🧱 Step 4: Configuring Windows Firewall Port

### 1. Update `config.yaml`

```bash
nano ~/.config/code-server/config.yaml
```

Change:

```yaml
bind-addr: 127.0.0.1:8080
```

to:

```yaml
bind-addr: 0.0.0.0:8080
```

Then press `Ctrl+X`, then `Y`, and press `Enter` to save.

### 2. Restart code-server

```bash
code-server
```

### 3. Get WSL IP

```bash
hostname -I
```

Then access it in a browser on the same PC:

```text
http://<WSL-IP>:8080
```

### 4. Find the default password

```bash
cat ~/.config/code-server/config.yaml
```

### 5. Allow Port 8080 Through Windows Firewall

1. Open **Windows Defender Firewall**
2. Go to **Advanced Settings** (left panel)
3. Click **Inbound Rules** → **New Rule** (right panel)
4. Choose **Port** → **Next**
5. Select **TCP** and set Specific local ports: `8080`
6. Choose **Allow the connection**
7. Ensure **Private** is checked
8. Name it: `code-server WSL`
9. Click **Finish**

### 6. Disable Password Authentication (optional)

```bash
nano ~/.config/code-server/config.yaml
```

Change:

```yaml
auth: password
```

to:

```yaml
auth: none
```

Then restart code-server:

```bash
code-server
```

---

## 🧱 Step 5: Windows PowerShell Script Setup

Download the `Update-CodeServer-PortProxy.ps1` file from this repo to your **Desktop**.

---

## 🧱 Step 6: Start code-server in WSL

### 1. Run code-server in WSL

```bash
code-server --host 0.0.0.0 --port 8080
```

### 2. In **PowerShell as Administrator**

```powershell
cd .\Desktop\
.\u005cUpdate-CodeServer-PortProxy.ps1
```

### 3. On iPad, access your Windows LAN IP

```text
http://192.168.0.213:8080
```

<details>
<summary>⚠️ Note on IP Changes</summary>

* **WSL IP and LAN IP may change** after reboot or network change.
* You must re-run the script to refresh the `portproxy` rule.

</details>

---

## 🧱 Step 7: Alternatively If Script Fails

### 1. In WSL Terminal

```bash
code-server --host 0.0.0.0 --port 8080
```

### 2. In PowerShell as Administrator

```powershell
netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=172.18.202.206
```

### 3. On iPad:

```text
http://192.168.0.213:8080
```

<details>
<summary>💡 Notes</summary>

* Replace the IPs as per your WSL and LAN addresses.
* You can get your WSL IP by running:

```bash
hostname -I
```

</details>

---

## 📝 Final Summary

* You've set up a local code-server instance running on WSL.
* It's accessible from your iPad over your local network.
* You’ve made it easier to start the server with a PowerShell automation script.
* Optional password disabling improves UX on trusted networks.
* Always remember to check WSL and LAN IPs after reboots/network changes.

Enjoy running VS Code from anywhere on your iPad! 🚀
