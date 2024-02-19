#!/bin/sh

#20151114
#werewolf: package 'libcdio' replaces 'cdparanoia', however executable is named differently:
[ ! -e usr/bin/cdparanoia ] && ln -s cd-paranoia usr/bin/cdparanoia


LIBCDIOEXIST="`find usr/lib -maxdepth 1 -name 'libcdio.so.*' 2>/dev/null | head -n 1`"
if [ "$LIBCDIOEXIST" ];then #140204
 BASEEXIST="`basename $LIBCDIOEXIST`"
 if [ ! -e usr/lib/libcdio.so.7 ];then
  ln -s $BASEEXIST usr/lib/libcdio.so.7
 fi
 if [ ! -e usr/lib/libcdio.so.12 ];then
  ln -s $BASEEXIST usr/lib/libcdio.so.12
 fi
 if [ ! -e usr/lib/libcdio.so.19 ];then
  ln -s $BASEEXIST usr/lib/libcdio.so.19
 fi
fi

LIB9660EXIST="`find usr/lib -maxdepth 1 -name 'libiso9660.so.*' 2>/dev/null | head -n 1`"
if [ "$LIB9660EXIST" ];then #140204
 BASEEXIST="`basename $LIB9660EXIST`"
 if [ ! -e usr/lib/libiso9660.so.7 ];then
  ln -s $BASEEXIST usr/lib/libiso9660.so.7
 fi
 if [ ! -e usr/lib/libiso9660.so.5 ];then
  ln -s $BASEEXIST usr/lib/libiso9660.so.5
 fi
 if [ ! -e usr/lib/libiso9660.so.11 ];then
  ln -s $BASEEXIST usr/lib/libiso9660.so.11
 fi
fi
