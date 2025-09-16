#! /usr/bin/env bash

# chbkg.sh
# Change the background to a random image with feh

# DISPLAY may not be set, e.g., when ran from cron
# this default may need to change: echo "$DISPLAY"
# set DISPLAY to ":0.0" if it isn't defined or is empty
: "${DISPLAY:=":0.0"}"
# The path with the images to choose from
bgdir="/usr/share/backgrounds"

# Only run if the display is available
xdpyinfo -display "$DISPLAY" >/dev/null 2>&1 || exit

# Get a list of xscreensaver pids
mapfile -t screensaver < <(pgrep xscreensaver)
# If the screensaver is running then there will be at least 2 processes
if [ "${#screensaver[@]}" -lt 2 ] ; then
  DISPLAY="$DISPLAY" feh --no-fehbg -z --bg-scale "$bgdir"
fi
