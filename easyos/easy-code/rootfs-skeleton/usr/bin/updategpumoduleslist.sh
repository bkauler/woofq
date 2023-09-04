#!/bin/bash
#(c) Barry Kauler, Nov. 2015. License: GPL v3.
#151101 based on updatenetmoduleslist.sh

KERNVER="`uname -r`"
KERNSUBVER=`echo -n $KERNVER | cut -f 3 -d '.' | cut -f 1 -d '-'` #29
KERNMAJVER=`echo -n $KERNVER | cut -f 2 -d '.'` #6
DRIVERSDIR="/lib/modules/$KERNVER/kernel/drivers/gpu/drm"

echo "Updating /etc/gpudrmmodules..."

DEPFORMAT='new'
#[ $KERNSUBVER -lt 29 ] && [ $KERNMAJVER -eq 6 ] && DEPFORMAT='old'
if vercmp $KERNVER lt 2.6.29; then #120507
 DEPFORMAT='old'
fi
#v423 need better test, as now using busybox depmod...
[ "`grep '^/lib/modules' /lib/modules/${KERNVER}/modules.dep`" != "" ] && DEPFORMAT='old'

if [ "$DEPFORMAT" = "old" ];then
 OFFICIALLIST="`cat /lib/modules/${KERNVER}/modules.dep | grep "^/lib/modules/$KERNVER/kernel/drivers/gpu/drm/" | sed -e 's/\.gz:/:/' | cut -f 1 -d ':'`"
else
 OFFICIALLIST="`cat /lib/modules/${KERNVER}/modules.dep | grep "^kernel/drivers/gpu/drm/" | sed -e 's/\.gz:/:/' | cut -f 1 -d ':'`"
fi

#there are a few extra scattered around... needs to be manually updated...
EXTRALIST=""
RAWLIST="$OFFICIALLIST
$EXTRALIST"

#the list has to be cutdown to genuine gpu drm interfaces only...
echo -n "" > /tmp/gpudrmmodules
echo -n "" > /tmp/gpudrmfirmware-all
echo -n "" > /tmp/gpudrmfirmware-missing
echo "$RAWLIST" |
while read ONERAW
do
 [ "$ONERAW" = "" ] && continue #precaution
 ONEBASE="`basename $ONERAW .ko`"
 modprobe -vn $ONEBASE >/dev/null 2>&1
 ONEINFO="`modinfo $ONEBASE 2>/dev/null | tr '\t' ' ' | tr -s ' '`" #111027 make it quiet.
 ONETYPE="`echo "$ONEINFO" | grep '^alias:' | head -n 1 | cut -f 2 -d ' ' | cut -f 1 -d ':'`"
 ONEDESCR="`echo "$ONEINFO" | grep '^description:' | head -n 1 | cut -f 2 -d ':'`"
 case "$ONETYPE" in
  pci|pcmcia|usb|ssb|sdio)
   echo "Adding $ONEBASE"
   echo -e "$ONEBASE \"$ONETYPE: $ONEDESCR\"" >> /tmp/gpudrmmodules
  ;;
 esac
 ONEFW="$(echo "$ONEINFO" | grep '^firmware:' | cut -f 2 -d ' ')"
 if [ "$ONEFW" ];then
  echo "
MODULE: ${ONEBASE}" >> /tmp/gpudrmfirmware-all
  echo "
MODULE: ${ONEBASE}" >> /tmp/gpudrmfirmware-missing
  echo "$ONEFW" >> /tmp/gpudrmfirmware-all
  for aFW in `echo "$ONEFW" | tr '\n' ' '`
  do
   [ ! -f /lib/firmware/${aFW} ] && echo "$aFW" >> /tmp/gpudrmfirmware-missing
  done
 fi
done

cp -f /tmp/gpudrmmodules /etc/gpudrmmodules
cp -f /tmp/gpudrmfirmware-all /root/.gpudrm-firmware-all
cp -f /tmp/gpudrmfirmware-missing /root/.gpudrm-firmware-missing

###end###
