#!/usr/bin/env bash

GAME_CLASS="rct.exe"
GAME_PATH="$HOME/.wine/drive_c/ProgramData/Microsoft/Windows/Start Menu/Programs/Atari/RollerCoaster Tycoon/RollerCoaster Tycoon.lnk"

# Prüfen, ob das Spiel bereits läuft (über Hyprland-Clients)
if hyprctl clients | grep -qi "class: $GAME_CLASS"; then
    echo "Spiel läuft -> Toggle = beenden + zurücksetzen"

    # Spielprozess killen
    pkill -fi "$GAME_CLASS"

    # Warten, bis das Fenster wirklich weg ist
    while hyprctl clients | grep -qi "class: $GAME_CLASS"; do
        sleep 0.5
    done

    # Waybar wieder starten
    waybar &

    # Monitor zurücksetzen
    hyprctl reload
    exit 0
fi

echo "Spiel läuft nicht -> Toggle = starten"

# Monitor verkleinern
hyprctl keyword monitor "eDP-1,800x600,0x0,1"

# Waybar stoppen
pkill waybar

# Spiel starten (komplett detached)
nohup wine "$GAME_PATH" >/dev/null 2>&1 &

# Optional: warten, bis das Fenster erscheint
while ! hyprctl clients | grep -qi "class: $GAME_CLASS"; do
    sleep 0.5
done

exit 0
