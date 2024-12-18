#!/bin/bash

# Directory where the note will be created
NOTES_DIR="/mnt/nas-001/notes"

# Ensure the directory exists
if [ ! -d "$NOTES_DIR" ]; then
    echo "Error: Directory $NOTES_DIR does not exist. Please create it first."
    exit 1
fi

# Generate the file name in mm_dd_yyyy format
FILENAME="$(date +%m_%d_%Y).txt"

# Full path to the new note
FILE_PATH="$NOTES_DIR/$FILENAME"

# Create the file if it doesn't already exist
if [ ! -f "$FILE_PATH" ]; then
    touch "$FILE_PATH"
fi

# Open the file in VS Code
code --new-window "$FILE_PATH"

echo "Opened new note: $FILE_PATH"