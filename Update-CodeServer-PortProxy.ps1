# Define settings
$wslCommand = "wsl -d Ubuntu -- code-server --host 0.0.0.0 --port 8080"
$localIp = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Virtual*" -and $_.IPAddress -like "192.*" }).IPAddress
$listenPort = 8080
$connectPort = 8080
$connectAddress = "127.0.0.1"

# Step 1: Kill existing portproxy rule (optional cleanup)
netsh interface portproxy delete v4tov4 listenport=$listenPort listenaddress=0.0.0.0

# Step 2: Add new portproxy rule
netsh interface portproxy add v4tov4 listenport=$listenPort listenaddress=0.0.0.0 connectport=$connectPort connectaddress=$connectAddress

# Step 3: Launch code-server in WSL
Start-Process powershell -ArgumentList "-NoExit", "-Command", $wslCommand

# Step 4: (Optional) Open iPad browser URL via a print message
Write-Host "`n✅ Setup complete. Access VS Code on your iPad at:"
Write-Host "👉 http://$localIp:$listenPort"
