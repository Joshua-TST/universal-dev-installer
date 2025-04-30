# install_windows.ps1

Write-Host "Starting Universal Dev Installer for Windows..."

# Install Chocolatey if not installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Install software
choco upgrade chocolatey -y
choco feature enable -n allowGlobalConfirmation

choco install python vscode nodejs postman ngrok -y
choco install googlechrome firefox -y

# Install WSL with Ubuntu
wsl --install

# Verifications
python --version
node --version
ngrok version
code --version
