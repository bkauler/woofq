#!/bin/sh

#this is a hack!
#we are using kirkstone libcap, in kirkstone-libs pet pkg...
#in woofV the pet installs last so ok. in running easyvoid, if libcap-progs is updated,
#will need this fix...
if [ ! -f /tmp/FLAGrunningwoofv ];then
 #running in easyvoid.
 if [ -f usr/lib/libcap.so.2.66 ];then
  for aF in capsh getcap getpcaps setcap
  do
   cp -a -f /mnt/.easy_ro/easy_sfs/usr/bin/${aF} usr/bin/
  done
 fi
fi
