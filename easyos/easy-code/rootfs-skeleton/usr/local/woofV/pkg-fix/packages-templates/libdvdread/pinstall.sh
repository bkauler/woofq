#!/bin/sh

LIBDVDREAD="`find usr/lib -maxdepth 1 -type f -name 'libdvdread.so.*' 2>/dev/null | head -n 1`"
if [ "$LIBDVDREAD" ];then
 BASELIBDVDREAD="`basename $LIBDVDREAD`"
 if [ ! -e usr/lib/libdvdread.so.3  ];then
  ln -s $BASELIBDVDREAD usr/lib/libdvdread.so.3
 fi
 if [ ! -e usr/lib/libdvdread.so.8  ];then
  ln -s $BASELIBDVDREAD usr/lib/libdvdread.so.8
 fi
fi
