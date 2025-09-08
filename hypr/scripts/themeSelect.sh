#!/usr/bin/env bash
# Theme switcher using hellwal
# Works for Hyprland, CSS, Waybar/SwayNC, and VS Code

# ────────── Config ──────────
HELLWALL_THEME_DIR="$HOME/.config/hellwal/themes"
WAYBAR_THEME_DIR="$HOME/.config/waybar/themes"
SWAYNC_THEME_DIR="$HOME/.config/swaync/themes"
HYPR_CONFIG="$HOME/.config/hypr/modules/decorations.conf"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_CSS="$HOME/.config/waybar/style.css"
SWAYNC_CSS="$HOME/.config/swaync/style.css"
WLOGOUT_CSS="$HOME/.config/wlogout/wlogout.css"
ROFI_THEME="$HOME/.config/rofi/applets/themeSelect.rasi"
VS_CODE_SETTINGS="$HOME/.config/Code/User/settings.json"

# ────────── Functions ──────────

set_hyprland_border() {
    local color_var=$1  # literal string: '$color2' or '$color3'
    sed -i "s/col\.active_border = .*/col.active_border = $color_var/" "$HYPR_CONFIG"
    hyprctl keyword general:col.active_border "$color_var"
}

set_css_hover() {
    local from=$1
    local to=$2
    for css_file in "$WLOGOUT_CSS" "$WAYBAR_CSS" "$SWAYNC_CSS"; do
        [[ -f $css_file ]] && sed -i "s/$from/$to/g" "$css_file"
    done
}

set_vscode_theme() {
    local theme_name=$1
    [[ -f $VS_CODE_SETTINGS ]] && \
        sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$theme_name\"/" "$VS_CODE_SETTINGS"
}

apply_waybar_theme() {
    local theme=$1  # Fixed: now accepts parameter
    local theme_dir="$WAYBAR_THEME_DIR/$theme"

    echo "Looking for waybar theme at: $theme_dir"

    if [[ -d $theme_dir ]]; then
        [[ -f $theme_dir/config.jsonc ]] && {
            cp "$theme_dir/config.jsonc" "$WAYBAR_CONFIG"
            echo "✓ Applied waybar config"
        }
        [[ -f $theme_dir/style.css ]] && {
            cp "$theme_dir/style.css" "$WAYBAR_CSS"
            echo "✓ Applied waybar CSS"
        }
    else
        echo "⚠ Waybar theme directory not found: $theme_dir"
        return 1
    fi
}

apply_swaync_theme() {
    local theme=$1  # Fixed: now accepts parameter
    local theme_dir="$SWAYNC_THEME_DIR/$theme"

    echo "Looking for swaync theme at: $theme_dir"

    if [[ -d $theme_dir ]]; then
        [[ -f $theme_dir/style.css ]] && {
            cp "$theme_dir/style.css" "$SWAYNC_CSS"
            echo "✓ Applied swaync CSS"
        }
    else
        echo "⚠ SwayNC theme directory not found: $theme_dir"
        return 1
    fi
}

# ────────── Main ──────────
main() {
    choice=$(find "$HELLWALL_THEME_DIR" -name "*.hellwal" -printf "%f\n" | sed 's/\.hellwal$//' | \
        rofi -dmenu -p "󰏘 " -theme "$ROFI_THEME")

    [[ -z $choice ]] && return

    echo "Applying theme: $choice"

    # Apply hellwal theme first
    echo "Applying hellwal theme..."
    hellwal -t "$HELLWALL_THEME_DIR/$choice.hellwal"

    # Map theme settings
    case "$choice" in
        "everforest")
            border_color='$color2'   # literal $color2
            hover_from='@color3'
            hover_to='@color2'
            vscode_theme="Everforest Dark"
            ;;
        "gruvbox"|"gruvbox-material")
            border_color='$color3'   # literal $color3
            hover_from='@color2'
            hover_to='@color3'
            vscode_theme="Gruvbox Dark Hard"
            ;;
        *)
            echo "Theme $choice not handled, using defaults."
            border_color='$color7'
            hover_from='@color1'
            hover_to='@color7'
            vscode_theme="Default Dark+"
            ;;
    esac

    # Apply Waybar and SwayNC themes
    apply_waybar_theme "$choice"
    apply_swaync_theme "$choice"

    # Apply CSS hover changes after theme files
    set_css_hover "$hover_from" "$hover_to"

    # Apply Hyprland border
    set_hyprland_border "$border_color"

    # Apply VS Code theme
    set_vscode_theme "$vscode_theme"

    # Restart apps to apply theme
    echo "Restarting applications..."

    if pgrep waybar >/dev/null; then
        pkill waybar
        sleep 0.3  # Increased wait time
        waybar & disown
        echo "✓ Restarted waybar"
    fi

    if pgrep swaync >/dev/null; then
        pkill swaync
        sleep 0.3  # Increased wait time
        swaync & disown
        echo "✓ Restarted swaync"
    fi

    notify-send -e -h string:x-canonical-private-synchronous:theme_notif \
        "Theme" "Switched to: $choice"
}

main