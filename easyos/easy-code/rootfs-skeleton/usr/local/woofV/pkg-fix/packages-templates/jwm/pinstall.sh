#!/bin/sh
#post-install script.
#Woof: current directory is rootfs
#180706 do not test for other tray apps.

if [ "`pwd`" != "/" ];then

 #if [ ! -f ./usr/bin/fvwm95 ];then #150928
 # if [ ! -f ./usr/bin/fbpanel ];then
 #  if [ ! -f ./usr/bin/lxpanel ];then
    echo -n "jwm" > ./etc/windowmanager
 #  fi
 # fi
 #fi

fi

#end#
