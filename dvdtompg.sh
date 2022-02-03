#! /usr/bin/bash

## This script turns a DVD folder (.vobs) into an mpg
## This uses both vobcopy and ffmpeg programs

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo "This utility will convert VOB files to mpg"
  echo "Usage: $0 <vobdir> <outdir>"
  exit 0
fi

dump=$1
output=$2
if [ -z "$dump" ] ; then
  read -p 'vob directory: ' dump
fi
if [ -z "$output" ] ; then
  read -p 'out directory: ' output
fi

vobargs="-l -x -o"
ffmpegargs="-target pal-svcd"
format=".mpg"
REQUIREMENTS=${REQUIREMENTS:-"vobcopy ffmpeg"}

type -P $REQUIREMENTS &>/dev/null ||
{
  echo "Missing requirements" >&2
  exit 1
}

shopt -s nocaseglob

set -e

if [ ! -d "${dump}" ] ; then
  echo "vob directory not found"
  exit 1
fi
if [ ! -d "${output}" ] ; then
  echo "creating directory ${output}"
  mkdir -p ${output}
fi

vobcopy $vobargs "$dump"

for vobinput in "$dump"/*.vob; do
  dvdname=${vobinput%%/VIDEO_TS/*}
  dvdname=${dvdname##*/}
  ffmpeg -i "$vobinput" $ffmpegargs "$output/${dvdname%.*}$format"
done
