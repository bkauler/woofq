#!/bin/sh

#for the old so.0 libs...
LIBSPEC="$(find usr/lib -maxdepth 1 -type f -name 'libcrypto.so.0*' | head -n 1)"
if [ "$LIBSPEC" ];then
 LIBPATH="$(dirname $LIBSPEC)"
 LIBNAME="$(basename $LIBSPEC)"
 LIBLINK="$(find usr/lib -maxdepth 1 -name libcrypto.so.0)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libcrypto.so.0
 LIBLINK="$(find usr/lib -maxdepth 1 -name libcrypto.so.0.9.7)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libcrypto.so.0.9.7
 LIBLINK="$(find usr/lib -maxdepth 1 -name libcrypto.so.0.9.8)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libcrypto.so.0.9.8
fi

LIBSPEC="$(find usr/lib -maxdepth 1 -type f -name 'libssl.so.0*' | head -n 1)"
if [ "$LIBSPEC" ];then
 LIBPATH="$(dirname $LIBSPEC)"
 LIBNAME="$(basename $LIBSPEC)"
 LIBLINK="$(find usr/lib -maxdepth 1 -name libssl.so.0)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libssl.so.0
 LIBLINK="$(find usr/lib -maxdepth 1 -name libssl.so.0.9.7)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libssl.so.0.9.7
 LIBLINK="$(find usr/lib -maxdepth 1 -name libssl.so.0.9.8)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libssl.so.0.9.8
fi

#for the new so.1 libs...
LIBSPEC="$(find usr/lib -maxdepth 1 -type f -name 'libcrypto.so.1*' | head -n 1)"
if [ "$LIBSPEC" ];then
 LIBPATH="$(dirname $LIBSPEC)"
 LIBNAME="$(basename $LIBSPEC)"
 LIBLINK="$(find usr/lib -maxdepth 1 -name libcrypto.so.1)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libcrypto.so.1
 #141120 if old lib hasn't been found above, create symlinks to 1.0 lib...
 #(assuming old 0. pkg isn't installed)
 ln -s $LIBNAME ${LIBPATH}/libcrypto.so.0
 ln -s $LIBNAME ${LIBPATH}/libcrypto.so.0.9.7
 ln -s $LIBNAME ${LIBPATH}/libcrypto.so.0.9.8
 #170427 yocto pyro...
 LIBLINK="$(find usr/lib -maxdepth 1 -name libcrypto.so.1.0.0)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libcrypto.so.1.0.0
 ##190403 thud... no, using openssl10 pkg
 #LIBLINK="$(find . -name libcrypto.so.1.0.2)"
 #[ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libcrypto.so.1.0.2
fi

LIBSPEC="$(find usr/lib -maxdepth 1 -type f -name 'libssl.so.1*' | head -n 1)"
if [ "$LIBSPEC" ];then
 LIBPATH="$(dirname $LIBSPEC)"
 LIBNAME="$(basename $LIBSPEC)"
 LIBLINK="$(find usr/lib -maxdepth 1 -name libssl.so.1)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libssl.so.1
 ln -s $LIBNAME ${LIBPATH}/libssl.so.0
 ln -s $LIBNAME ${LIBPATH}/libssl.so.0.9.7
 ln -s $LIBNAME ${LIBPATH}/libssl.so.0.9.8
 #170427 yocto pyro...
 LIBLINK="$(find usr/lib -maxdepth 1 -name libssl.so.1.0.0)"
 [ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libssl.so.1.0.0
 ##190403 thud...
 #LIBLINK="$(find . -name libssl.so.1.0.2)"
 #[ ! "$LIBLINK" ] && ln -s $LIBNAME ${LIBPATH}/libssl.so.1.0.2
fi
