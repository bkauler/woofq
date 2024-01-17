#!/bin/sh
#the hardlinks may have gone, recreate them. ref:
# https://bkhome.org/news/202111/mesa-package-much-bigger-than-it-needs-to-be.html
#in easyos reduces /usr/libdri from 139MB to 26MB.

if [ -d usr/lib/dri ];then
 PREFIX="usr/lib/"
else
 if [ -d usr/lib64/dri ];then
  PREFIX="usr/lib64/"
 else
  PREFIX="$(find usr/lib -mindepth 2 -maxdepth 2 -type d -name dri | cut -f 1-3 -d '/' | head -n 1)/"
 fi
fi

#20240114 this code messes up easyvoid; test hyperlink crocus_dri.so exists...
if [ -d ${PREFIX}dri -a ! -h usr/lib/dri/crocus_dri.so ];then
 DRVS0="$(ls -1 ${PREFIX}dri)"
 
 while [ "$DRVS0" ];do
  DRVS1=''
  aDRV="$(echo "$DRVS0" | head -n 1)"
  for aaDRV in ${DRVS0}
  do
   [ "$aaDRV" == "" ] && continue
   [ "$aaDRV" == "$aDRV" ] && continue
   cmp -s ${PREFIX}dri/${aDRV} ${PREFIX}dri/${aaDRV}
   if [ $? -eq 0 ];then
    #hardlink...
    ln -f ${PREFIX}dri/${aDRV} ${PREFIX}dri/${aaDRV}
   else
    if [ ! "$DRVS1" ];then
     DRVS1="${aaDRV}"
    else
     DRVS1="${DRVS1}
${aaDRV}"
    fi
   fi
  done
  DRVS0="$DRVS1"
 done
 sync
fi

#20220911 bookworm; mesa-loader error in /tmp/xerrs.log looks in /usr/lib/dri
if [ "${PREFIX}dri" != "usr/lib/dri" ];then
 if [ ! -d usr/lib/dri ];then
  ln -s --relative ${PREFIX}dri usr/lib/dri
 fi
fi
