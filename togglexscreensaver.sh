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

now="$(date "+%a %b %e %H:%M:%S %Y")"
tsregex="s|^# Written by .*$|# Written by ${0##*/} on ${now}.|"

mode="$(perl -anE 'say $F[1] if /^mode:\t/' "$config")"
# argument given for new mode, we only swap between off and random
if [ -n "$1" ] && [ "$1" != "off" ] ; then
  case "$1" in
    [oO][fF][fF]* ) shift ; set -- "off" ;;
    [0]           ) shift ; set -- "off" ;;
  esac;
  [ "$1" == "$mode" ] && exit
fi

# screensaver is enabled now
if [ "$mode" == "random" ] ; then
  mode="off"
  lock="False"
  icon="$disabledicon"
# screensaver is disabled (or something else) now
else
  mode="random"
  lock="True"
  icon="$activeicon"
fi

# swap the launcher icon
sed -i "s/Icon=.*/Icon=$icon/" "$desktop"

# update timestamp
sed -i "$tsregex" "$config"
# unset the "selected" screensaver
sed -i $'s/^selected:\t.*$/selected:\t-1/' "$config"

# update mode
perl -pi -e "s/^mode:.*$/mode:\t\t$mode/" "$config"
# update lock
perl -pi -e "s/^lock:.*$/lock:\t\t$lock/" "$config"
