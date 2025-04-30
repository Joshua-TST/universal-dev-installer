#!/bin/bash

echo "Starting Universal Dev Installer for macOS/Linux..."

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

brew install python
brew install node
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask firefox
brew install --cask postman
brew install --cask ngrok

# Verifications
python3 --version
node --version
ngrok version
code --version
