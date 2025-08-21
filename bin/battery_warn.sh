#!/bin/bash

# Schwellenwert
THRESHOLD=20

# Hole aktuellen Batteriestand (als Zahl)
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity)

# Hole Ladezustand (Charging/Discharging)
STATUS=$(cat /sys/class/power_supply/BAT*/status)

# Wenn Batterie unter Schwelle und nicht am Laden → warnen
if [ "$BATTERY_LEVEL" -lt "$THRESHOLD" ] && [ "$STATUS" = "Discharging" ]; then
    notify-send -u critical -i battery-low "⚠️ Niedriger Akkustand" "Nur noch $BATTERY_LEVEL % übrig!"
fi
