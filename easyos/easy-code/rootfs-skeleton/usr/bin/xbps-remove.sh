#!/bin/bash
#ref: /etc/profile.d/xbps-aliases

mkdir -p /tmp/woofV
. /etc/DISTRO_SPECS
case "$DISTRO_TARGETARCH" in
 amd64) xARCH='x86_64' ;;
 *)     xARCH="$DISTRO_TARGETARCH" ;;
esac
export XBPS_ARCH="$xARCH"

PKGSii1="$(xbps-query --list-pkgs | grep '^ii ' | cut -f 2 -d ' ')"
SUMii1="$(md5sum - <<<"${PKGSii1}")"

/usr/bin/xbps-remove $@

PKGSii2="$(xbps-query --list-pkgs | grep '^ii ' | cut -f 2 -d ' ')"
SUMii2="$(md5sum - <<<"${PKGSii2}")"

#if any pkgs installed, update user-installed-packages...
if [ "$SUMii1" != "$SUMii2" ];then
 echo "Updating /root/.packages/user-installed-packages"
 cat - <<<${PKGSii2} >/tmp/woofV/PKGSii2
 for aNVR in ${PKGSii1}
 do
  [ -z "$aNVR" ] && continue
  grep -q -x -F -f /tmp/woofV/PKGSii2 <<<${aNVR}
  if [ $? -ne 0 ];then
   grep -v -G "^${aNVR}|" /root/.packages/user-installed-packages > /tmp/woofV/new-uip
   mv -f /tmp/woofV/new-uip /root/.packages/user-installed-packages
   
   #if an app has been installed to run non-root, delete the .bin and .bin0...
   grep -q 'usr/share/applications' /root/.packages/${aNVR}.files
   if [ $? -eq 0 ];then
    for aDT in $(grep '/usr/share/applications/' /root/.packages/${aNVR}.files)
    do
     [ -z "$aDT" ] && continue
     EXEC="$(grep '^Exec=' ${aDT} | cut -f 2 -d '=' | cut -f 1 -d ' ')"
     if [ "$EXEC" ];then
      [ -f /usr/bin/${EXEC} ] && rm -f /usr/bin/${EXEC}
      [ -f /usr/bin/${EXEC}.bin ] && rm -f /usr/bin/${EXEC}.bin
      [ -f /usr/bin/${EXEC}.bin0 ] && rm -f /usr/bin/${EXEC}.bin0
      sed -i "/^${EXEC}=/d" /root/.clients-status
     fi
     build-rox-sendto "-${aDT}"
    done
   fi
   
   rm -f /root/.packages/${aNVR}.files
   rm -f /audit/packages/${aNVR}* 2>/dev/null
   rm -f /audit/deposed/${aNVR}*  2>/dev/null
  fi
 done
fi

###end###
