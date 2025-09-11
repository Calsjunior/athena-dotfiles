#!/usr/bin/env bash
# ──────────────────────────────────────────────
# Theme switcher using Hellwal
# Applies Hyprland borders, Hyprlock color swaps, Waybar theme, SwayNC/Wlogout CSS, VS Code
# ──────────────────────────────────────────────

# ────────── Config ──────────
HELLWALL_THEME_DIR="$HOME/.config/hellwal/themes"

HYPR_CONFIG="$HOME/.config/hypr/modules/decorations.conf"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

WAYBAR_THEME_DIR="$HOME/.config/waybar/themes"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_CSS="$HOME/.config/waybar/style.css"

SWAP_CSS_FILES=(
    "$HOME/.config/swaync/style.css"
    "$HOME/.config/wlogout/wlogout.css"
)

ROFI_THEME="$HOME/.config/rofi/applets/themeSelect.rasi"
VS_CODE_SETTINGS="$HOME/.config/Code/User/settings.json"
NVIM_THEME_FILE="$HOME/.config/nvim/current_theme"

# ────────── Functions ──────────

# Apply multiple sed operations to a file
apply_sed() {
    local file=$1
    shift
    [[ -f $file ]] && sed -i "$@" "$file"
}

# Hyprland border
set_hyprland_border() {
    apply_sed "$HYPR_CONFIG" "s/col\.active_border = .*/col.active_border = $1/"
    hyprctl keyword general:col.active_border "$1"
}

# Hyprlock color swaps
set_hyprlock_color() {
    [[ -f $HYPRLOCK_CONFIG ]] || return

    case "$1" in
        "everforest")
            apply_sed "$HYPRLOCK_CONFIG" \
                -e 's/outer_color = \$color3/outer_color = $color2/' \
                -e 's/font_color = \$color3/font_color = $color2/'
            ;;
        "gruvbox-material")
            apply_sed "$HYPRLOCK_CONFIG" \
                -e 's/outer_color = \$color2/outer_color = $color3/' \
                -e 's/font_color = \$color2/font_color = $color3/'
            ;;
    esac
}

# Swap colors in CSS files
set_css_swap() {
    local pattern="s/$1/$2/g"
    for css_file in "${SWAP_CSS_FILES[@]}"; do
        apply_sed "$css_file" "$pattern"
    done
}

# VS Code theme
set_vscode_theme() {
    [[ -f $VS_CODE_SETTINGS ]] && sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$1\"/" "$VS_CODE_SETTINGS"
}

# Waybar theme
apply_waybar_theme() {
    local theme_dir="$WAYBAR_THEME_DIR/$1"

    if [[ -d $theme_dir ]]; then
        cp -f "$theme_dir"/{config.jsonc,style.css} "$HOME/.config/waybar/" 2>/dev/null
        echo "✓ Applied Waybar theme: $1"
    else
        echo "⚠ Waybar theme not found: $theme_dir"
    fi
}

# Neovim theme (file-based approach)
set_nvim_theme() {
    local nvim_theme_name=""
    
    case "$1" in
        "everforest")
            nvim_theme_name="everforest"
            ;;
        "gruvbox"|"gruvbox-material")
            nvim_theme_name="gruvbox-material"
            ;;
        *)
            nvim_theme_name="gruvbox-material"  # fallback
            ;;
    esac
    
    # Write theme to file 
    echo "$nvim_theme_name" > "$NVIM_THEME_FILE"
    echo "✓ Set Neovim theme: $nvim_theme_name"
}

# Restart applications
restart_apps() {
    local apps=("waybar" "swaync")
    for app in "${apps[@]}"; do
        if pgrep -x "$app" >/dev/null; then
            pkill -x "$app"
            sleep 0.3
            "$app" & disown
            echo "✓ Restarted $app"
        fi
    done
}

# ────────── Theme Configuration ──────────
get_theme_config() {
    case "$1" in
        "everforest")
            echo '$color2 @color3 @color2 Everforest Dark'
            ;;
        "gruvbox"|"gruvbox-material")
            echo '$color3 @color2 @color3 Gruvbox Dark Hard'
            ;;
        *)
            echo '$color7 @color1 @color7 Default Dark+'
            ;;
    esac
}

# ────────── Main ──────────
main() {
    local choice
    choice=$(find "$HELLWALL_THEME_DIR" -name "*.hellwal" -printf "%f\n" \
        | sed 's/\.hellwal$//' \
        | rofi -dmenu -p "󰏘 " -theme "$ROFI_THEME")

    [[ -z $choice ]] && return

    echo "Applying theme: $choice"
    hellwal -t "$HELLWALL_THEME_DIR/$choice.hellwal"

    # Get theme configuration
    read -r color_var swap_from swap_to vscode_theme <<< "$(get_theme_config "$choice")"

    # Apply all theme changes
    apply_waybar_theme "$choice"
    set_css_swap "$swap_from" "$swap_to"
    set_hyprland_border "$color_var"
    set_hyprlock_color "$choice"
    set_vscode_theme "$vscode_theme"
    set_nvim_theme "$choice"

    # Update Firefox
    pywalfox update

    # Restart applications
    restart_apps

    notify-send -e -h string:x-canonical-private-synchronous:theme_notif \
        "Theme" "Switched to: $choice"
}

main
