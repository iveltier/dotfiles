# ~/.config/hypr/scripts/hyprlock-battery.sh
#!/usr/bin/env bash
set -euo pipefail
user="$USER"
batdir="$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1 || true)"
if [[ -z "$batdir" ]]; then
  exit 0
fi

capacity="$(cat "$batdir/capacity" 2>/dev/null || echo 0)"
status="$(cat "$batdir/status" 2>/dev/null || echo Unknown)"

charging_icon=""
if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
    charging_icon="(charging)"
fi


printf "%s - %s%% %s %s\n" "$user" "$capacity" "$charging_icon" ""

