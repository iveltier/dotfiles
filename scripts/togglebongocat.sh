#!/bin/bash

# Toggle BongoCat - läuft unter Wayland/Hyprland
# Speichert PID in /tmp um Status zu tracken

PIDFILE="/tmp/bongocat.pid"

if [ -f "$PIDFILE" ]; then
    # BongoCat läuft - beenden
    PID=$(cat "$PIDFILE")
    if kill "$PID" 2>/dev/null; then
        rm -f "$PIDFILE"
    else
        # Prozess existiert nicht mehr, aufräumen
        rm -f "$PIDFILE"
    fi
else
    # BongoCat starten
    bongocat &
    PID=$!
    echo $PID > "$PIDFILE"
fi
