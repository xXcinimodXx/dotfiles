#!/bin/bash

# Source directories
SOURCE_CONFIG="$HOME/.config"

# Destination directory
DEST_REPO="/mnt/nas-001/os/dotfiles/.config"

# List of configurations to copy
CONFIGS=("autostart" "gtk-3.0" "rofi" "bspwm" "polybar" "systemd")

# Ensure the destination directory exists
mkdir -p "$DEST_REPO"

# Copy each configuration
echo "Copying configurations..."
for config in "${CONFIGS[@]}"; do
    if [ -d "$SOURCE_CONFIG/$config" ]; then
        echo "Copying $config..."
        rsync -av --progress "$SOURCE_CONFIG/$config" "$DEST_REPO/"
    else
        echo "Warning: $config does not exist in $SOURCE_CONFIG"
    fi
done

echo "Configurations copied to $DEST_REPO"
