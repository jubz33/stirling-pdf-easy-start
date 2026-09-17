# Stirling PDF Easy Start

A small, unofficial Windows launcher and Docker Compose setup for **easy use and personal use** of Stirling PDF, including access from devices on your trusted local network.

## Credit to the original creators

All credit for the Stirling PDF application and its PDF tools belongs to the original creators, the **Stirling PDF / Stirling Tools team and contributors**. This repository supplies convenience scripts and a tutorial only. It is independently maintained and is not affiliated with or endorsed by Stirling PDF.

- Original project: [Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- Official website: [stirling.com](https://www.stirling.com/)
- Application license: [upstream LICENSE](https://github.com/Stirling-Tools/Stirling-PDF/blob/main/LICENSE)

Stirling PDF is downloaded from its official container registry when you start the setup. Its license and applicable usage terms remain those of the upstream project; the personal-use description here does not change them.

## Get this setup

Install [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/) with Linux containers, then download and extract this repository's ZIP, or clone it:

```powershell
git clone https://github.com/jubz33/stirling-pdf-easy-start.git
Set-Location stirling-pdf-easy-start
```

Keep the scripts beside `compose.yaml`. They work from the folder where you extracted or cloned the repository. The examples below use `C:\Stirling-PDF`; substitute your own folder if different.

This folder runs Stirling PDF using Docker Compose. You can merge, split, compress, convert, and edit PDFs in a browser. Your computer hosts the application; friends on the same local network can use it through their browsers while it is running.

## 1. Start the application

1. Open Docker Desktop and wait until its engine is running (Linux containers).
2. Double-click `start-stirling.bat` in your setup folder.
3. Your browser opens **http://localhost:8080**.
4. If the page is not ready, wait a little longer and refresh. The script waits only five seconds; application startup or the first image download can take longer.
5. Sign in with your existing Stirling PDF account. On a fresh installation, consult the [official first-login instructions](https://docs.stirlingpdf.com/Installation/Docker%20Install/), and change the initial administrator password before sharing network access. Login is enabled by default.

Alternatively, run these commands in PowerShell:

```powershell
Set-Location C:\Stirling-PDF
docker compose up -d
```

The `-d` option runs the service in the background. Closing the terminal or browser does not stop it.

## 2. Work with a PDF

1. Open the application and sign in.
2. Choose the tool you need, such as Merge, Split, Compress, or a conversion tool. Labels can vary by version.
3. Upload or drag in your PDF files.
4. Set the options, such as page selection, file order, or compression level.
5. Run the operation and download the result to your device.
6. Open the downloaded file to check it before replacing your original.

Examples:

- **Merge:** select multiple PDFs, arrange them in the desired order, and merge them.
- **Split:** select a PDF, choose which pages or ranges to extract, and download the output.
- **Compress:** select a PDF, choose compression options, and compare the output quality and size.

Some operations send documents to this hosting computer for processing. The mounted `stirling/data` folder is for OCR language data, not an inbox for your PDFs. Download results you want to keep.

## 3. Let a friend on the same network use it

### Start it on your computer

Run `start-stirling.bat` or `docker compose up -d` as above. Keep your computer awake, connected to the network, and Docker Desktop running. Your friend only needs a browser; they do not need Docker or a copy of this folder.

### Share your computer's local address

Find your computer's local IPv4 address with `ipconfig`. For example, if the address is **192.168.1.50**, a friend connected to the same home/local network can try:

**http://192.168.1.50:8080** (example only; replace with your host's address)

Use `http`, and include `:8080`. On your friend's device, `localhost` points to their own device, so they must use your computer's address.

Your address may change after reconnecting or restarting the router. To find it again, run:

```powershell
ipconfig
```

Look for **IPv4 Address** under the active **Wi-Fi** or **Ethernet** adapter used to reach your friend. Ignore WSL/Hyper-V adapters when sharing the Wi-Fi address. Replace the address in the URL if it changes. A DHCP reservation in your router can keep the address stable.

Your existing Compose configuration already publishes port 8080:

```yaml
ports:
  - "8080:8080"
```

This publishes the service on the host's network interfaces by default; no Compose edit is needed for ordinary LAN access. Host firewall rules and router isolation can still block connections. See [Docker's port publishing documentation](https://docs.docker.com/get-started/docker-concepts/running-containers/publishing-ports/).

### Give your friend a login

Sign in as an administrator and look for user management in the application settings. Create a separate regular user for your friend if your installed edition and user limit permit it, then give them that account's credentials. Avoid sharing the administrator account. Your friend signs in at the same network URL and uploads/downloads files on their own device.

### If Windows Firewall blocks access

First confirm `http://localhost:8080` works on your computer. On a trusted home network, check that your active Windows network profile is **Private** in Settings > Network & internet > your connection's properties.

If the friend's connection is still blocked, open **PowerShell as Administrator** and run this once to allow TCP port 8080 from the local subnet on Private networks:

```powershell
New-NetFirewallRule -DisplayName "Stirling PDF LAN 8080" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8080 -Profile Private -RemoteAddress LocalSubnet
```

This guide does not create the firewall rule automatically. To remove that rule later:

```powershell
Remove-NetFirewallRule -DisplayName "Stirling PDF LAN 8080"
```

Use this setup on a trusted local network: the current HTTP connection is not encrypted. Router port forwarding is unnecessary for same-network access.

## 4. Stop the application

Double-click `stop-stirling.bat`, or run:

```powershell
Set-Location C:\Stirling-PDF
docker compose stop
```

This stops the service for you and your friends while retaining the container and saved configuration/database. Start it again with `start-stirling.bat`.

The Compose restart policy is `unless-stopped`: Docker can restart the service automatically unless you explicitly stopped it. Your computer must still be running for anyone to connect.

## 5. Troubleshooting

Run these commands from `C:\Stirling-PDF` in PowerShell:

```powershell
docker compose ps
docker compose logs --tail 100 stirling-pdf
```

| Problem | What to check |
| --- | --- |
| Docker command fails or cannot connect to the engine | Open Docker Desktop and wait for the engine to start. |
| Browser opens before the app is ready | Wait and refresh; inspect the logs if startup never completes. |
| Localhost works, but your friend cannot connect | Check the current LAN IP, port 8080, Windows Firewall, and that both devices can communicate on the network. |
| Both devices are on Wi-Fi but cannot connect | Guest Wi-Fi, client/AP isolation, a VPN, or workplace network rules may block device-to-device access. Use a network that permits it. |
| Port 8080 is already in use | Stop the other application using that port, then start Stirling PDF again. |
| Connection stops when you leave the computer | Check sleep settings and whether Docker or the container was stopped. |
| Encrypted PDF fails to export after editing | With authorization and any required password, unlock a copy using an available PDF unlock/remove-password tool, then retry using that copy. |
| Text looks different after editing | Missing fonts can affect output. Check downloaded results carefully. |

From a friend's Windows computer, this tests whether your host port is reachable (replace the address if it changes):

```powershell
Test-NetConnection 192.168.1.50 -Port 8080
```

`TcpTestSucceeded: True` means the port is reachable; it does not verify login or PDF processing.

## 6. Files and backups

| File or folder | Purpose |
| --- | --- |
| `compose.yaml` | Docker image, port mapping, persistent folders, and restart policy. |
| `start-stirling.bat` | Starts the service and opens the local browser URL. |
| `stop-stirling.bat` | Stops the service. |
| `stirling/config/` | Settings, application database, database backups, and signing keys. |
| `stirling/logs/` | Application and authentication logs. |
| `stirling/data/` | Mounted OCR language-data directory. |

To make a consistent file backup, stop Stirling PDF, copy this folder to your backup location, and start it again. Keep backups private because the configuration directory includes account data and private signing keys.

This installation uses the `latest` Docker image tag. Running `docker compose up -d` starts the service but is not an explicit request to download every new release.

## Public repository safety

Only the README, Compose configuration, launcher scripts, and Git housekeeping files belong in this repository. `.gitignore` uses an explicit allowlist so generated files are ignored by default. The entire `stirling/` directory stays local, including settings, databases, backups, logs, and signing keys. Uploaded PDFs and `.env` files must also remain private.

Before committing future changes, review `git status` and `git diff --cached`. Git ignore rules do not protect files already tracked or files added with `git add -f`. Never put credentials into `compose.yaml` or documentation. This repository contains no bundled accounts or runtime data; each fresh installation creates its own local data.

## References

- [Official Stirling PDF Docker installation guide](https://docs.stirlingpdf.com/Installation/Docker%20Install/)
- [Stirling PDF deployment and administration guide](https://docs.stirlingpdf.com/Production-Deployment-Guide/)
- [Docker Compose networking](https://docs.docker.com/compose/how-tos/networking/)

All LAN addresses above are illustrative. Connectivity depends on your host, firewall, and network settings.
