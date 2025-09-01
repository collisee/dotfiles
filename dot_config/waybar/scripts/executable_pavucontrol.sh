#!/bin/bash

WIDTH=720
HEIGHT=720

RESERVED_TOP=$(hyprctl -j monitors | jq '.[0].reserved[1]' 2>/dev/null)

cursor_pos=$(hyprctl cursorpos)
x=$(echo "$cursor_pos" | awk -F', ' '{print $1}')
y=$(echo "$cursor_pos" | awk -F', ' '{print $2}')
x=$(( x - WIDTH / 2 ))

[ "$y" -lt "$RESERVED_TOP" ] && y=$RESERVED_TOP

hyprctl dispatch "exec [float; move $x $y; size $WIDTH $HEIGHT] pavucontrol -t 3"
