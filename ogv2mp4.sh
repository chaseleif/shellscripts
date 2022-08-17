#! /usr/bin/bash

## This script takes 1 argument, an ogv file, and converts to mp4 with ffmpeg

outname=$(echo $1 | cut -f 1 -d '.')

ffmpeg -i $1 \
       -c:v libx264 -preset veryslow -crf 22 \
       -c:a libmp3lame -qscale:a 2 -ac 2 -ar 44100 \
       ${outname}.mp4
