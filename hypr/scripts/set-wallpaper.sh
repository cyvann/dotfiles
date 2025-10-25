#!/usr/bin/env bash

if [ -f "$1" ]; then
    hyprctl hyprpaper reload ,"$1"

    if [ "$2" = "light" ]; then
        wal -n -l -i "$1" --cols16 darken --backend colorthief
    else
        wal -n -i "$1" --cols16 darken --backend colorthief
    fi
    cp ~/.cache/wal/colors-cava ~/.config/cava/config
    pkill -USR2 cava

    cp ~/.cache/wal/colors-vesktop.css ~/.config/vesktop/themes/pywal-generated-theme-copied.css

else
    echo "File does not exist: $1";
fi


