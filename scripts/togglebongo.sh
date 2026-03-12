#!/bin/bash

DAEMON_PID_FILE="/tmp/bongocat-daemon.pid"
DAEMON_SCRIPT="$HOME/.config/hypr/scripts/autobongo.sh"

# Prüfe ob Daemon läuft
if [ -f "$DAEMON_PID_FILE" ] && kill -0 "$(cat "$DAEMON_PID_FILE")" 2>/dev/null; then
    # Daemon läuft -> alles stoppen
    DAEMON_PID=$(cat "$DAEMON_PID_FILE")
    
    # Daemon beenden (cleanup stoppt auch bongocat)
    kill "$DAEMON_PID" 2>/dev/null
    
    # Warte auf Beendigung
    wait "$DAEMON_PID" 2>/dev/null
    
    notify-send "Bongocat" "Daemon gestoppt (Auto-Modus aus)"
    echo "Bongocat Auto-Modus: AUS"
else
    # Daemon starten
    if [ -f "$DAEMON_SCRIPT" ]; then
        "$DAEMON_SCRIPT" &
        sleep 0.5
        if [ -f "$DAEMON_PID_FILE" ]; then
            notify-send "Bongocat" "Daemon gestartet (Auto-Modus an)"
            echo "Bongocat Auto-Modus: AN (PID: $(cat "$DAEMON_PID_FILE"))"
        else
            echo "Fehler: Daemon konnte nicht gestartet werden"
            exit 1
        fi
    else
        echo "Fehler: Daemon-Skript nicht gefunden: $DAEMON_SCRIPT"
        exit 1
    fi
fi
