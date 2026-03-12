#!/bin/bash
# ~/.config/hypr/scripts/auto-bongocat.sh

BONGOCAT_PID_FILE="/tmp/bongocat-auto.pid"
LAST_STATE=""

while true; do
    CURRENT_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
    CURRENT_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
    
    WINDOWS=$(hyprctl clients -j | jq --arg ws "$CURRENT_WORKSPACE" '
        [.[] | select(.workspace.id == ($ws | tonumber))]
    ')
    
    WINDOW_COUNT=$(echo "$WINDOWS" | jq 'length')
    WINDOW_CLASS=$(echo "$WINDOWS" | jq -r '.[0].class // empty' | tr '[:upper:]' '[:lower:]')
    WINDOW_TITLE=$(echo "$WINDOWS" | jq -r '.[0].title // empty' | tr '[:upper:]' '[:lower:]')
    
    # Prüfe ob nur nvim läuft
    IS_NVIM_ONLY=false
    if [ "$WINDOW_COUNT" -eq 1 ]; then
        if [[ "$WINDOW_CLASS" == *"nvim"* ]] || [[ "$WINDOW_TITLE" == *"nvim"* ]] || \
           [[ "$WINDOW_CLASS" == *"kitty"* && "$WINDOW_TITLE" == *"nvim"* ]] || \
           [[ "$WINDOW_CLASS" == *"alacritty"* && "$WINDOW_TITLE" == *"nvim"* ]]; then
            IS_NVIM_ONLY=true
        fi
    fi
    
    CURRENT_STATE="${CURRENT_WORKSPACE}:${CURRENT_MONITOR}:${IS_NVIM_ONLY}"
    
    # State changed?
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        if [ "$IS_NVIM_ONLY" = true ]; then
            # Starte bongocat wenn nicht bereits läuft
            if [ ! -f "$BONGOCAT_PID_FILE" ] || ! kill -0 "$(cat "$BONGOCAT_PID_FILE)" 2>/dev/null; then
                TEMP_CONFIG="/tmp/bongocat-auto-$CURRENT_MONITOR.conf"
                echo "monitor=$CURRENT_MONITOR" > "$TEMP_CONFIG"
                bongocat --config "$TEMP_CONFIG" &
                echo $! > "$BONGOCAT_PID_FILE"
            fi
        else
            # Stoppe bongocat wenn läuft
            if [ -f "$BONGOCAT_PID_FILE" ] && kill -0 "$(cat "$BONGOCAT_PID_FILE")" 2>/dev/null; then
                kill "$(cat "$BONGOCAT_PID_FILE")"
                rm "$BONGOCAT_PID_FILE"
            fi
        fi
        LAST_STATE="$CURRENT_STATE"
    fi
    
    sleep 0.5
done
