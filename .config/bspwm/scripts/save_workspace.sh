#!/bin/bash

# Define output file
OUTPUT_FILE=~/.config/bspwm/workspaces/new_workspace.sh

# Start writing the script
echo "#!/bin/bash" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Save current `bspwm` layout
echo "# Restore bspwm layout" >> $OUTPUT_FILE
bspc wm -d >> $OUTPUT_FILE

# List all running windows and save their commands
echo "" >> $OUTPUT_FILE
echo "# Launch applications" >> $OUTPUT_FILE
wmctrl -l | while read -r line; do
    # Get window ID and title
    WIN_ID=$(echo "$line" | awk '{print $1}')
    WIN_TITLE=$(echo "$line" | cut -d ' ' -f 5-)

    # Attempt to identify the command that launched the window
    APP_CMD=$(ps -o args= --no-headers --pid "$(xdotool getwindowpid "$WIN_ID")")

    # Write the launch command to the script
    echo "$APP_CMD &" >> $OUTPUT_FILE
done

# Save bspwm positioning commands
echo "" >> $OUTPUT_FILE
echo "# Position windows" >> $OUTPUT_FILE
wmctrl -l | while read -r line; do
    WIN_ID=$(echo "$line" | awk '{print $1}')
    DESKTOP=$(echo "$line" | awk '{print $2}')
    TITLE=$(echo "$line" | cut -d ' ' -f 5-)

    # Add positioning command
    echo "wmctrl -r \"$TITLE\" -t $DESKTOP" >> $OUTPUT_FILE
done

# Make the script executable
chmod +x $OUTPUT_FILE

echo "Workspace saved to $OUTPUT_FILE"
