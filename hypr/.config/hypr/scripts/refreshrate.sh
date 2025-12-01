#!/bin/bash
# ┳┓┏┓┏┓┳┓┏┓┏┓┓┏  ┳┓┏┓┏┳┓┏┓
# ┣┫┣ ┣ ┣┫┣ ┗┓┣┫  ┣┫┣┫ ┃ ┣
# ┛┗┗┛┻ ┛┗┗┛┗┛┛┗  ┛┗┛┗ ┻ ┗┛
#
# Configuration
LOW_REFRESH=60
HIGH_REFRESH=144
MONITORS_CONF="$HOME/.config/hypr/modules/monitors.conf"

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

# Apply change with explicit resolution (immediate effect)
hyprctl keyword monitor "$MONITOR,${CURRENT_WIDTH}x${CURRENT_HEIGHT}@${TARGET_REFRESH},auto,1"

# Update monitors.conf file for persistence
if [ -f "$MONITORS_CONF" ]; then
    # Create backup
    cp "$MONITORS_CONF" "${MONITORS_CONF}.bak"

    # Update the monitor line in the config file
    NEW_MONITOR_LINE="monitor = $MONITOR,${CURRENT_WIDTH}x${CURRENT_HEIGHT}@${TARGET_REFRESH},auto,1"

    # Check if monitor line exists and replace it, or add it
    if grep -q "^monitor.*$MONITOR" "$MONITORS_CONF"; then
        # Replace existing monitor line
        sed -i "s/^monitor.*$MONITOR.*/$NEW_MONITOR_LINE/" "$MONITORS_CONF"
    else
        # Add new monitor line
        echo "$NEW_MONITOR_LINE" >>"$MONITORS_CONF"
    fi

    echo "Updated $MONITORS_CONF with new refresh rate"
else
    echo "Warning: $MONITORS_CONF not found, creating it..."
    mkdir -p "$(dirname "$MONITORS_CONF")"
    echo "monitor = $MONITOR,${CURRENT_WIDTH}x${CURRENT_HEIGHT}@${TARGET_REFRESH},auto,1" >"$MONITORS_CONF"
fi

# Show notification
notify-send "Refresh Rate" "Switched to ${TARGET_REFRESH}Hz" -t 2000

