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
 for aNV in ${PKGSii1}
 do
  [ -z "$aNV" ] && continue
  grep -q -x -F -f /tmp/woofV/PKGSii2 <<<${aNV}
  if [ $? -ne 0 ];then
   grep -v -G "^${aNV}|" /root/.packages/user-installed-packages > /tmp/woofV/new-uip
   mv -f /tmp/woofV/new-uip /root/.packages/user-installed-packages
   rm -f /root/.packages/${aNV}.files
   rm -f /audit/packages/${aNV}* 2>/dev/null
   rm -f /audit/deposed/${aNV}*  2>/dev/null
  fi
 done
fi

###end###
