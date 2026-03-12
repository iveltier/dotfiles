#!/bin/bash

# Konfiguration
BONGOCAT_PID_FILE="/tmp/bongocat-nvim.pid"
BONGOCAT_CONFIG="$HOME/.config/bongocat/bongocat.conf"

# Prüfe ob bongocat bereits läuft
if [ -f "$BONGOCAT_PID_FILE" ] && kill -0 "$(cat "$BONGOCAT_PID_FILE")" 2>/dev/null; then
    # Bongocat läuft -> beenden
    kill "$(cat "$BONGOCAT_PID_FILE")"
    rm "$BONGOCAT_PID_FILE"
    notify-send "Bongocat" "Gestoppt"
    exit 0
fi

# Aktuellen Workspace und Monitor ermitteln
CURRENT_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
CURRENT_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')

# Alle Fenster auf dem aktuellen Workspace prüfen
WINDOWS=$(hyprctl clients -j | jq --arg ws "$CURRENT_WORKSPACE" '
    [.[] | select(.workspace.id == ($ws | tonumber))]
')

WINDOW_COUNT=$(echo "$WINDOWS" | jq 'length')

# Prüfe ob nur ein Fenster geöffnet ist
if [ "$WINDOW_COUNT" -ne 1 ]; then
    notify-send "Bongocat" "Nicht gestartet: Auf Workspace $CURRENT_WORKSPACE sind $WINDOW_COUNT Fenster geöffnet (nicht nur nvim)"
    exit 1
fi

# Prüfe ob das einzige Fenster nvim ist
WINDOW_CLASS=$(echo "$WINDOWS" | jq -r '.[0].class' | tr '[:upper:]' '[:lower:]')
WINDOW_TITLE=$(echo "$WINDOWS" | jq -r '.[0].title' | tr '[:upper:]' '[:lower:]')

# nvim erkennen (verschiedene Varianten)
if [[ "$WINDOW_CLASS" == *"nvim"* ]] || [[ "$WINDOW_CLASS" == *"neovim"* ]] || \
   [[ "$WINDOW_TITLE" == *"nvim"* ]] || [[ "$WINDOW_TITLE" == *"neovim"* ]] || \
   [[ "$WINDOW_CLASS" == *"kitty"* && "$WINDOW_TITLE" == *"nvim"* ]] || \
   [[ "$WINDOW_CLASS" == *"alacritty"* && "$WINDOW_TITLE" == *"nvim"* ]] || \
   [[ "$WINDOW_CLASS" == *"wezterm"* && "$WINDOW_TITLE" == *"nvim"* ]] || \
   [[ "$WINDOW_CLASS" == *"foot"* && "$WINDOW_TITLE" == *"nvim"* ]]; then
    
    # Temporäre Config für spezifischen Monitor erstellen
    TEMP_CONFIG="/tmp/bongocat-nvim-$CURRENT_MONITOR.conf"
    
    # Basis-Config kopieren und Monitor setzen
    if [ -f "$BONGOCAT_CONFIG" ]; then
        cp "$BONGOCAT_CONFIG" "$TEMP_CONFIG"
    else
        # Default-Config erstellen
        cat > "$TEMP_CONFIG" << 'EOF'
cat_height=80
cat_align=center
enable_antialiasing=1
overlay_height=80
overlay_opacity=0
overlay_position=bottom
EOF
    fi
    
    # Monitor zum Config hinzufügen
    echo "monitor=$CURRENT_MONITOR" >> "$TEMP_CONFIG"
    
    # bongocat starten
    bongocat --config "$TEMP_CONFIG" --watch-config &
    BONGOCAT_PID=$!
    
    # PID speichern
    echo $BONGOCAT_PID > "$BONGOCAT_PID_FILE"
    
    notify-send "Bongocat" "Gestartet auf Monitor: $CURRENT_MONITOR (Workspace: $CURRENT_WORKSPACE, nvim erkannt)"
    
else
    notify-send "Bongocat" "Nicht gestartet: Aktives Fenster ist nicht nvim (Class: $WINDOW_CLASS)"
    exit 1
fi
