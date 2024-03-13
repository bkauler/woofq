#!/bin/sh

#this is a hack!
#we are using kirkstone libcap-ng, in kirkstone-libs pet pkg...
#in woofV the pet installs last so ok. in running easyvoid, if libcap-ng is updated,
#will need this fix...
if [ ! -f /tmp/FLAGrunningwoofv ];then
 #running in easyvoid.
 cp -a -f /mnt/.easy_ro/easy_sfs/usr/lib/libcap-ng.so.0.0.0 usr/lib/
 cp -a -f /mnt/.easy_ro/easy_sfs/usr/lib/libdrop_ambient.so.0.0.0 usr/lib/
fi
