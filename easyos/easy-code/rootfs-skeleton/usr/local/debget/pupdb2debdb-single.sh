#!/bin/bash
#called from sync-woof2dpkg and sync-new2dpkg
#read a pup db entry from file /tmp/debget/pup-db-single
#find matching deb pkg db.

export LANG=C

APTflg=0
if [ ! -f /var/local/pkgget/deb_compat_specs ];then
 #need to run 'apt-setup' first
 APTflg=1
fi
if [ ! -d /var/lib/apt/lists ];then
 #need to run 'apt-setup' first
 APTflg=1
fi
Pfnd="$(find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -type f -name '*_Packages')"
if [ "$Pfnd" == "" ];then
 #need to run 'apt-setup' first
 APTflg=1
fi
if [ $APTflg -eq 1 ];then
 /usr/local/debget/apt-setup
fi

#DEBDISTRO and DEBVERSION...
. /var/local/pkgget/deb_compat_specs

mkdir -p /tmp/debget/working
rm -f /tmp/debget/working/* 2>/dev/null
CWD="$(pwd)"

. /etc/DISTRO_SPECS

#here are typical puppy-db entries:
#from Packages-oe-dunfell-official:
#alsa-lib-1.2.1.2-r9|alsa-lib|1.2.1.2-r9||BuildingBlock|2012K|dunfell|alsa-lib-1.2.1.2-r9-nocona-64.tar.xz|+gcc-runtime,+glibc|ALSA sound library|oe|dunfell||
#audacious-3.10.1-r9|audacious|3.10.1-r9||Multimedia;mediaplayer|2496K|dunfell|audacious-3.10.1-r9-nocona-64.tar.xz|+alsa-lib,+alsa-plugins,+dbus,+dbus-glib,+gcc-runtime,+glib-2,+glibc,+gtk+,+jack,+pulseaudio|audio player|oe|dunfell||
#from Packages-debian-bookworm-main:
#abe_1.1+dfsg-4|abe|1.1+dfsg-4||Fun;adventure|105K|pool/main/a/abe|abe_1.1+dfsg-4_amd64.deb|+abe-data&eq1.1+dfsg-4,+libc6&ge2.14,+libsdl-mixer1.2,+libsdl1.2debian&ge1.2.11|side-scrolling game named Abes Amazing Adventure|debian|bookworm|
#abiword_3.0.5|abiword|3.0.5||Document;layout|5133K|pool/main/a/abiword|abiword_3.0.5~dfsg-1_amd64.deb|+abiword-common&ge3.0.5,+gsfonts,+libabiword-3.0&ge3.0.5,+libc6&ge2.14,+libdbus-1-3&ge1.9.14,+libdbus-glib-1-2&ge0.78,+libgcc-s1&ge3.0,+libgcrypt20&ge1.8.0,+libglib2.0-0&ge2.16.0,+libgnutls30&ge3.7.0,+libgoffice-0.10-10&ge0.10.2,+libgsf-1-114&ge1.14.9,+libgtk-3-0&ge3.0.0,+libjpeg62-turbo&ge1.3.1,+libloudmouth1-0&ge1.3.3,+libots0&ge0.5.0,+libpng16-16&ge1.6.2-1,+librdf0&ge1.0.17,+libreadline8&ge6.0,+librevenge-0.0-0,+libsoup2.4-1&ge2.4.0,+libstdc++6&ge7,+libtelepathy-glib0&ge0.13.0,+libtidy5deb1&ge5.2.0,+libwmf0.2-7&ge0.2.8.4,+libwpd-0.10-10,+libwpg-0.3-3,+libxml2&ge2.7.4,+zlib1g&ge1.1.4|efficient featureful word processor with collaboration|debian|bookworm|

#here is a typical debian-db entry:
#Package: abiword
#Version: 3.0.5~dfsg-1
#Installed-Size: 5133
#Maintainer: Jonas Smedegaard <dr@jones.dk>
#Architecture: amd64
#Depends: abiword-common (>= 3.0.5~dfsg-1), gsfonts, libabiword-3.0 (>= 3.0.5~dfsg), libc6 (>= 2.14), libdbus-1-3 (>= 1.9.14), libdbus-glib-1-2 (>= 0.78), libgcc-s1 (>= 3.0), libgcrypt20 (>= 1.8.0), libglib2.0-0 (>= 2.16.0), libgnutls30 (>= 3.7.0), libgoffice-0.10-10 (>= 0.10.2), libgsf-1-114 (>= 1.14.9), libgtk-3-0 (>= 3.0.0), libjpeg62-turbo (>= 1.3.1), libloudmouth1-0 (>= 1.3.3), libots0 (>= 0.5.0), libpng16-16 (>= 1.6.2-1), librdf0 (>= 1.0.17), libreadline8 (>= 6.0), librevenge-0.0-0, libsoup2.4-1 (>= 2.4.0), libstdc++6 (>= 7), libtelepathy-glib0 (>= 0.13.0), libtidy5deb1 (>= 1:5.2.0), libwmf0.2-7 (>= 0.2.8.4), libwpd-0.10-10, libwpg-0.3-3, libxml2 (>= 2.7.4), zlib1g (>= 1:1.1.4)
#Recommends: abiword-plugin-grammar, aspell-en | aspell-dictionary, fonts-liberation, poppler-utils
#Description: efficient, featureful word processor with collaboration
#Homepage: http://www.abisource.com/
#Description-md5: 30063e6f0ad54b0bc4811f0becf40355
#Tag: implemented-in::c++, interface::graphical, interface::x11,
# role::program, scope::application, uitoolkit::gtk, use::editing,
# use::text-formatting, works-with-format::html, works-with-format::tex,
# works-with::text, x11::application
#Section: editors
#Priority: optional
#Filename: pool/main/a/abiword/abiword_3.0.5~dfsg-1_amd64.deb
#Size: 1334712
#MD5sum: 918644c61e57f56a99dfe1fbd9cefc5d
#SHA256: 5cad479d7a59c611a64204bbfef736daafcd5ebd9bc0e5713b48c340c945519f

#what pup are we running? is it built with $DEBDISTRO and $DEBVERSION?
SAMEflg=0
#if so that will be the easiest situation...
PUPcompatdistro="$(cut -f 11 -d '|' /tmp/debget/pup-db-single)"
PUPcompatversion="$(cut -f 12 -d '|' /tmp/debget/pup-db-single)"
if [ "$DEBDISTRO" == "$PUPcompatdistro" ];then
 SAMEflg=1
fi

#simplest case, a pup-db entry previously created by 'debdb2pupdb'...
PUPnameonly="$(cut -f 2 -d '|' /tmp/debget/pup-db-single)" #ex: abiword
PUPpath="$(cut -f 7 -d '|' /tmp/debget/pup-db-single)" #ex: pool/main/a/abiword

#a bit concerned about order of searching deb pkgs dbs, want -updates_ first...
PKGSa="$(find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -type f -name '*_'"${DEBVERSION}"'-updates_*_Packages' | tr '\n' ' ')"
PKGSb="$(find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -type f -name '*_'"${DEBVERSION}"'_*_Packages' | tr '\n' ' ')"
#...ex: /var/lib/apt/lists/deb.debian.org_debian_dists_bullseye_main_binary-amd64_Packages
#echo "PKGSa='${PKGSa}'
#PKGSb='${PKGSb}'" #TEST

DB1="$(grep -H "^Package: ${PUPnameonly}$" ${PKGSa} ${PKGSb})"
# ...ex: /var/lib/apt/lists/deb.debian.org_debian_dists_bullseye_main_binary-amd64_Packages:Package: abiword
# maybe more than one hit, for example updates and main db.
#echo "DB1='${DB1}'" #TEST
if [ "$DB1" ];then
 while read aDB
 do
  #extract paragraph...
  FILE1="${aDB%%:*}" #ex: /var/lib/apt/lists/deb.debian.org_debian_dists_bullseye_main_binary-amd64_Packages
  STR1="${aDB#*:}" #ex: Package: abiword
  PTN1='/^'"${STR1}"'$/,/^$/p'
  sed -n "$PTN1" ${FILE1} > /tmp/debget/working/fnd-deb-para0
  if [ $SAMEflg -eq 1 ];then
   #found it, no need for any more processing
   mv -f /tmp/debget/working/fnd-deb-para0 /tmp/debget/working/fnd-deb-paras
   exit 0
  fi
  grep -q '^P' /tmp/debget/working/fnd-deb-para0
  if [ $? -eq 0 ];then
   #get out on first hit
   mv -f /tmp/debget/working/fnd-deb-para0 /tmp/debget/working/fnd-deb-para1
   break
  fi
 done <<_END1
$(echo "${DB1}")
_END1
fi

touch /tmp/debget/working/fnd-deb-paras
#more difficult, a pup-db entry created by '0pre-oe' in woofq, or
# pup built with, say, slackware pkgs.
# it has a generic name that may match to multiple entries in deb 'Packages' file...
FNDdebfile2="$(grep -H "^Filename: .*/${PUPnameonly}/[^/]*" ${PKGSa} ${PKGSb})"
#...ex: /var/lib/apt/lists/deb.debian.org_debian_dists_bullseye_main_binary-amd64_Packages:Filename: pool/main/a/abiword/abiword_3.0.5~dfsg-1_amd64.deb
#echo "FNDdebfile2='${FNDdebfile2}'" #TEST
if [ "$FNDdebfile2" ];then
 while read aFND
 do
  FILE1="${aFND%%:*}" #ex: /var/lib/apt/lists/deb.debian.org_debian_dists_bullseye_main_binary-amd64_Packages
  STR1="${aFND#*:}"   #ex: Filename: pool/main/a/abiword/abiword-common_3.0.5~dfsg-1_all.deb
  STR2="${STR1##*/}"  #ex: abiword-common_3.0.5~dfsg-1_all.deb
  PKGname="${STR2/_*/}" #ex: abiword-common
  case "${PKGname}" in
   *-dbg|*-dev|*-doc) continue ;;
  esac
  #check not already found, say in updates db...
  grep -q "^Package: ${PKGname}$" /tmp/debget/working/fnd-deb-paras
  if [ $? -ne 0 ];then
   PTN1='/^Package: '"${PKGname}"'$/,/^$/p'
   sed -n "$PTN1" ${FILE1} >> /tmp/debget/working/fnd-deb-paras
  fi
 done <<_END1
