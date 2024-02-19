#!/bin/sh

LIBCAPFND="$(find usr/lib -maxdepth 1 -type f -name 'libcap.so.*' 2>/dev/null | head -n 1)"
if [ "$LIBCAPFND" ];then
 LIBCAPDIR="$(dirname $LIBCAPFND)"
 LIBCAPNAME="$(basename $LIBCAPFND)"
 [ ! -e ${LIBCAPDIR}/libcap.so.1 ] && ln -s ${LIBCAPNAME} ${LIBCAPDIR}/libcap.so.1
fi

