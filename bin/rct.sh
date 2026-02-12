#!/usr/bin/env bash

# 1. Bildschirm verkleinern
hyprctl keyword monitor "eDP-1,800x600,0x0,1"

# 2. Spiel starten (komplett detached, kein Terminal)
GAME_PATH="$HOME/.wine/drive_c/ProgramData/Microsoft/Windows/Start Menu/Programs/Atari/RollerCoaster Tycoon/RollerCoaster Tycoon.lnk"
nohup wine "$GAME_PATH" >/dev/null 2>&1 &

# 3. Warten, bis das Spiel nicht mehr in Hyprland-Clients auftaucht
while hyprctl clients | grep -qi "rct\|roller\|wine"; do
    sleep 1
done

# 4. Bildschirm zurücksetzen
hyprctl reload
