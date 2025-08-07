🧾 **Documentation: Setting Up code-server on Windows 11 Using WSL**

📌 Goal
To use Visual Studio Code (VS Code) on an iPad by running code-server (a web-accessible version of VS Code) on a local Windows 11 laptop.
🛠️ Step 1: Initial Attempt – Using the Prebuilt .zip File
🔍 Actions Taken
Visited the official code-server GitHub repository.

Downloaded the prebuilt release .zip file for Windows.

Extracted the contents.

❌ Issue Faced
Upon running the executable from the zip, it showed:

Error: There was no executable to run from the .zip I downloaded. There was no clear path to success.

💡 Decision
Switched to using WSL (Windows Subsystem for Linux) for better compatibility and Unix-like environment because I am using a home version of windows 11(Remote desktop is not available in the home edition of windows). 

🛠️ Step 2: Setting Up WSL on Windows 11
✅ Steps Completed
1. Enabled WSL feature:

wsl --install

This downloads and installs WSL for windows. 

2. After download and install was completed I went to the microsoft store and downloaded and installed  Ubuntu 24.04.1 LTS
3. Confirmed installation via:
   wsl --list --verbose

🧱 Step 3: Installing code-server in WSL (Ubuntu) and running it for the first time
1. Opened Ubuntu terminal in WSL by opening terminal and typing "wsl".
2. This prompted me to set up my user and password for ubuntu. The password inserted here is extremely important because the password is later used for any sudo operations.
3. sudo apt update && sudo apt upgrade -y
4. curl -fsSL https://code-server.dev/install.sh | sh
5. code-server 

🧱 Step 4: Configuring Windows Firewall port 
1. Make code-server accessible on my network
   a. nano ~/.config/code-server/config.yaml
   b. Change:
     bind-addr: 127.0.0.1:8080
     to
     bind-addr: 0.0.0.0:8080
   c. ctrl+x
   d. y
2. Restart code-server in terminal
3. Find WSL IP
   a. Still in Ubuntu/WSL, run:
     hostname -I
     I got: 172.18.202.206
   b. In a browser in the same pc run: 172.18.202.206:8080
   c. I got access to VS code and was asked to insert password here.
      The password can be found by running: cat ~/.config/code-server/config.yaml
4. Allow Port 8080 Through Windows Firewall
   a. Open Windows Defender Firewall
   b. Click on "Advanced Settings" (on the left)
   c. Go to Inbound Rules → click New Rule (right panel)
   d. Choose Port → Click Next
   e. Select TCP, and Specific local ports: 8080
   f. Click Next, choose Allow the connection
   g. Click Next, make sure Private is checked (for home Wi-Fi)
   h. I gave it the name: code-server WSL
   i. click Finish


6. I then disabled the password to access VS code
   a. nano ~/.config/code-server/config.yaml
   b. Change:
     auth: password
     to
     auth: none
   c. Save(ctrl+x, y) and restart code-server

🧱 Step 5: Windows PowerShell script to get WSL IP and Updates the portproxy rule automatically
1. Download the Update-CodeServer-PortProxy.ps1 file in this repo to desktop


🧱 Step 6: Start code-server in WSL
1. On each startup run powershell as administrator and open wsl
2. code-server --host 0.0.0.0 --port 8080
3. On a new powershell as administrator
   a. cd .\Desktop\
   b. Run .\Update-CodeServer-PortProxy.ps1
4. In my iPad, i go to:
  http://192.168.0.213:8080

🧱 Step 7: Alternatively if the script does not work, do the following:
1.  In a wsl terminal I need to run:
  code-server --host 0.0.0.0 --port 8080
2. netsh interface portproxy add v4tov4 listenport=8080 listenaddress=0.0.0.0 connectport=8080 connectaddress=172.18.202.206
3. In my iPad, i go to:
  http://192.168.0.213:8080

   


