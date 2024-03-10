#!/bin/bash
#ref: /etc/profile.d/xbps-aliases
#20240310 uninstall fixes.

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
   # (see also /usr/local/petget/removepreview.sh)
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
      #20240310 hide home folder...
      if [ -d /home/${EXEC} ];then
       if [ -d /home/.${EXEC} ];then #precaution
        rm -rf /home/.${EXEC}
       fi
       mv -f /home/${EXEC} /home/.${EXEC}
      fi
      #20240310 remove a desktop icon if running non-root...
      grep -q "/home/${EXEC}/${EXEC}" /root/Choices/ROX-Filer/PuppyPin
      if [ $? -eq 0 ];then
       echo "<?xml version=\"1.0\"?>
<env:Envelope xmlns:env=\"http://www.w3.org/2001/12/soap-envelope\">
 <env:Body xmlns=\"http://rox.sourceforge.net/SOAP/ROX-Filer\">
  <PinboardRemove>
   <Path>/home/${EXEC}/${EXEC}</Path>
  </PinboardRemove>
 </env:Body>
</env:Envelope>" | rox -R
      fi
      #20240310 remove a desktop icon if running as root...
      grep -q "/usr/bin/${EXEC}" /root/Choices/ROX-Filer/PuppyPin
      if [ $? -eq 0 ];then
       echo "<?xml version=\"1.0\"?>
<env:Envelope xmlns:env=\"http://www.w3.org/2001/12/soap-envelope\">
 <env:Body xmlns=\"http://rox.sourceforge.net/SOAP/ROX-Filer\">
  <PinboardRemove>
   <Path>/usr/bin/${EXEC}</Path>
  </PinboardRemove>
 </env:Body>
</env:Envelope>" | rox -R
      fi
      #20240310 packages-templates may have renamed .desktop file when install...
      rm -f /usr/share/applications/${EXEC}.desktop 2>/dev/null
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
