@echo off
cd /d "%~dp0" || exit /b 1

docker compose up -d
if errorlevel 1 (
    echo Could not start Stirling PDF. Check that Docker Desktop is running.
    pause
    exit /b 1
)

timeout /t 5 /nobreak >nul

echo.
echo Your link: http://localhost:8080
echo.
echo Links to share with friends on the same network:
powershell.exe -NoLogo -NoProfile -Command "try { $found = $false; foreach ($adapter in [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()) { if ($adapter.OperationalStatus -ne 'Up' -or $adapter.NetworkInterfaceType -notin @('Ethernet', 'Wireless80211')) { continue }; $properties = $adapter.GetIPProperties(); $hasGateway = $false; foreach ($gateway in $properties.GatewayAddresses) { if ($gateway.Address.AddressFamily -eq 'InterNetwork' -and $gateway.Address.ToString() -ne '0.0.0.0') { $hasGateway = $true } }; if (-not $hasGateway) { continue }; foreach ($entry in $properties.UnicastAddresses) { $address = $entry.Address; if ($address.AddressFamily -eq 'InterNetwork' -and -not [System.Net.IPAddress]::IsLoopback($address) -and $address.ToString() -notlike '169.254.*') { Write-Host ('  http://{0}:8080  ({1})' -f $address, $adapter.Name); $found = $true } } }; if (-not $found) { exit 1 } } catch { exit 1 }"
if errorlevel 1 (
    echo Could not detect a network link automatically.
    echo Run ipconfig and use your active Wi-Fi or Ethernet IPv4 address:
    echo   http://YOUR-IP-ADDRESS:8080
)
echo.
echo Share the link matching the network your friend is connected to.
echo Keep this PC awake and Docker running. Friends will need a login.
echo If a friend cannot connect, see the network and firewall steps in README.md.
echo The app may still be starting; wait and refresh if needed.
echo.

start "" http://localhost:8080

echo You can close this window after copying the link. Stirling PDF will keep running.
pause
exit /b 0
