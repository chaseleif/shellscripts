#! /usr/bin/env bash

#xscreensaver .config
config="${HOME}/.xscreensaver"
#launcher desktop
desktop="${HOME}/.config/xfce4/panel/launcher-18/17583225581.desktop"
disabledicon="totem"
#disabledicon="face-surprise"
activeicon="user"

if ! [ -f "$config" ] ; then
  echo "No xscreensaver config file to modify!"
  exit
fi
if ! [ -f "$desktop" ] ; then
  echo "No launcher.desktop file to modify!"
  exit
fi

state="$(perl -anE 'say $F[1] if /^mode:\t/' "$config")"
# screensaver is enabled now
if [ "$state" == "random" ] ; then
  # script was invoked with an argument for "to become" and it isn't off
  if [ -n "$1" ] && [ "$1" != "off" ] ; then
    exit
  fi
  # change xscreensaver mode to off
  sed -i $'s/^mode:\t\trandom/mode:\t\toff/' "$config"
  # set the icon for xscreensaver disabled
  icon="$disabledicon"
# screensaver is disabled now
elif [ "$state" == "off" ] ; then
  # script was invoked with an argument for "to become" and it wasn't random
  if [ -n "$1" ] && [ "$1" != "random" ] ; then
    exit
  fi
  # change xscreensaver mode to random
  sed -i $'s/^mode:\t\toff/mode:\t\trandom/' "$config"
  # set the icon for xscreensaver enabled
  icon="$activeicon"
fi

# update timestamp
now="$(date "+%a %b %e %H:%M:%S %Y")"
regex="s|^# Written by .*$|# Written by ${0##*/} on ${now}.|"
sed -i "$regex" "$config"

# unset the "selected" screensaver
sed -i $'s/^selected:\t.*$/selected:\t-1/' "$config"

# swap the launcher icon
sed -i "s/Icon=.*/Icon=$icon/" "$desktop"
