#! /usr/bin/env bash

# The dvd device, /dev/$dvd
dvd=sr0
# The dvd mount point
dvdmount=/media
# The dvd output path is $(pwd)
# Set region to NTSC to give burned DVD a region
# Or leave commented for region-free
#makeregion=NTSC

function mountdrive() {
  mounted=$(lsblk | grep "$dvd" | awk '{print $7}')
  if [ -n "$mounted" ] && [ "$mounted" != "$dvdmount" ] ; then
    sudo umount "$mounted"
  fi
  if ! mountpoint $dvdmount >/dev/null 2>&1 ; then
    echo "Mounting $dvd to $dvdmount"
    sudo mount /dev/$dvd $dvdmount
  fi
}
function ripdvd() {
  mountdrive
  dvdname=$(vobcopy -I 2>&1 | grep DVD-name | cut -d' ' -f3)
  echo "Ripping DVD $dvdname . . ."
  #dvdbackup -i /dev/$dvd -o . -M
  vobcopy -v -m
  echo "Ripped ${dvdname}, unmounting DVD"
  sudo umount $dvdmount
}
function getdvdname() {
  if [ -z "$dvdname" ] ; then
    read -r -p "Enter DVD directory name: " dvdname
  fi
}
function getisoname() {
  if [ -z "$isoname" ] ; then
    read -r -p "Enter ISO file name: " isoname
  fi
}
function makeiso() {
  echo "Creating ISO . . ."
  isoname=${dvdname}.iso
  mkisofs -dvd-video -udf -o "${isoname}" "${dvdname}"
}
function burniso() {
  if [ -n "$makeregion" ] ; then
    export VIDEO_FORMAT="$makeregion"
  fi
  mounted=$(lsblk | grep "$dvd" | awk '{print $7}')
  if [ -n "$mounted" ] ; then
    sudo umount "$mounted"
  fi
  growisofs -Z "/dev/${dvd}=${isoname}"
  #sudo cdrecord -v -dao speed=4 dev=/dev/$dvd "${isoname}"
}

read -r -p "Rip DVD [y/N]? " input
if [[ "$input" =~ [yY] ]] ; then ripdvd ; fi

read -r -p "Make ISO [y/N]? " input
if [[ "$input" =~ [yY] ]] ; then
  getdvdname
  if [ -d "$dvdname" ] ; then
    makeiso
  else
    echo "Bad DVD directory $dvdname"
  fi
fi

read -r -p "Burn ISO [y/N]? " input
if [[ "$input" =~ [yY] ]] ; then
  getisoname
  if [ -f "$isoname" ] ; then
    burniso
  else
    echo "Bad ISO filename $isoname"
  fi
fi
