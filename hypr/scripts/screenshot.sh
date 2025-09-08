#!/usr/bin/env bash
# ┏┓┏┓┳┓┏┓┏┓┳┓┏┓┓┏┏┓┏┳┓
# ┗┓┃ ┣┫┣ ┣ ┃┃┗┓┣┫┃┃ ┃
# ┗┛┗┛┛┗┗┛┗┛┛┗┗┛┛┗┗┛ ┻
#
# Optimized Screenshots script

# Configuration
readonly SCRIPT_DIR="$HOME/.config/hypr/scripts"
readonly NOTIFY_CMD="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low"
readonly SCREENSHOT_DIR="$(xdg-user-dir)/Pictures/screenshots"
readonly SOUNDS_SCRIPT="${SCRIPT_DIR}/sounds.sh"

# Ensure screenshot directory exists
[[ ! -d "$SCREENSHOT_DIR" ]] && mkdir -p "$SCREENSHOT_DIR"

# Generate filename
generate_filename() {
    local time=$(date "+%d-%b_%H-%M-%S")
    echo "Screenshot_${time}_${RANDOM}.png"
}

# Take full screen screenshot
take_now() {
    local file=$(generate_filename)
    local filepath="${SCREENSHOT_DIR}/${file}"

    if grim "$filepath" && wl-copy < "$filepath"; then
        ${NOTIFY_CMD} "Screenshot Saved."
        [[ -x "$SOUNDS_SCRIPT" ]] && "$SOUNDS_SCRIPT" --screenshot
    else
        ${NOTIFY_CMD} "Screenshot NOT Saved."
    fi
}

# Take area screenshot with swappy editor
take_swappy() {
    local tmpfile=$(mktemp)

    if grim -g "$(slurp)" "$tmpfile" 2>/dev/null && [[ -s "$tmpfile" ]]; then
        ${NOTIFY_CMD} "Screenshot Captured."
        [[ -x "$SOUNDS_SCRIPT" ]] && "$SOUNDS_SCRIPT" --screenshot
        swappy -f "$tmpfile"
    fi

    rm -f "$tmpfile"
}

# Main logic
case "$1" in
    --now)   take_now ;;
    --swappy) take_swappy ;;
    *)       echo "Available Options: --now --swappy" ;;
esac