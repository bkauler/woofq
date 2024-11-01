#!/bin/bash
#pass in name and version of a oe pkg.
#if nothing passed in, do them all in oe-deb-names
#dummy deb will be created and installed.
#requires 'dpkg' to be installed.
#20241025 dummy debs must have oe version. 20241026 revert.

cd /usr/local/petget/debget #where this script and oe-deb-names is.
#sanity check...
if [ ! -f /root/.packages/Packages-oe-scarthgap-official ];then exit 1; fi
if [ ! -f /root/.packages/Packages-devuan-daedalus-main ];then exit 1; fi
if [ ! -f /root/.packages/Packages-devuan-daedalus-nonfree ];then exit 1; fi

mkdir -p /tmp/reg-oe2deb
echo -n '' > /tmp/reg-oe2deb/Pnv

if [ -n "$1" ];then
 echo "${1}|${2}" > /tmp/reg-oe2deb/Pnv
 Nflg=0
else
 Nflg=1
 for aOE in $(cut -f 2,3 -d '|' /root/.packages/woof-installed-packages)
 do
  if [ -z "${aOE}" ];then continue; fi
  Poen="${aOE/|*/}"
  Poev="${aOE/*|/}"
  xPoen="$(echo -n "${Poen}" | sed -e 's%\.%\\.%g')"
  Pfnd="$(grep "^${xPoen}|" oe-deb-names | cut -f 3 -d '|' | tr -s ',')"
  if [ -z "${Pfnd}" ];then continue; fi
  Cnt=$(echo "$Pfnd" | wc -l)
  #if [ $Cnt -ne 1 ];then continue; fi #avoid ambiguity.
  if [ $Cnt -ne 1 ];then
   #see if can eliminate the ambiguity. ex lines in oe-deb-names:
   #acl|acl2|,acl2,acl2-books,acl2-books-certs,acl2-books-source,acl2-doc,acl2-infix,acl2-infix-source,acl2-source,elpa-acl2,
   #acl|acl|,acl,libacl1,libacl1-dev,
   #format: oe-name|deb-generic-name|,deb-pkg-name,...
   Gfnd="$(grep "^${xPoen}|" oe-deb-names | cut -f 2 -d '|' | tr '\n' ' ')"
   Vacc=''; aV=${Poev}
   for aG in ${Gfnd}
   do
    Vacc='' #accumulate matches.
    aV="$(grep -h -F "/${aG}|" /root/.packages/Packages-devuan-daedalus-* | head -n 1 | cut -f 3 -d '|')" #deb version
    [ -z "$aV" ] && continue
    Cnta=1
    for OEv in $(echo -n "${Poev}" | tr '.' ' ' | cut -f 1,2 -d ' ')
    do
     DEBv=$(echo -n "${aV}" | cut -f ${Cnta} -d '.')
     DEBv="${DEBv/[a-z]*/}"
     DEBv="${DEBv/-*/}"
     if [ "${DEBv/-*/}" == "${OEv/-*/}" ];then
      Vacc="${Vacc}${DEBv}."
      [ $Cnta -gt 1 ] && break 2
     fi
     Cnta=$((${Cnta}+1))
    done
   done
   if [ -z "${Vacc}" ];then continue; fi
   Vacc="${Vacc%.}" #remove trailing dot.
   Pdebn="${aG}"
   xPdebn="$(echo -n "$Pdebn" | sed -e 's%\.%\\.%')"
   Pfnd="$(grep "|${xPdebn}|" oe-deb-names | cut -f 3 -d '|' | tr -s ',')"
   Cnt=$(echo "$Pfnd" | wc -l)
   if [ $Cnt -ne 1 ];then continue; fi #avoid ambiguity.
  else
   aG="$(grep "^${xPoen}|" oe-deb-names | cut -f 2 -d '|')"
   aV="$(grep -h -F "/${aG}|" /root/.packages/Packages-devuan-daedalus-* | head -n 1 | cut -f 3 -d '|')" #deb version
  fi
  if [ -z "${Pfnd}" ];then continue; fi
  if [ -z "${aV}" ];then continue; fi
  #20241025 $aV is the debian version, but want oe version $Poev... 20241026 revert...
  aPnv="$(echo -n "${Pfnd}" | tr ',' '\n' | sed -e '/^$/d' | sed -e "s%$%|${aV}%" | tr '\n' ' ')"
  echo "${aPnv}" >> /tmp/reg-oe2deb/Pnv
 done
