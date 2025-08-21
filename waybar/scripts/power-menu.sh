#!/bin/bash
chosen=$(echo -e "⏻ Shutdown\n⟳ Restart\n⊘ Logout" | rofi -dmenu -i -p "⏻" -config "~/.config/rofi/powermenu_config.rasi")

if [[ "$chosen" == "⏻ Shutdown" ]]; then
    systemctl poweroff
elif [[ "$chosen" == "⟳ Restart" ]]; then
    systemctl reboot
elif [[ "$chosen" == "⊘ Logout" ]]; then
    hyprctl dispatch exit
fi
