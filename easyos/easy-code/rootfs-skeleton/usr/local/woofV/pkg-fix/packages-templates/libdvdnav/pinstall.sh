#!/bin/sh

LIBDVDNAV="`find usr/lib -maxdepth 1 -type f -name 'libdvdnav.so.*' | head -n 1`"
if [ "$LIBDVDNAV" ];then
 BASELIBDVDNAV="`basename $LIBDVDNAV`"
 if [ ! -e usr/lib/libdvdnav.so.3  ];then
  ln -s $BASELIBDVDNAV usr/lib/libdvdnav.so.3
 fi
 if [ ! -e usr/lib/libdvdnav.so.4  ];then
  ln -s $BASELIBDVDNAV usr/lib/libdvdnav.so.4
 fi
fi
