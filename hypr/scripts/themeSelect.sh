#!/usr/bin/env bash
# ┏┳┓┓┏┏┓┳┳┓┏┓  ┏┓┏┓┓ ┏┓┏┓┏┳┓
#  ┃ ┣┫┣ ┃┃┃┣ ━━┗┓┣ ┃ ┣ ┃  ┃
#  ┻ ┛┗┗┛┛ ┗┗┛  ┗┛┗┛┗┛┗┛┗┛ ┻
#
# Theme switcher using hellwal

HELLWALL_THEME_DIR="$HOME/.config/hellwal/themes"
ROFI_THEME="$HOME/.config/rofi/applets/themeSelect.rasi"

main() {
    # Find .hellwal files and strip the extension for display
    choice=$(find "$HELLWALL_THEME_DIR" -name "*.hellwal" -printf "%f\n" | sed 's/\.hellwal$//' | rofi -dmenu -p "󰏘 " -theme "$ROFI_THEME")

    if [[ -n "$choice" ]]; then
        # Apply the theme using hellwal (assuming this is how you activate themes)
        hellwal -t "$HELLWALL_THEME_DIR/$choice.hellwal"
        pywalfox update


        # Send a notification
        notify-send -e -h string:x-canonical-private-synchronous:theme_notif "Theme" "Switched to: $choice"
    fi
}

main