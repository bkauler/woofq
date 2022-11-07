#!/bin/sh
#post-install script.
#Woof: current directory is sandbox3/rootfs-complete.

if [ "`pwd`" != "/" ];then

 if [ ! -f ./usr/bin/fvwm95 ];then #150928
  if [ ! -f ./usr/bin/fbpanel ];then
   if [ ! -f ./usr/bin/lxpanel ];then
    echo -n "jwm" > ./etc/windowmanager
   fi
  fi
 fi

fi

#end#
