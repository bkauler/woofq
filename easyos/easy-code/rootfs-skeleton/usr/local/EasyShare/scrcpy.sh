#!/bin/sh

sleep 2
scrcpy

#have to kill EasyShare gui if running, as button has "STOP"
pkill -f ES_MAIN_DLG
