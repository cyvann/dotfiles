#!/usr/bin/env bash

if [ -f "$1" ]; then
    ~/.config/hypr/scripts/set-wallpaper.sh $1; 
    sleep 1;
else
    echo "File does not exist: $1";
fi


