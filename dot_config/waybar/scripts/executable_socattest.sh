#!/bin/bash

# Function to handle events
handle_event() {
  echo "$1"  # Print every event lineX
}
# Start listening to Hyprland events using socat
socat -U -t 0.5 - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  handle_event "$line"
done
