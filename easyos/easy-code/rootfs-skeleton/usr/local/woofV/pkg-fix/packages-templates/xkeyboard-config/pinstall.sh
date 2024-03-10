#!/bin/sh

echo "moving /usr/share/X11/xkb to /etc/X11/xkb"
cp -a -f --remove-destination usr/share/X11/xkb etc/X11/
rm -rf usr/share/X11/xkb
ln -s ../../../etc/X11/xkb usr/share/X11/xkb

