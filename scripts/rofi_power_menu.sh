#!/bin/bash

# Rofi power menu
chosen=$(echo -e "Shutdown\nReboot\nLock\nSuspend\nLogout" | rofi -dmenu -i -p "Power Menu:")

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Lock) slock ;;
    Suspend) systemctl suspend ;;
    Logout) bspc quit ;;
    *) exit 1 ;;
esac
