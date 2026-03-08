#!/bin/bash

LAST="$HOME/.cache/last_wallpaper"

if [[ -f "$LAST" ]]; then
    file=$(cat "$LAST")
    ext="${file##*.}"
    ext="${ext,,}"

    pkill mpvpaper 2>/dev/null

    case "$ext" in
        jpg|jpeg|png)
            swww img "$file" --transition-type any --transition-duration 1.0
            ;;
        gif|mp4)
            mpvpaper -o "loop=yes panscan=1" "*" "$file"
            ;;
    esac
fi

