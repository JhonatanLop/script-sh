#!/bin/bash

move_cursor() {
    mouseposition=$(hyprctl cursorpos) # output is "X, Y"

    # Split the output into X and Y
    IFS=', ' read -r -a array <<< "$mouseposition"
    X=${array[0]}
    Y=${array[1]}
    
    if [ "$2" == "fast" ]; then
        cursor_speed=75
    else
        cursor_speed=30
    fi

    if [ "$1" == "up" ]; then
        Y=$((Y - cursor_speed))
    elif [ "$1" == "down" ]; then
        Y=$((Y + cursor_speed))
    elif [ "$1" == "left" ]; then
        X=$((X - cursor_speed))
    elif [ "$1" == "right" ]; then
        X=$((X + cursor_speed))
    fi

    hyprctl dispatch movecursor $X $Y
    xdotool mousemove $X $Y 
}

move_cursor "$1" "$2"
