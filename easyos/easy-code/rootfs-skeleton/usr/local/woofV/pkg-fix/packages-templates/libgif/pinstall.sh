#!/bin/sh
#150726

FNDGIF="$(find usr/lib -maxdepth 1 -type f -name 'libgif.so.*' | head -n 1)"
if [ "$FNDGIF" ];then
 BASEGIF="$(basename "$FNDGIF")"
 DIRGIF="$(dirname "$FNDGIF")"
 ln -s $BASEGIF ${DIRGIF}/libgif.so.0 2>/dev/null
 ln -s $BASEGIF ${DIRGIF}/libgif.so.3 2>/dev/null
 ln -s $BASEGIF ${DIRGIF}/libgif.so.7 2>/dev/null
 ln -s $BASEGIF ${DIRGIF}/libungif.so 2>/dev/null
 ln -s $BASEGIF ${DIRGIF}/libungif.so.0 2>/dev/null
 ln -s $BASEGIF ${DIRGIF}/libungif.so.3 2>/dev/null
 ln -s $BASEGIF ${DIRGIF}/libungif.so.7 2>/dev/null
fi
