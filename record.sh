#! /usr/bin/bash

## This script uses recordmydesktop to make a screen capture

recordmydesktop --device plughw:2,0 --quick-subsampling --v_quality 32 --no-wm-check --freq 16000 --fps 8 --compress-cache --on-the-fly-encoding --stop-shortcut Control+Scroll_Lock --pause-shortcut Control+Pause
#recordmydesktop --device hw:webcam --quick-subsampling --v_quality 32 --no-wm-check --freq 16000 --fps 8 --compress-cache --on-the-fly-encoding --stop-shortcut Control+Scroll_Lock --pause-shortcut Control+Pause

#Control+Mod1+q --pause-shortcut Control+Mod1+p
