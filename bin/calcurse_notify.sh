#!/bin/bash

# Verzeichnis für calcurse-Daten
CALCURSE_DIR="$HOME/.config/calcurse"

# Standard: 1 Tag (heute)
DAYS=1

# Hole Events für die nächsten $DAYS Tage
EVENTS=$(calcurse -D $CALCURSE_DIR -d"$DAYS")

# Prüfe, ob Events vorhanden sind
if [ -z "$EVENTS" ]; then
    sleep 3
    notify-send "Calcurse" "Keine Termine heute 🎉"
else
    sleep 5
    notify-send "Calcurse – Termine (heute)" "$EVENTS"
fi
 
