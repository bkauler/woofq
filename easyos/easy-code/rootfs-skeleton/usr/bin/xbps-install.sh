#!/bin/bash
#ref: /etc/profile.d/xbps-aliases

mkdir -p /tmp/woofV
. /etc/DISTRO_SPECS
case "$DISTRO_TARGETARCH" in
 amd64) xARCH='x86_64' ;;
 *)     xARCH="$DISTRO_TARGETARCH" ;;
esac
export XBPS_ARCH="$xARCH"

SUMrepos1="$(find /var/db/xbps -mindepth 2 -maxdepth 2 -type f -name '*-repodata' -exec sha256sum {}  \; | cut -f 1 -d ' ' | sort | tr -d '\n' | md5sum - | cut -f 1 -d ' ')"

##um, only likely to be one of these...
#SUMpkgdb1="$(find /var/db/xbps -mindepth 1 -maxdepth 1 -type f -name 'pkgdb-0*.plist' -exec md5sum {} \; | cut -f 1 -d ' ' | head -n 1)"
PKGSii1="$(xbps-query --list-pkgs | grep '^ii ' | cut -f 2 -d ' ')"
SUMii1="$(md5sum - <<<"${PKGSii1}")"

/usr/bin/xbps-install $@

SUMrepos2="$(find /var/db/xbps -mindepth 2 -maxdepth 2 -type f -name '*-repodata' -exec sha256sum {}  \; | cut -f 1 -d ' ' | sort | tr -d '\n' | md5sum - | cut -f 1 -d ' ')"

#SUMpkgdb2="$(find /var/db/xbps -mindepth 1 -maxdepth 1 -type f -name 'pkgdb-0*.plist' -exec md5sum {} \; | cut -f 1 -d ' ' | head -n 1)"
PKGSii2="$(xbps-query --list-pkgs | grep '^ii ' | cut -f 2 -d ' ')"
SUMii2="$(md5sum - <<<"${PKGSii2}")"

#if any repodata files have changed, then update the pupdbs...
if [ "$SUMrepos1" != "$SUMrepos2" ];then
 echo "Updating /root/.packages/Packages-void-current* pupdbs"
 /usr/local/petget/xbps-to-pupdb
fi

#if any pkgs installed, update user-installed-packages...
if [ "$SUMii1" != "$SUMii2" ];then
 echo "Updating /root/.packages/user-installed-packages"
 echo "If .desktop file, fixes it and sets app to run non-root"
 cat - <<<${PKGSii1} >/tmp/woofV/PKGSii1
 for aNV in ${PKGSii2}
 do
  [ -z "$aNV" ] && continue
  grep -q -x -F -f /tmp/woofV/PKGSii1 <<<${aNV}
  if [ $? -ne 0 ];then
   aN="$(xbps-query --show ${aNV} --property pkgname)"
   if [ ! -z "$aN" ];then
    #also does more things: fixes .desktop, creates /root/.packages/*.files, run non-root
    /usr/local/petget/xbps-user-postupdate ${aN} ${aNV}
   fi
  fi
 done
fi

###end###
