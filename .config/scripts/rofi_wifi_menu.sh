#!/usr/bin/env bash

# Function to display the current Wi-Fi status with icons
show_status() {
    connected=$(nmcli -fields WIFI g)
    if [[ "$connected" =~ "enabled" ]]; then
        active_network=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
        if [ -n "$active_network" ]; then
            echo -e "󰖩 Connected to: \033[1;32m$active_network\033[0m"  # Wi-Fi enabled and connected
        else
            echo -e "󰖩 Wi-Fi Enabled (Not Connected)"  # Wi-Fi enabled but no connection
        fi
    else
        echo -e "󰖪 Wi-Fi Disabled"  # Wi-Fi disabled
    fi
}

# Show the current status
show_status

# Notify user of action
notify-send "Getting list of available Wi-Fi networks..."

# Fetch the list of available Wi-Fi networks
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | \
    sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Determine the toggle option for Wi-Fi
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪 Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
    toggle="󰖩 Enable Wi-Fi"
fi

# Use rofi to allow the user to select a Wi-Fi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: ")
read -r chosen_id <<< "${chosen_network:3}"  # Extract the chosen network's SSID

# Handle user selection
if [ -z "$chosen_network" ]; then
    echo "No selection made. Exiting."
    exit 0
elif [[ "$chosen_network" == *"Enable Wi-Fi"* ]]; then
    nmcli radio wifi on
    notify-send "Wi-Fi Enabled"
elif [[ "$chosen_network" == *"Disable Wi-Fi"* ]]; then
    nmcli radio wifi off
    notify-send "Wi-Fi Disabled"
else
    # Connection process
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") == "$chosen_id" ]]; then
        # Connect to an already saved network
        if nmcli connection up id "$chosen_id" | grep -q "successfully"; then
            notify-send "Connection Established" "$success_message"
            show_status
            exit 0
        else
            notify-send "Connection Failed" "Could not connect to $chosen_id."
            show_status
            exit 1
        fi
    else
        # Connect to a new network
        if [[ "$chosen_network" =~ "" ]]; then
            wifi_password=$(rofi -dmenu -p "Password: ")
        fi
        if nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep -q "successfully"; then
            notify-send "Connection Established" "$success_message"
            show_status
            exit 0
        else
            notify-send "Connection Failed" "Could not connect to $chosen_id."
            show_status
            exit 1
        fi
    fi
fi
