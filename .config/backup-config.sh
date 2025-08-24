#!/bin/bash

# Zielverzeichnis
BACKUP_DIR="$HOME/Documents/dotfiles"
mkdir -p "$BACKUP_DIR"

# Dateien und Ordner, die gesichert werden sollen
FOLDERS=(
    "$HOME/.config/hypr/hyprland.conf"
    "$HOME/.config/hypr/hyprlock.conf"
    "$HOME/.config/hypr/scripts"
    "$HOME/.config/waybar"
    "$HOME/.config/nvim"
    "$HOME/.config/rofi"
    "$HOME/.config/wallpaperswitcher"
    "$HOME/.config/fastfetch"
    "$HOME/.config/kitty"
    "$HOME/.local/bin"
    "/usr/local/bin/tux"
    "/usr/local/bin/power-menu.sh"
    "$HOME/.config/backup-config.sh"
)

# Synchronisieren
#
for ITEM in "${FOLDERS[@]}"; do
    BASENAME="$(basename "$ITEM")"
    if [ -d "$ITEM" ]; then
        rsync -a --delete "$ITEM/" "$BACKUP_DIR/$BASENAME/"
    elif [ -f "$ITEM" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$ITEM" | sed "s|$HOME/||")"
        cp "$ITEM" "$BACKUP_DIR/$(dirname "$ITEM" | sed "s|$HOME/||")/"
    fi
done

# Git-Operationen
cd "$BACKUP_DIR"

if [ -d .git ]; then
    git add .
    if ! git diff --quiet || ! git diff --cached --quiet; then
        git add .
        git commit -m "Backup on shutdown: $(date)"
        git push origin main
	notify-send -u normal "backup done"
    else
	notify-send -u low "no changes detected - no push required."
    fi
else
    notify-send -u critical "Warning: $BACKUP_DIR is not a Git-Repository."
fi

