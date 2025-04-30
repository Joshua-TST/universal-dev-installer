#!/bin/bash

set -e

echo "🌐 Starting Universal Dev Installer for macOS/Linux..."

# Detect macOS
OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
    echo "🍎 Detected macOS..."

    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "📦 Installing packages..."
    brew update
    brew install python node
    brew install --cask visual-studio-code postman google-chrome firefox ngrok
    echo "✅ macOS setup complete."
    exit 0
fi

# Detect Linux distro
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "❌ Unsupported Linux distribution."
    exit 1
fi

echo "🐧 Detected Linux distro: $DISTRO"

# Installer functions
install_deb_tools() {
    echo "📦 Installing base packages on Debian/Ubuntu..."
    sudo apt update
    sudo apt install -y curl wget gnupg software-properties-common apt-transport-https

    # VS Code
    echo "📥 Adding Microsoft VS Code repository..."
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

    # Chrome
    echo "📥 Adding Google Chrome repository..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/google.gpg > /dev/null
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

    sudo apt update
    sudo apt install -y python3 python3-pip nodejs code google-chrome-stable firefox

    # Postman (via Snap)
    sudo snap install postman
    sudo snap install ngrok
}

install_arch_tools() {
    echo "📦 Installing packages on Arch..."
    sudo pacman -Sy --noconfirm python python-pip nodejs code google-chrome firefox

    # Postman via AUR (manual or yay)
    echo "⚠️ Postman/ngrok install on Arch requires AUR helper like 'yay'"
    echo "👉 Please run: yay -S postman-bin ngrok-bin"
}

install_fedora_tools() {
    echo "📦 Installing packages on Fedora..."
    sudo dnf install -y python3 python3-pip nodejs firefox

    # VS Code
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install -y code

    # Chrome
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install -y google-chrome-stable

    # Snap support
    sudo dnf install -y snapd
    sudo ln -s /var/lib/snapd/snap /snap
    sudo snap install postman
    sudo snap install ngrok
}

# Run distro-specific installer
case "$DISTRO" in
    ubuntu|debian)
        install_deb_tools
        ;;
    arch)
        install_arch_tools
        ;;
    fedora)
        install_fedora_tools
        ;;
    *)
        echo "❌ Unsupported distro: $DISTRO"
        exit 1
        ;;
esac

echo "✅ Setup complete!"

