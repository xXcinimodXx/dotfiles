#!/bin/bash

# Terminate already running Polybar instances
killall -q polybar

# Wait for processes to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
polybar top &

echo "Polybar launched!"
