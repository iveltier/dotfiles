#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Liste der Bilder mit Icons vorbereiten
entries=""
while IFS= read -r img; do
    name=$(basename "$img")
    entries+="$name\x00icon\x1f$img\n"
done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort)

# Auswahl mit Rofi und Icons
chosen=$(echo -e "$entries" | rofi -dmenu -i -p "choose wallpaper" -show-icons)

# Wenn Auswahl getroffen wurde
if [[ -n "$chosen" ]]; then
    swww img "$WALLPAPER_DIR/$chosen" --transition-type any --transition-duration 1.0
    cp "$WALLPAPER_DIR/$chosen" /usr/share/sddm/themes/silent/backgrounds/default.jpg
fi
