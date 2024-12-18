#!/bin/bash

# Define variables
DOTFILES_REPO="https://github.com/xXcinimodXx/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
TARGET_CONFIG_DIR="$HOME/.config"
CONFIGS=("autostart" "gtk-3.0" "rofi" "bspwm" "polybar" "systemd")

# Step 1: Clone the repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory not found. Cloning from GitHub..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "Dotfiles directory found. Pulling latest changes from GitHub..."
    cd "$DOTFILES_DIR" || exit
    git pull origin main
fi

# Step 2: Create symlinks for specified configurations
echo "Creating symlinks for dotfiles..."
for config in "${CONFIGS[@]}"; do
    SOURCE="$DOTFILES_DIR/.config/$config"
    TARGET="$TARGET_CONFIG_DIR/$config"

    if [ -d "$SOURCE" ]; then
        echo "Linking $config..."
        # Remove existing target if it exists
        [ -d "$TARGET" ] && rm -rf "$TARGET"
        # Create the symlink
        ln -sf "$SOURCE" "$TARGET"
    else
        echo "Warning: $SOURCE does not exist in the repository."
    fi
done

echo "Bootstrap complete! Specified dotfiles are up to date."