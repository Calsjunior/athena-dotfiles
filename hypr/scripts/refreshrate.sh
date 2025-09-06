#!/bin/bash

# ┳┓┏┓┏┓┳┓┏┓┏┓┓┏  ┳┓┏┓┏┳┓┏┓
# ┣┫┣ ┣ ┣┫┣ ┗┓┣┫  ┣┫┣┫ ┃ ┣
# ┛┗┗┛┻ ┛┗┗┛┗┛┛┗  ┛┗┛┗ ┻ ┗┛
#

# Configuration
LOW_REFRESH=60
HIGH_REFRESH=144

# Get monitor info with full details
MONITOR_INFO=$(hyprctl monitors -j | jq -r '.[0]')
MONITOR=$(echo "$MONITOR_INFO" | jq -r '.name')
CURRENT_WIDTH=$(echo "$MONITOR_INFO" | jq -r '.width')
CURRENT_HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.height')
CURRENT_REFRESH=$(echo "$MONITOR_INFO" | jq -r '.refreshRate' | cut -d'.' -f1)

# Toggle refresh rate
if [ "$CURRENT_REFRESH" -eq "$LOW_REFRESH" ]; then
    TARGET_REFRESH=$HIGH_REFRESH
else
    TARGET_REFRESH=$LOW_REFRESH
fi

# Apply change with explicit resolution
hyprctl keyword monitor "$MONITOR,${CURRENT_WIDTH}x${CURRENT_HEIGHT}@${TARGET_REFRESH},auto,1"

# Show notification
notify-send "Refresh Rate" "Switched to ${TARGET_REFRESH}Hz" -t 2000