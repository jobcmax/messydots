#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg main  cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

echo "Bars launched..."
