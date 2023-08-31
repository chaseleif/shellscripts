#! /usr/bin/env bash

## This script uses ffmpeg to make a screencapture
## I have had issues with parameters/changes, and have kept configurations

#ffmpeg -f x11grab -video_size 1920x1080 -framerate 50 -i :0.0+0,0 -f alsa -ac 2 -i pulse -acodec aac -strict experimental -c:v libx264 -preset veryfast -threads 0 screen.mp4
#ffmpeg -f x11grab -video_size 1920x1080 -framerate 32 -i :0.0+0,0 -f alsa -ac 2 -i pulse -acodec aac -strict experimental -c:v libx264 -preset veryfast -threads 0 screen.mp4
#ffmpeg -f x11grab -video_size 1920x1080 -framerate 50 -i :0.0 -c:v libx264 -preset veryfast -threads 0 screen.mp4

#with sound
#ffmpeg -y -f x11grab -video_size 1920x1080 -framerate 32 -i :0.0+0,0 -f alsa -ac 2 -i hw:2 -acodec aac -strict experimental -c:v libx264 -preset veryfast -threads 4 screen.mp4

#no sound
ffmpeg -y -f x11grab -video_size 1920x1080 -framerate 32 -i :0.0+0,0 -strict experimental -c:v libx264 -preset veryfast -threads 4 screen.mp4

