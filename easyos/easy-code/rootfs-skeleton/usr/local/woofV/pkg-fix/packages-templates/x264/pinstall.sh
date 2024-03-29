#!/bin/sh

#to support apps compiled for older x264...
FNDLIB="`find usr/lib -maxdepth 1 -type f -name 'libx264.so.*' | tail -n 1`"
if [ "$FNDLIB" ];then
 BASELIB="`basename $FNDLIB`"
 BASENUM="`echo -n "$BASELIB" | rev | cut -f 1 -d '.' | rev`" #ex: libx264.so.115 becomes 115
 if vercmp ${BASENUM} gt 116;then
  ln -s $BASELIB usr/lib/libx264.so.116
 fi
 if vercmp ${BASENUM} gt 105;then
  ln -s $BASELIB usr/lib/libx264.so.105
 fi
 if vercmp ${BASENUM} gt 94;then
  ln -s $BASELIB usr/lib/libx264.so.94
 fi
 if vercmp ${BASENUM} gt 98;then
  ln -s $BASELIB usr/lib/libx264.so.98
 fi
 if vercmp ${BASENUM} gt 163;then
  ln -s $BASELIB usr/lib/libx264.so.163
 fi
fi
