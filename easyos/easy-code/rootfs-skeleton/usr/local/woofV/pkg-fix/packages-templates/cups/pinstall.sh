#!/bin/sh

#20201001 oe dunfell
#path is usr/libexec/cups, debian etc it is usr/lib/cups
if [ -d usr/libexec/cups/cgi-bin ];then
 if [ ! -h usr/libexec/cups ];then
  if [ -d usr/lib/cups ];then
   if [ ! -h usr/lib/cups ];then
    cp -a -f --remove-destination usr/lib/cups/* usr/libexec/cups/
    rm -rf usr/lib/cups
    ln -s ../libexec/cups usr/lib/cups
   fi
  fi
 fi
fi
