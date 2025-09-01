#!/bin/bash

WIDTH=720
HEIGHT=720

cursor_pos=$(hyprctl cursorpos)
x=$(echo "$cursor_pos" | awk -F', ' '{print $1}')
y=$(echo "$cursor_pos" | awk -F', ' '{print $2}')
x=$(( x - WIDTH / 2 ))

[ "$y" -lt 44 ] && y=44

hyprctl dispatch "exec [noanim; float; move $x $y; size $WIDTH $HEIGHT] pavucontrol -t 3"
