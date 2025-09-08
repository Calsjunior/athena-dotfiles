#!/usr/bin/env bash
# ┏┳┓┓┏┏┓┳┳┓┏┓  ┏┓┏┓┓ ┏┓┏┓┏┳┓
#  ┃ ┣┫┣ ┃┃┃┣ ━━┗┓┣ ┃ ┣ ┃  ┃
#  ┻ ┛┗┗┛┛ ┗┗┛  ┗┛┗┛┗┛┗┛┗┛ ┻
#
# Theme switcher using hellwal

HELLWALL_THEME_DIR="$HOME/.config/hellwal/themes"
HYPR_CONFIG="$HOME/.config/hypr/modules/decorations.conf"
WAYBAR_THEME_DIR="$HOME/.config/waybar/themes"
SWAYNC_THEME_DIR="$HOME/.config/swaync/themes"
ROFI_THEME="$HOME/.config/rofi/applets/themeSelect.rasi"

WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"

WAYBAR_CSS="$HOME/.config/waybar/style.css"
SWAYNC_CSS="$HOME/.config/swaync/style.css"
WLOGOUT_CSS="$HOME/.config/wlogout/wlogout.css"

main() {
    choice=$(find "$HELLWALL_THEME_DIR" -name "*.hellwal" -printf "%f\n" | sed 's/\.hellwal$//' | rofi -dmenu -p "󰏘 " -theme "$ROFI_THEME")

    if [[ -n "$choice" ]]; then

        # Apply the hellwal theme
        hellwal -t "$HELLWALL_THEME_DIR/$choice.hellwal"

        # Apply theme-specific border in hyprland and wlogout color
        case "$choice" in
            "everforest")
                sed -i 's/col\.active_border = .*/col.active_border = $color2/' "$HYPR_CONFIG"
                hyprctl keyword general:col.active_border '$color2'

                sed -i 's/@color3/@color2/g' "$WLOGOUT_CSS"
                ;;
            "gruvbox"|"gruvbox-material")
                sed -i 's/col\.active_border = .*/col.active_border = $color3/' "$HYPR_CONFIG"
                hyprctl keyword general:col.active_border '$color3'

                sed -i 's/@color2/@color3/g' "$WLOGOUT_CSS"
                ;;
        esac

        # Apply Waybar theme
        if [[ -f "$WAYBAR_THEME_DIR/$choice/style.css" ]]; then
            cp "$WAYBAR_THEME_DIR/$choice/config.jsonc" "$WAYBAR_CONFIG"
            cp "$WAYBAR_THEME_DIR/$choice/style.css" "$WAYBAR_CSS"
        fi

        # Apply SwayNC CSS theme
        if [[ -f "$SWAYNC_THEME_DIR/$choice/style.css" ]]; then
            cp "$SWAYNC_THEME_DIR/$choice/style.css" "$SWAYNC_CSS"
        fi

        # Apply Wlogout theme


        # Restart applications
        pkill waybar; waybar &
        pkill swaync; swaync &

        notify-send -e -h string:x-canonical-private-synchronous:theme_notif "Theme" "Switched to: $choice"
    fi
}

main