#!/bin/sh
#rufwoof ref: https://easyos.org/forum/showthread.php?tid=12

INPUTTEXT=`yad --text-align=center --text="gvncviewer" --entry --entry-label=IP --entry-text="192.168.1."`
gvncviewer "$INPUTTEXT"
