#!/bin/bash
# bongocat-socket-daemon.sh - Effizientere Version mit Hyprland Socket

BONGOCAT_PID_FILE="/tmp/bongocat-nvim.pid"
DAEMON_PID_FILE="/tmp/bongocat-daemon.pid"
BONGOCAT_CONFIG="$HOME/.config/bongocat/bongocat.conf"

# Cleanup
cleanup() {
    rm -f "$DAEMON_PID_FILE" "$BONGOCAT_PID_FILE"
    pkill -f "socat.*HYPRLAND_INSTANCE_SIGNATURE" 2>/dev/null
    exit 0
}
trap cleanup SIGTERM SIGINT

echo $$ > "$DAEMON_PID_FILE"

# Aktuellen Zustand prüfen und bongocat starten wenn nötig
check_and_update() {
    local current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
    local windows=$(hyprctl clients -j | jq --arg ws "$current_ws" '[.[] | select(.workspace.id == ($ws | tonumber))]')
    local window_count=$(echo "$windows" | jq 'length')
    local current_monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
    
    if [ "$window_count" -eq 1 ]; then
        local window_class=$(echo "$windows" | jq -r '.[0].class' | tr '[:upper:]' '[:lower:]')
        local window_title=$(echo "$windows" | jq -r '.[0].title' | tr '[:upper:]' '[:lower:]')
        
        if [[ "$window_class" == *"nvim"* ]] || [[ "$window_class" == *"neovim"* ]] || \
           [[ "$window_title" == *"nvim"* ]] || [[ "$window_title" == *"neovim"* ]] || \
           [[ "$window_class" == *"kitty"* && "$window_title" == *"nvim"* ]] || \
           [[ "$window_class" == *"alacritty"* && "$window_title" == *"nvim"* ]] || \
           [[ "$window_class" == *"wezterm"* && "$window_title" == *"nvim"* ]] || \
           [[ "$window_class" == *"foot"* && "$window_title" == *"nvim"* ]]; then
            
            if [ ! -f "$BONGOCAT_PID_FILE" ] || ! kill -0 "$(cat "$BONGOCAT_PID_FILE")" 2>/dev/null; then
                # Starte bongocat
                local temp_config="/tmp/bongocat-nvim-$current_monitor.conf"
                [ -f "$BONGOCAT_CONFIG" ] && cp "$BONGOCAT_CONFIG" "$temp_config" || echo -e "cat_height=80\ncat_align=center\nenable_antialiasing=1" > "$temp_config"
                echo "monitor=$current_monitor" >> "$temp_config"
                
                bongocat --config "$temp_config" --watch-config &
                echo $! > "$BONGOCAT_PID_FILE"
                notify-send "Bongocat" "Gestartet auf $current_monitor"
            fi
            return
        fi
    fi
    
    # Wenn wir hier sind, ist nvim nicht aktiv -> stoppen
    if [ -f "$BONGOCAT_PID_FILE" ]; then
        kill "$(cat "$BONGOCAT_PID_FILE")" 2>/dev/null
        rm -f "$BONGOCAT_PID_FILE"
        notify-send "Bongocat" "Gestoppt"
    fi
}

# Initial check
check_and_update

# Auf Hyprland Events hören (Workspace-Wechsel, Fenster schließen/öffnen)
socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r line; do
    case "$line" in
        workspace*|openwindow*|closewindow*|movewindow*)
            check_and_update
            ;;
    esac
done
