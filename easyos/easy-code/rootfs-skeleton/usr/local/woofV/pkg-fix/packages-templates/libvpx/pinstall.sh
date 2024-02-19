#!/bin/sh
#150808 180513 190728

REALLIB="`find usr/lib -maxdepth 1 -type f -name 'libvpx.so.*' | tail -n 1`"
if [ "$REALLIB" ];then
 BASELIB="$(basename $REALLIB)"
 PATHLIB="$(dirname $REALLIB)"
 [ ! -e ${PATHLIB}/libvpx.so.1 ] && ln -s ${BASELIB} ${PATHLIB}/libvpx.so.1
 [ ! -e ${PATHLIB}/libvpx.so.2 ] && ln -s ${BASELIB} ${PATHLIB}/libvpx.so.2
 [ ! -e ${PATHLIB}/libvpx.so.3 ] && ln -s ${BASELIB} ${PATHLIB}/libvpx.so.3
 [ ! -e ${PATHLIB}/libvpx.so.4 ] && ln -s ${BASELIB} ${PATHLIB}/libvpx.so.4
 [ ! -e ${PATHLIB}/libvpx.so.7 ] && ln -s ${BASELIB} ${PATHLIB}/libvpx.so.7
fi
