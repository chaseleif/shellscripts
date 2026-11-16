#! /usr/bin/env bash

# pretty printing from Gentoo ... stripped function stubs for bins
#source /usr/libexec/rc/sh/functions.sh
ebegin() {
  if [ -x /usr/libexec/rc/bin/ebegin ] ; then
    /usr/libexec/rc/bin/ebegin "$@"
  else
    printf "   #  %s ...\n" "$@"
  fi
}
ewarn() {
  if [ -x /usr/libexec/rc/bin/ewarn ] ; then
    /usr/libexec/rc/bin/ewarn "$@"
  else
    printf "   !  %s\n" "$@"
  fi
}
einfo() {
  if [ -x /usr/libexec/rc/bin/einfo ] ; then
    /usr/libexec/rc/bin/einfo "$@"
  else
    printf "   *  %s\n" "$@"
  fi
}
eend() {
  if [ -x /usr/libexec/rc/bin/eend ] ; then
    /usr/libexec/rc/bin/eend "$@"
  elif [ "$#" -eq 0 ] ; then
    printf "[ ok ]\n"
  else
    printf "   !  %s\n" "$@"
  fi
}

tsfile="/media/ts"
srcroot="/media/music"
dstroot="/mnt"

mounted=0
perm=0
if mountpoint "$dstroot" >/dev/null ; then
  mounted=1
  if [ -w "$dstroot" ] ; then
    if [ -f "$tsfile" ] ; then
      [ -w "$tsfile" ] && perm=1
    elif [ -w "$(dirname "$tsfile")" ] ; then
      perm=1
    fi
  fi
fi

read -rd '' timestamp < "$tsfile"
[ -n "$timestamp" ] || timestamp="Jan 1 2000 01:23:45"
ebegin "Checking for new files since $timestamp"

filecount=0
errorcount=0
set +m
shopt -s lastpipe
find "$srcroot" -type f -name '*.mp3' -newermt "$timestamp" |
while read -r src ; do
  ((++filecount))
  dst="$dstroot${src#"$srcroot"}"
  einfo "$filecount: ${dst##*/}"
  if [ "$perm" -eq 1 ] ; then
    if mkdir -p "$(dirname "$dst")" ; then
      cp "$src" "$dst" || ((++errorcount))
    else
      ((++errorcount))
    fi
  fi
done

if [ "$filecount" -eq 0 ] ; then
  einfo "No new files"
  eend
elif [ "$mounted" -eq 0 ] ; then
  eend "$dstroot not mounted -- files not copied"
elif [ "$perm" -eq 0 ] ; then
  eend "$dstroot or $tsfile not writable -- files not copied"
elif [ "$errorcount" -ne 0 ] ; then
  eend "$errorcount errors -- not updating sync timestamp"
else
  einfo "files copied to $dstroot"
  date | awk '{ printf("%s %d %d %s\n", $2, $3, $6, $4) }' > "$tsfile"
  read -rd '' timestamp < "$tsfile"
  einfo "Updated timestamp to $timestamp"
  eend
fi
