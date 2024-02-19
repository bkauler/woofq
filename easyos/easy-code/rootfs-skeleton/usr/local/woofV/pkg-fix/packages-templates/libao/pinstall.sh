#!/bin/sh

if [ ! -e usr/lib/libao.so.2 ];then
 LIBAOEXIST="`find usr/lib -maxdepth 1 -name 'libao.so.*' | head -n 1`"
 if [ "$LIBAOEXIST" != "" ];then
  LIBAOBASE="`basename $LIBAOEXIST`"
  ln -s $LIBAOBASE usr/lib/libao.so.2
 fi
fi
