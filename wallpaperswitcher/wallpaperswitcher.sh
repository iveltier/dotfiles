#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LAST="$HOME/.cache/last_wallpaper"
CACHE_DIR="$HOME/.cache/wallpaper_history"
HISTORY_FILE="$CACHE_DIR/history"

# Cache-Verzeichnis erstellen falls nicht vorhanden
mkdir -p "$CACHE_DIR"

# Alle verfügbaren Bilder finden
mapfile -t all_files < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.mp4" \) | sort)

# Historie laden (falls existiert) - jede Zeile ist ein Pfad
declare -A last_used
if [[ -f "$HISTORY_FILE" ]]; then
    line_num=0
    while IFS= read -r line; do
        if [[ -f "$line" ]]; then
            last_used["$line"]=$line_num
            ((line_num++))
        fi
    done < "$HISTORY_FILE"
fi

# Sortierfunktion: Zuerst nach Historie (neueste zuerst), dann alphabetisch
sort_files() {
    local file="$1"
    local priority=999999
    
    if [[ -n "${last_used[$file]}" ]]; then
        priority=${last_used[$file]}
    fi
    
    echo "$priority $file"
}

# Dateien sortieren
sorted_files=()
while IFS= read -r sorted_line; do
    # Extrahiere nur den Pfad (nach dem ersten Leerzeichen)
    file_path="${sorted_line#* }"
    sorted_files+=("$file_path")
done < <(for f in "${all_files[@]}"; do sort_files "$f"; done | sort -n)

# Rofi-Einträge vorbereiten
entries=""
for img in "${sorted_files[@]}"; do
    name=$(basename "$img")
    # Markiere zuletzt genutztes Wallpaper mit einem Symbol
    marker=""
    if [[ -f "$LAST" ]] && [[ "$(cat "$LAST")" == "$img" ]]; then
        marker="★ "
    fi
    entries+="${marker}${name}\x00icon\x1f${img}\n"
done

# Auswahl mit Rofi
chosen=$(echo -e "$entries" | rofi -dmenu -i -p "choose wallpaper" -show-icons)

# Marker entfernen falls vorhanden
chosen="${chosen#★ }"

# Wenn Auswahl getroffen wurde
if [[ -n "$chosen" ]]; then
    file="$WALLPAPER_DIR/$chosen"
    ext="${chosen##*.}"
    ext="${ext,,}"   # lowercase

    # Zur Historie hinzufügen (am Anfang, Duplikate entfernen)
    if [[ -f "$HISTORY_FILE" ]]; then
        # Temporäre Datei ohne das aktuelle Bild
        grep -vFx "$file" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" 2>/dev/null || true
        # Aktuelles Bild oben hinzufügen
        echo "$file" > "$HISTORY_FILE"
        cat "$HISTORY_FILE.tmp" >> "$HISTORY_FILE" 2>/dev/null || true
        rm -f "$HISTORY_FILE.tmp"
        # Maximale Historie auf 50 Einträge begrenzen
        head -n 50 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    else
        echo "$file" > "$HISTORY_FILE"
    fi

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
# WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
# LAST="$HOME/.cache/last_wallpaper"
# # Liste der Bilder/Videos vorbereiten
# entries=""
# while IFS= read -r img; do
#     name=$(basename "$img")
#     entries+="$name\x00icon\x1f$img\n"
# done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.mp4" \) | sort)
#
# # Auswahl mit Rofi
# chosen=$(echo -e "$entries" | rofi -dmenu -i -p "choose wallpaper" -show-icons)
#
# # Wenn Auswahl getroffen wurde
# if [[ -n "$chosen" ]]; then
#     file="$WALLPAPER_DIR/$chosen"
#     ext="${chosen##*.}"
#     ext="${ext,,}"   # lowercase
#
#     # Erst alle mpvpaper Instanzen killen
#     pkill mpvpaper 2>/dev/null
#
#     case "$ext" in
#         jpg|jpeg|png)
#             # Statisches Bild → swww
#             swww img "$file" --transition-type any --transition-duration 1.0
#
#             # SDDM Hintergrund aktualisieren
#             cp "$file" /usr/share/sddm/themes/silent/backgrounds/default.mp4
#             rm -f "$LAST"
#             ;;
#
#         gif|mp4)
#             # GIF/Video → mpvpaper
#              # Beispiel: auf allen Monitoren
#             mpvpaper ALL -o "loop=yes panscan=1" "$file"
#             cp "$file" /usr/share/sddm/themes/silent/backgrounds/default.mp4
#             echo "$file" > "$HOME/.cache/last_wallpaper"
#             ;;
#
#         *)
#             notify-send "Unsupported format: $ext"
#             ;;
#     esac
# fi

