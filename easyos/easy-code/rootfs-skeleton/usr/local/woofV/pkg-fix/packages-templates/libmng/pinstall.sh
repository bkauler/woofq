#!/bin/sh

#170427 yocto pyro
 FNDMNG2="$(find usr/lib -maxdepth 1 -type f -name 'libmng.so.*')"
 if [ "$FNDMNG2" ];then
  DIRMNG="$(dirname $FNDMNG2)"
  BASEMNG="$(basename $FNDMNG2)"
  ln -s $BASEMNG ${DIRMNG}/libmng.so.1 2>/dev/null
  ln -s $BASEMNG ${DIRMNG}/libmng.so.2 2>/dev/null
 fi


