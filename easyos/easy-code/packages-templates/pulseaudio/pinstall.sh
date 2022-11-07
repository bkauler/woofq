#!/bin/sh

echo 'pulseaudio template'

#20201020
#/etc/init.d/bluealsa is in woofq/rootfs-skeleton
#make sure it is not executable... well, why not remove it...
if [ -e etc/init.d/bluealsa ];then
 rm -f etc/init.d/bluealsa
fi
