#!/bin/bash

TEMP_FILE="/tmp/pavucontrol_addr"

if pgrep -x pavucontrol > /dev/null; then
    echo "pavucontrol is running."

    if [ -f "$TEMP_FILE" ] && [ -s "$TEMP_FILE" ]; then
        addr=$(cat "$TEMP_FILE")
        echo "Closing pavucontrol using saved address: $addr"
        hyprctl dispatch closewindow address:0x$addr
        rm -f "$TEMP_FILE"
    else
        echo "Temp file not found or empty. Searching for window address..."

        addr=$(hyprctl -j clients | jq -r '.[] | select(.class=="org.pulseaudio.pavucontrol") | .address')

        if [ -n "$addr" ]; then
            echo "Found window address: $addr"
            echo "$addr" > "$TEMP_FILE"
            hyprctl dispatch focuswindow address:0x$addr
        else
            echo "Warning: Could not find pavucontrol window address"
        fi
    fi
else
    echo "Opening pavucontrol"
    WIDTH=720
    HEIGHT=720

    RESERVED_TOP=$(hyprctl -j monitors | jq '.[0].reserved[1]' 2>/dev/null)

    cursor_pos=$(hyprctl cursorpos)
    x=$(echo "$cursor_pos" | awk -F', ' '{print $1}')
    y=$(echo "$cursor_pos" | awk -F', ' '{print $2}')
    x=$(( x - WIDTH / 2 ))

    [ "$y" -lt "$RESERVED_TOP" ] && y=$RESERVED_TOP

    hyprctl dispatch "exec [float; move $x $y; size $WIDTH $HEIGHT] pavucontrol -t 3"

    {
        socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | \
        while read -r line; do
            echo "$line"
            if echo "$line" | grep -q "openwindow>>" && echo "$line" | grep -q "org.pulseaudio.pavucontrol"; then
                addr=$(echo "$line" | sed -n 's/openwindow>>\([^,]*\),.*/\1/p')
                echo "Saving pavucontrol address: $addr"
                echo "$addr" > "$TEMP_FILE"
                pkill -f "socat.*hypr.*socket2"
                break
            fi
        done
    } 2>/dev/null

    if [ -f "$TEMP_FILE" ] && [ -s "$TEMP_FILE" ]; then
        saved_addr=$(cat "$TEMP_FILE")
        echo "Successfully saved pavucontrol address: $saved_addr"
    else
        echo "Warning: Could not capture pavucontrol window address"
    fi
fi