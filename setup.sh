#!/bin/bash

# Update macOS and install Xcode Command Line Tools
sudo softwareupdate -ia
xcode-select --install

# Install Homebrew
if ! command -v brew &> /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install essential packages
brew install python
echo 'alias python=python3' >> ~/.zprofile  # Make Python3 the default
brew install git
brew install wget


# Install productivity tools
brew install --cask google-chrome
brew install --cask cursor
brew install --cask iTerm2

# Set up Python environment
echo 'Setting up Python environment...'
pip3 install --upgrade pip
pip3 install virtualenv
pip3 install numpy pandas matplotlib

# Completion message
echo "Environment setup complete! Restart your terminal to apply changes."
