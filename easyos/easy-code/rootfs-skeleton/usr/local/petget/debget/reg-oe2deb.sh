#!/bin/ash
#pass in name and version of a oe pkg.
#if nothing passed in, do them all in oe-deb-names
#dummy deb will be created and installed.
#requires 'dpkg' to be installed.

cd /usr/local/petget/debget #where this script and oe-deb-names is.
#sanity check...
if [ ! -f /root/.packages/Packages-oe-scarthgap-official ];then exit 1; fi
if [ ! -f /root/.packages/Packages-devuan-daedalus-main ];then exit 1; fi
if [ ! -f /root/.packages/Packages-devuan-daedalus-nonfree ];then exit 1; fi

mkdir -p /tmp/reg-oe2deb
echo -n '' > /tmp/reg-oe2deb/Pnv

if [ -n "$1" ];then
 echo "${1}|${2}" > /tmp/reg-oe2deb/Pnv
else
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
  aPnv="$(echo -n "${Pfnd}" | tr ',' '\n' | sed -e '/^$/d' | sed -e "s%$%|${aV}%" | tr '\n' ' ')"
  echo "${aPnv}" >> /tmp/reg-oe2deb/Pnv
 done
fi
#exit #TEST

Pnv="$(cat /tmp/reg-oe2deb/Pnv | tr '\n' ' ' | tr -s ' ' | tr ' ' '\n' | sort -u | tr '\n' ' ')"

for aNV in ${Pnv}
do
 Pn="${aNV/|*/}"
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
 dpkg -i ${Pn}_${Pv}_${Pa}.deb
 
 #delete deb pkg
 rm -f ${Pn}_${Pv}_${Pa}.deb
 rm -rf ${Pn}_${Pv}_${Pa}
 
 #echo -n "CONTINUE: "
 #read goone
 sync
done

###end###
