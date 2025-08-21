#!/bin/bash

# Verzeichnis für calcurse-Daten
CALCURSE_DIR="$HOME/.config/calcurse"

# Standard: 1 Tag (heute)
DAYS=1

# Prüfe, ob ein Argument wie -3 übergeben wurde
if [[ "$1" =~ ^-[0-9]+$ ]]; then
    DAYS="${1:1}"  # Entferne das Minuszeichen
fi

# Hole Events für die nächsten $DAYS Tage
EVENTS=$(calcurse -D $CALCURSE_DIR -d"$DAYS")

# Prüfe, ob Events vorhanden sind
if [ -z "$EVENTS" ]; then
    echo "Calcurse" "Keine Termine in den nächsten $DAYS Tagen 🎉"
else
    echo "Calcurse – Termine (nächste $DAYS Tage):"
    echo 
    echo "$EVENTS"
fi
 