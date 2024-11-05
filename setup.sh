#!/bin/bash

# Error handling
set -e  # Exit on error
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR

# Helper functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        log "❌ $1 not found"
        return 1
    fi
    log "✅ $1 found"
    return 0
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log "❌ This script is designed for macOS only"
    exit 1
fi

log "Starting setup..."

# Install Xcode Command Line Tools first (required for git and other tools)
if ! xcode-select -p &>/dev/null; then
    log "Installing Xcode Command Line Tools..."
    xcode-select --install
    log "Waiting for Xcode Command Line Tools installation..."
    sleep 60  # Give some time for the installation
fi

# Install Homebrew if not present
if ! check_command brew; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew
log "Updating Homebrew..."
brew update
brew upgrade

# Install essential CLI tools
log "Installing CLI tools..."
brew install \
    git \
    wget \
    curl \
    tree \
    htop \
    jq \
    ripgrep \
    fzf \
    tmux \
    neovim \
    node \
    python

# Install essential apps
log "Installing apps..."
brew install --cask \
    google-chrome \
    cursor \
    iterm2 \

# Python setup
log "Setting up Python environment..."
echo 'alias python=python3' >> ~/.zprofile

# Create and activate a virtual environment for global packages
python3 -m venv ~/.global-python
source ~/.global-python/bin/activate

# Now install packages in the virtual environment
pip3 install --upgrade pip
pip3 install \
    virtualenv \
    numpy \
    pandas \
    matplotlib \
    requests \
    pytest \
    black \
    pylint \
    jupyter

# Add the virtual environment's bin to PATH
echo 'export PATH="$HOME/.global-python/bin:$PATH"' >> ~/.zprofile

# Node.js setup
log "Setting up Node environment..."
npm install -g yarn typescript ts-node

# Install and configure Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install useful Oh My Zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    # Update .zshrc to include plugins
    sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
fi

# Git configuration
log "Configuring Git..."
read -p "Enter your Git name: " git_name
read -p "Enter your Git email: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
git config --global core.editor "nvim"

# Final cleanup
log "Cleaning up..."
brew cleanup

log "✅ Environment setup complete!"
log "⚠️  Please restart your terminal to apply all changes"
read -p "Press Enter to restart your terminal..."

# Restart terminal
exec zsh
