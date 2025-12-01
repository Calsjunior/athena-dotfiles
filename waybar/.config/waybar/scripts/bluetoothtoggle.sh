#!/usr/bin/env bash

# Toggle bluetooth on or off using rfkill

if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    rfkill unblock bluetooth
    blueman-manager
else
    rfkill block bluetooth
    pkill blueman-manager
fi