# SETTINGS
$wslDistro = "Ubuntu-24.04"
$listenPort = 8080
$connectPort = 8080

# Get local LAN IP to generate access URL
$localIp = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.InterfaceAlias -notlike "*Virtual*" -and $_.IPAddress -like "192.*" }).IPAddress

# Get current WSL IP address (important for portproxy connectaddress)
$wslIp = wsl -d $wslDistro -e hostname -I | ForEach-Object { $_.Trim() } | Select-Object -First 1

# Function: Wait until code-server is listening in WSL
function Wait-ForCodeServer {
    Write-Host "Waiting for code-server to start on port $connectPort inside WSL..."

    $maxTries = 15
    $tries = 0

    while ($tries -lt $maxTries) {
        $listening = wsl -d $wslDistro -e sh -c "ss -tln | grep ':$connectPort '"
        if ($listening) {
            Write-Host "code-server is listening on port $connectPort."
            return
        }

        Start-Sleep -Seconds 1
        $tries++
    }

    Write-Error "code-server did not start in time. Aborting portproxy setup."
    exit 1
}

# Step 1: Start code-server in WSL (non-blocking, in background)
Write-Host "Launching code-server in WSL..."
wsl -d $wslDistro -e sh -c "nohup code-server --host 0.0.0.0 --port $connectPort > /dev/null 2>&1 &"

# Step 2: Wait until it's ready
Wait-ForCodeServer

# Step 3: Reset and add portproxy rule using WSL IP
Write-Host "Resetting existing portproxy rule (if any)..."
netsh interface portproxy delete v4tov4 listenport=$listenPort listenaddress=0.0.0.0 2>$null

Write-Host "Adding portproxy rule: 0.0.0.0:$listenPort -> ${wslIp}:$connectPort"
netsh interface portproxy add v4tov4 listenport=$listenPort listenaddress=0.0.0.0 connectport=$connectPort connectaddress=$wslIp

# Step 4: Show success message
Write-Host "`nSetup complete!"
Write-Host "Open in browser http://${localIp}:${listenPort}"
