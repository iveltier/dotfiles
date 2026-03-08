#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LAST="$HOME/.cache/last_wallpaper"
# Liste der Bilder/Videos vorbereiten
entries=""
while IFS= read -r img; do
    name=$(basename "$img")
    entries+="$name\x00icon\x1f$img\n"
done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.mp4" \) | sort)

# Auswahl mit Rofi
chosen=$(echo -e "$entries" | rofi -dmenu -i -p "choose wallpaper" -show-icons)

# Wenn Auswahl getroffen wurde
if [[ -n "$chosen" ]]; then
    file="$WALLPAPER_DIR/$chosen"
    ext="${chosen##*.}"
    ext="${ext,,}"   # lowercase

    # Erst alle mpvpaper Instanzen killen
    pkill mpvpaper 2>/dev/null

    case "$ext" in
        jpg|jpeg|png)
            # Statisches Bild → swww
            swww img "$file" --transition-type any --transition-duration 1.0

            # SDDM Hintergrund aktualisieren
            cp "$file" /usr/share/sddm/themes/silent/backgrounds/default.mp4
            rm -f "$LAST"
            ;;

        gif|mp4)
            # GIF/Video → mpvpaper
             # Beispiel: auf allen Monitoren
            mpvpaper ALL -o "loop=yes panscan=1" "$file"
            cp "$file" /usr/share/sddm/themes/silent/backgrounds/default.mp4
            echo "$file" > "$HOME/.cache/last_wallpaper"
            ;;

        *)
            notify-send "Unsupported format: $ext"
            ;;
    esac
fi

