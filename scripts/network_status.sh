#!/usr/bin/env bash

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    active_network=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
    if [ -n "$active_network" ]; then
        echo "󰖩 $active_network"  # Wi-Fi enabled and connected
    else
        echo "󰖩"
    fi
else
    echo "󰖪"
fi
