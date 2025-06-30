#!/bin/bash

WALLPAPER="$HOME/Wallpapers/l.jpg"

CONFIG="$HOME/.config/hypr/hyprpaper.conf"

echo "preload = $WALLPAPER" > "$CONFIG"
hyprctl monitors | grep "Monitor" | awk '{print $2}' | while read -r MONITOR; do
	echo "wallpaper = $MONITOR,$WALLPAPER" >> "$CONFIG"
done

killall hyprpaper 2>/dev/null
hyprpaper &
