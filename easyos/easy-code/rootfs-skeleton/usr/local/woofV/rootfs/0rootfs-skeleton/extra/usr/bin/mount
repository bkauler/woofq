#!/bin/ash
#20221027 complete rewrite.
# avoid mount & umount from util-linux.
# ref: https://bkhome.org/news/202210/problem-with-mount-utility-when-non-root.html
# 20221109 fix ntfs mounting.

[ ! $1 ] && exec busybox mount

#i realised this script has to allow reentrancy. So, all temp file now unique,
#using ${$} which is pid of script.
MYPID=${$}

. /etc/rc.d/functions4puppy4
. /etc/uimanager #has UI_DESK_MANAGER='jwm' #or rox

NTFSflg="$(echo "${*}" | grep -o 'ntfs')"

if [ "$NTFSflg" == "" ];then
 ARGS=""
 if [ $1 ];then
  while [ "$1" ]
  do
   #do not put quotes around if a single word. example is "-edit" for seamonkey,
   # the quotes stuff it up entirely...
   if [ "${1/ /}" == "${1}" ];then
    ARGS="${ARGS} ${1}"
   else
    ARGS="${ARGS} \"${1}\""
   fi
   shift
  done
 fi
 busybox mount ${ARGS}
 RETVAL=$?
else
 #screen out all the options...
 CMDPRMS="$(echo -n "$*" | tr '\t' ' ' | tr -s ' ' | tr ' ' '\n' | grep '^/' | tr '\n' ' ')"
 #kirk advised these options so Rox will not complain about file
 #permissions when copy a file to a ntfs partition...
 [ -f /tmp/ntfsmnterr${MYPID}.txt ] && rm -f /tmp/ntfsmnterr${MYPID}.txt
 ntfs-3g $CMDPRMS -o umask=0,no_def_opts,silent 2>/tmp/ntfsmnterr${MYPID}.txt #shinobar: need silent
 RETVAL=$?
 #ntfs-3g v1.2412 does not have 4,10, has 15 for dirty f.s., 14 hibernated...
 if [ $RETVAL -eq 4 -o $RETVAL -eq 10 -o $RETVAL -eq 15 -o $RETVAL -eq 14 ];then  #try to force it...
  if [ $RETVAL -eq 14 ];then
   #ntfs-3g $CMDPRMS -o umask=0,no_def_opts,remove_hiberfile 2>/tmp/ntfsmnterr${MYPID}.txt
   #RETVAL=$?
   echo > /dev/null
  else
   ntfs-3g $CMDPRMS -o force,umask=0,no_def_opts,silent 2>/tmp/ntfsmnterr${MYPID}.txt #shinobar: need silent.
   RETVAL=$?
   ERRMSG1="`cat /tmp/ntfsmnterr${MYPID}.txt`"
   echo "$ERRMSG1"
   if [ $RETVAL -eq 0 ];then
    echo "WARNING: NTFS f.s. mounted read/write but corrupted."
    [ "$(pidof X)" != "" ] && nohup xmessage -bg red -center -title "NTFS WARNING" "The ntfs-3g driver was able to mount the NTFS
partition but returned this error message:
$ERRMSG1

It is mounted read/write, but advice is only write
to it in emergency situation. Recommendation is
boot Windows and fix the filesystem first!!!" &
   fi
  fi
 fi
 #ntfs-3g plays very safe and will not mount if thinks anything
 #wrong with ntfs f.s. But, we may want to recover files from a
 #damaged windows. So, fall back to the kernel ntfs driver...
 if [ $RETVAL -ne 0 ];then
  #mount read-only...
  busybox mount -r -t ntfs $CMDPRMS
  RETVAL=$?
  ERRMSG1="$(cat /tmp/ntfsmnterr${MYPID}.txt)"
  echo "$ERRMSG1"
  if [ $RETVAL -eq 0 ];then
   echo "WARNING: NTFS f.s. mounted read-only."
   [ "$(pidof X)" != "" ] && nohup xmessage -bg red -center -title "NTFS WARNING" "The ntfs-3g driver was unable to mount the NTFS
partition and returned this error message:
$ERRMSG1

So, the inbuilt kernel NTFS driver has been used
to mount the partition read-only." &
  fi
 fi
fi

####################################################
#if there is a desktop icon, then refresh it...
if [ $RETVAL -eq 0 -a "$DISPLAY" != "" ];then
 DEVNAME="$(busybox mount | tail -n 1 | grep '^/dev/' | cut -f 1 -d ' ' | cut -f 3 -d '/')"
 if [ "$DEVNAME" != "" ];then
  DRVNAME="${DEVNAME:0:3}"
  [ "$DRVNAME" = "mmc" ] && DRVNAME="${DEVNAME%p*}" #ex: mmcblk0p1
  [ "$DRVNAME" = "nvm" ] && DRVNAME="${DEVNAME%p*}" #ex: nvme0n1p1
  xDRVNAME="$DRVNAME"
  [ -d /root/.pup_event/drive_${DEVNAME} ] && DRVNAME="$DEVNAME" #icon for each partition.
  if [ -d /root/.pup_event/drive_${DRVNAME} ];then
   case $DRVNAME in
    fd*)
     DRV_CATEGORY="floppy"
    ;;
    *)
     dnPATTERN='/dev/'"${xDRVNAME}"'|'
     DRV_CATEGORY="`probedisk | grep "$dnPATTERN" | cut -f 2 -d '|'`"
    ;;
   esac
   if [ "$UI_DESK_MANAGER" == "rox" ];then
    icon_mounted_func $DRVNAME $DRV_CATEGORY #see functions4puppy4
   else
    /usr/local/ui/jwm/generate-drives-menu #> /root/.jwmrc-drives
    jwm -reload
   fi
  fi
 fi
fi

if [ ! -h /etc/mtab ];then #make sure symlink always there.
 rm -f /etc/mtab
 ln -s /proc/mounts /etc/mtab
fi

exit $RETVAL
###end###
