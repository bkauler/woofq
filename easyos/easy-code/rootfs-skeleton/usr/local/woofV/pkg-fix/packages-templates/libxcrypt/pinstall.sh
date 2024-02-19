#!/bin/sh

#20210612 oe dunfell
# ref: https://forum.puppylinux.com/viewtopic.php?p=27791#p27791
LIBSO2="$(find usr/lib -maxdepth 1 -type l -name 'libcrypt.so.2' | head -n 1)"
if [ "$LIBSO2" ];then
 DIRSO="$(dirname ${LIBSO2})"
 if [ ! -e ${DIRSO}/libcrypt.so.1 ];then
  ln -s libcrypt.so.2 ${DIRSO}/libcrypt.so.1
 fi
fi
