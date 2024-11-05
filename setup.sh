#!/bin/bash

echo "Starting setup..."

# Install Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
echo "Adding Homebrew to PATH..."
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install essential packages
echo "Installing essential packages..."
brew install python
echo 'alias python=python3' >> ~/.zprofile  # Make Python3 the default
brew install git
brew install wget
brew install --cask google-chrome
brew install --cask cursor
brew install --cask iterm2

# Set up Python environment
echo "Setting up Python environment..."
pip3 install --upgrade pip
pip3 install virtualenv
pip3 install numpy pandas matplotlib

#install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
xcode-select --install

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Completion message
echo "Environment setup complete!"
read -p "Press Enter to restart your terminal and apply changes..."

# Restart the terminal
exec zsh
