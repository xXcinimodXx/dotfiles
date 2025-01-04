#!/bin/bash

# Define the NAS target directory
NAS_DIR="/mnt/nas-001/os/dotfliles/.config"

# Check if the NAS directory is available
if [ -d "$NAS_DIR" ]; then
  echo "NAS directory is available. Proceeding with copy."

  # Copy the .config directory to the NAS
  cp -r ~/.config "$NAS_DIR"

  # Print completion message
  echo ".config directory copied to $NAS_DIR successfully."
else
  echo "NAS directory is not available. Aborting."
  exit 1
fi
