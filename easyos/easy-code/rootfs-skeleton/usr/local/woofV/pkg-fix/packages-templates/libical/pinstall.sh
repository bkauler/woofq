#!/bin/sh

LIBEXIST="`find usr/lib -maxdepth 1 -name 'libical.so.*' 2>/dev/null | head -n 1`"
if [ "$LIBEXIST" ];then
 BASEEXIST="`basename $LIBEXIST`"
 if [ ! -e usr/lib/libical.so.3 ];then
  ln -s $BASEEXIST usr/lib/libical.so.3
 fi
 if [ ! -e usr/lib/libical.so.0 ];then
  ln -s $BASEEXIST usr/lib/libical.so.0
 fi
fi

LIBEXIST="`find usr/lib -maxdepth 1 -name 'libicalss.so.*' 2>/dev/null | head -n 1`"
if [ "$LIBEXIST" ];then
 BASEEXIST="`basename $LIBEXIST`"
 if [ ! -e usr/lib/libicalss.so.3 ];then
  ln -s $BASEEXIST usr/lib/libicalss.so.3
 fi
 if [ ! -e usr/lib/libicalss.so.0 ];then
  ln -s $BASEEXIST usr/lib/libicalss.so.0
 fi
fi
