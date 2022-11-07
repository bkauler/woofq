#!/bin/sh

if [ "$xARCHDIR" ];then
 if [ -f usr/lib/installwatch.so ];then
  mv -f usr/lib/installwatch.so usr/lib${xARCHDIR}/
 fi
fi
