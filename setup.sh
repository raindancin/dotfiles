#!/bin/bash
read -p "Enter your username: " USERNAME
# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Adding Homebrew to your PATH..."
    # Check if the line already exists in .zprofile
    if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' /Users/$USERNAME/.zprofile; then
        echo >> /Users/$USERNAME/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USERNAME/.zprofile
    fi
    source /Users/$USERNAME/.zprofile
else
    echo "Homebrew is already installed."
fi
# Check if Homebrew is callable
if ! command -v brew &> /dev/null; then
    echo "Homebrew installation failed or is not callable."
    echo "Attempting to set up the environment."
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Checking again if Homebrew is callable
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is still not callable. Please check the installation."
        exit 1
    fi
fi
# Disable Homebrew analytics
brew analytics off
# Install programs and fonts
echo "Installing programs and fonts..."
brew install btop bat neovim eza fzf
brew install --cask kitty alt-tab nikitabobko/tap/aerospace keepassxc raycast
echo "Installing fish shell..."
brew install fish
# Add fish to /etc/shells if it's not already listed
FISH_PATH="$(brew --prefix)/bin/fish"
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "Adding fish to /etc/shells (requires sudo)..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
fi
# Set fish as the default shell for the user
echo "Setting fish as the default shell for $USERNAME..."
sudo chsh -s "$FISH_PATH" "$USERNAME"
echo "Setup complete!"








