$(echo "${FNDdebfile2}")
_END1
fi

#merge -para1 into -paras ...
touch /tmp/debget/working/fnd-deb-para1
touch /tmp/debget/working/fnd-deb-paras
grep -q '^P' /tmp/debget/working/fnd-deb-para1 #2>/dev/null
if [ $? -eq 0 ];then
 grep -q '^P' /tmp/debget/working/fnd-deb-paras
 if [ $? -ne 0 ];then
  mv -f /tmp/debget/working/fnd-deb-para1 /tmp/debget/working/fnd-deb-paras
 else
  P1="$(grep '^Package: ' /tmp/debget/working/fnd-deb-para1)"
  grep -q "^${P1}$" /tmp/debget/working/fnd-deb-paras
  if [ $? -ne 0 ];then
   cat /tmp/debget/working/fnd-deb-para1 >> /tmp/debget/working/fnd-deb-paras
  fi
 fi
fi
rm -f /tmp/debget/working/fnd-deb-para1 2>/dev/null

#remove blank line from end of file...
#ref: https://unix.stackexchange.com/questions/552188/how-to-remove-empty-lines-from-beginning-and-end-of-file
#sed -i -z 's/^\n*\|\n*$/\n/g' /tmp/debget/working/fnd-deb-paras
#ref: https://stackoverflow.com/questions/4448826/removing-last-blank-line
#sed -i '${/^$/d;}' /tmp/debget/working/fnd-deb-paras
# ...last one works, but don't do it.

###end###