fi
#exit #TEST

Pnv="$(cat /tmp/reg-oe2deb/Pnv | tr '\n' ' ' | tr -s ' ' | tr ' ' '\n' | sort -u | tr '\n' ' ')"

######################
#20241025
DISTRO_BINARY_COMPAT=devuan
DISTRO_COMPAT_VERSION=daedalus
. /root/.packages/PKGS_MANAGEMENT #has PKG_NAME_IGNORE
PKG_NAME_IGNORE=" ${PKG_NAME_IGNORE} "

for aNV in ${Pnv}
do
 Pn="${aNV/|*/}"
 #20241025 these ones installed further down...
 grep -q -F -i " ${Pn} " <<<"${PKG_NAME_IGNORE}"
 if [ $? -eq 0 ];then continue; fi
 echo "${Pn}"
 Pv="${aNV/*|/}"
 #get architecture...
 Pa="$(grep -h -F "|${Pn}|${Pv}|" /root/.packages/Packages-devuan-daedalus-* | head -n 1 | cut -f 8 -d '|' | rev | cut -f 1 -d '_' | cut -f 2- -d '.' | rev)"
 if [ -z "$Pa" ];then Pa=amd64; fi
 #create folder with control file...
 mkdir -p ${Pn}_${Pv}_${Pa}/DEBIAN
 echo "Package: ${Pn}
Version: ${Pv}
Architecture: ${Pa}
Maintainer: BK
Installed-Size: 5
Depends: 
Section: 
Priority: optional
Description: Dummy deb pkg" > ${Pn}_${Pv}_${Pa}/DEBIAN/control
 
 #build deb pkg
 dpkg-deb --build ${Pn}_${Pv}_${Pa}
 
 #install deb
 if [ $Nflg -eq 0 ];then
  #dpkg is a wrapper script and will record installed pkg to user-installed-packages
  dpkg -i ${Pn}_${Pv}_${Pa}.deb
 else
  #dpkg.bin is the actual binary
  dpkg.bin -i ${Pn}_${Pv}_${Pa}.deb
 fi
 
 #delete deb pkg
 rm -f ${Pn}_${Pv}_${Pa}.deb
 rm -rf ${Pn}_${Pv}_${Pa}
 
 #echo -n "CONTINUE: "
 #read goone
 sync
done

#20241025
#prevent apt from installing some pkgs...
for Pn in ${PKG_NAME_IGNORE}
do
 [ -z "${Pn}" ] && continue
 #get architecture...
 Pa="$(grep -h -F "|${Pn}|" /root/.packages/Packages-devuan-daedalus-* | head -n 1 | cut -f 8 -d '|' | rev | cut -f 1 -d '_' | cut -f 2- -d '.' | rev)"
 if [ -z "$Pa" ];then continue; fi
 Pv='999.999' #set very high version
 #create folder with control file...
 mkdir -p ${Pn}_${Pv}_${Pa}/DEBIAN
 echo "Package: ${Pn}
Version: ${Pv}
Architecture: ${Pa}
Maintainer: BK
Installed-Size: 5
Depends: 
Section: 
Priority: optional
Description: Dummy deb pkg" > ${Pn}_${Pv}_${Pa}/DEBIAN/control
 #build deb pkg
 dpkg-deb --build ${Pn}_${Pv}_${Pa}
 #install deb
 if [ $Nflg -eq 0 ];then
  #dpkg is a wrapper script and will record installed pkg to user-installed-packages
  dpkg -i ${Pn}_${Pv}_${Pa}.deb
 else
  #dpkg.bin is the actual binary
  dpkg.bin -i ${Pn}_${Pv}_${Pa}.deb
 fi
 #delete deb pkg
 rm -f ${Pn}_${Pv}_${Pa}.deb
 rm -rf ${Pn}_${Pv}_${Pa}
done

###end###
