# ~/.config/hypr/scripts/hyprlock-spotify.sh
#!/usr/bin/env bash
set -euo pipefail

# Benötigt: playerctl (Arch: pacman -S playerctl)

escape_pango() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Prüfe Status
state="$(playerctl -p spotify status 2>/dev/null || true)"
state_lc="$(echo "$state" | tr '[:upper:]' '[:lower:]')"

# Nichts anzeigen, wenn Spotify nicht läuft
if [[ -z "$state_lc" ]]; then
  exit 0
fi

artist="$(playerctl -p spotify metadata --format '{{artist}}' 2>/dev/null | head -n1)"
title="$(playerctl -p spotify metadata --format '{{title}}' 2>/dev/null | head -n1)"

# Keine Ausgabe, wenn nichts sinnvoll ist
if [[ -z "$artist" && -z "$title" ]]; then
  exit 0
fi

# Status-Icon
case "$state_lc" in
  playing) icon=" ";; #▶
  paused)  icon="⏸";;
  *)       icon="";; # Nerd Font
esac

line="${artist} - ${title}"

# Kürzen für die Lockscreen-Breite
maxlen=80
if (( ${#line} > maxlen )); then
  line="${line:0:maxlen}…"
fi

printf "%s %s\n" "$icon" "$(printf "%s" "$line" | escape_pango)"

