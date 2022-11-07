#!/bin/sh
#(c) Copyright Barry Kauler, Jan 2014. bkhome.org
#Licence: GPL3 (/usr/share/doc/legal).
#When a pkg is installed by /usr/local/petget/installpkg.sh, if there is a
#post-install script, it will run this script instead of the regular 'rm'.
#installpkg.sh exports DLPKG_NAME, 1st field of pet.specs.
#140206 move *DEPOSED.sfs's into /audit/deposed. see also /usr/local/petget/installpkg.sh, removepreview.sh

#parse the commandline...
OPTIONS=''; FILEA=''; FILEB=''
for AFIELD in "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" TOOLONG
do
 [ "$AFIELD" = "" ] && break
 CHAR1="${AFIELD:0:1}"
 if [ "$CHAR1" = "-" ];then
  OPTIONS="${OPTIONS}${AFIELD} "
  continue
 fi
 if [ ! "$FILEA" ];then
  FILEA="$AFIELD"
 else
  FILEB="$AFIELD"
 fi
 [ "$AFIELD" = "TOOLONG" ] && exit 255
done

RESTOREDFLG=0
if [ -e "$FILEA" ];then
 #if the file that is about to be deleted, exists, save it in the 'DEPOSED' sfs...
 mkdir -p /audit/deposed/${DLPKG_NAME}DEPOSED #140206
 xFILEA="$(realpath "$FILEA")"
 PATHA="$(dirname "$xFILEA")"
 mkdir -p /audit/deposed/${DLPKG_NAME}DEPOSED"${PATHA}" #140206 140206
 cp -a -f --remove-destination "$xFILEA" /audit/deposed/${DLPKG_NAME}DEPOSED"${PATHA}"/ #140206
 echo -n '1' > /tmp/petget/FLAGFND #see installpkg.sh

 #need to see if the file should be restored, due to any other pkg (or the base build)
 #has installed it...
 #a service pack is an example. a base devx pet or earlier devx_service_pack may have
 #installed the file.
 if [ -f /root/.packages/user-installed-packages ];then
  mkdir -p /tmp/petget/mntpt3
  PKGNAMES="$(tac /root/.packages/user-installed-packages | cut -f 1 -d '|' | tr '\n' ' ')"
  for APKGNAME in $PKGNAMES
  do
   if [ -f /audit/deposed/${APKGNAME}DEPOSED.sfs ];then
    busybox mount -t squashfs -o loop,ro /audit/deposed/${APKGNAME}DEPOSED.sfs /tmp/petget/mntpt3
    [ $? -ne 0 ] && continue
    if [ -e /tmp/petget/mntpt3"${xFILEA}" ];then #140206
     cp -a -f --remove-destination /tmp/petget/mntpt3"${xFILEA}" "${PATHA}"/ #140206
     RESTOREDFLG=1
    fi
    busybox umount /tmp/petget/mntpt3
   fi
   [ $RESTOREDFLG -eq 1 ] && break
  done
 fi
fi

#otherwise, delete it...
[ $RESTOREDFLG -eq 0 ] && exec /bin/rm $OPTIONS "$FILEA"

###END###
