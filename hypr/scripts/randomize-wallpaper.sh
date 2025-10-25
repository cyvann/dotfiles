#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

if [ $1 = "-harsh" ]; then
    ~/.config/hypr/scripts/set-wallpaper-reload.sh "$WALLPAPER"
else
    ~/.config/hypr/scripts/set-wallpaper.sh "$WALLPAPER"
fi
