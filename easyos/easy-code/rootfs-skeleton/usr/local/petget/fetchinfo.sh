#!/bin/sh
#called from installpreview.sh.
#passed param (also variable TREE1) is name of pkg, ex: abiword-1.2.3.
#/tmp/petget/current-repo-triad has the repository that installing from.
#w019 now have /root/.packages/PKGS_HOMEPAGES
#101221 yaf-splash fix.
#110523 Scientific Linux docs.
#120203 BK: internationalized.
#120515 support gentoo arm distro (built from bin tarballs from a gentoo sd image).
#120719 support raspbian.
#150419 added devuan support. refer: dimkr: https://github.com/puppylinux-woof-CE/woof-CE/pull/528/files
#170107 fix slackware db info.
#190219 add oe.
#20210612 replaced all yaf-splash with gtkdialog-splash. note, still ok to kill yaf-splash, see gtkdialog-splash script.
#20220122 fixed arch-linux url.
#20240226 fix for void
#20250510 remove ".sh" from TEXTDOMAIN

export TEXTDOMAIN=petget___fetchinfo
export OUTPUT_CHARSET=UTF-8

. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS
. /root/.packages/DISTRO_COMPAT_REPOS #170107

#ex: TREE1=abiword-1.2.4 (first field in database entry).
DB_FILE=Packages-`cat /tmp/petget/current-repo-triad` #ex: Packages-slackware-12.2-official

tPATTERN='^'"$TREE1"'|'
DB_ENTRY="`grep "$tPATTERN" /root/.packages/$DB_FILE | head -n 1`"
#line format: pkgname|nameonly|version|pkgrelease|category|size|path|fullfilename|dependencies|description|
#optionally on the end: compileddistro|compiledrelease|repo| (fields 11,12,13)

DB_nameonly="`echo -n "$DB_ENTRY" | cut -f 2 -d '|'`"
DB_fullfilename="`echo -n "$DB_ENTRY" | cut -f 8 -d '|'`"

DB_DISTRO="`echo -n "$DB_FILE" | cut -f 2 -d '-'`"  #exs: slackware  arch     ubuntu
DB_RELEASE="`echo -n "$DB_FILE" | cut -f 3 -d '-'`" #exs: 12.2       200902   intrepid
DB_SUB="`echo -n "$DB_FILE" | cut -f 4 -d '-'`"     #exs: official   extra    universe

case $DB_DISTRO in
 slackware)
  if [ ! -f /root/.packages/PACKAGES.TXT-${DB_SUB} ];then
   gtkdialog-splash -close never -bg orange -text "$(gettext 'Please wait, downloading database file to') /root/.packages/PACKAGES.TXT-${DB_SUB}..." &
   X5PID=$!
   cd /root/.packages
   #170107 fix downloading PACKAGES.TXT...
   #values for DB_SUB: official, patches, salix, salixextra, slacky
   [ -f PACKAGES.TXT ] && rm -f PACKAGES.TXT
   URL_DB="$(echo "$PKG_DOCS_DISTRO_COMPAT" | tr ' ' '\n' | grep "\-${DB_SUB}$" | cut -f 2 -d '|')"
   if [ "$URL_DB" ];then
    wget $URL_DB
    if [ $? -eq 0 ];then
     mv -f PACKAGES.TXT PACKAGES.TXT-${DB_SUB}
    fi
   fi
   kill $X5PID
  fi
  if [ ! -s /root/.packages/PACKAGES.TXT-${DB_SUB} ];then
   popup "level=top background=#800000 terminate=ok|$(gettext 'Sorry, the database could not be downloaded. Check your Internet connection.')"
   exit 1
  fi
  echo "DB_SUB=${DB_SUB} DB_fullfilename=${DB_fullfilename}"
  cat /root/.packages/PACKAGES.TXT-${DB_SUB} | tr -s ' ' | sed -e 's% $%%' | tr '%' ' ' | tr '\n' '%' | sed -e 's/%%/@/g' | grep -o "PACKAGE NAME: ${DB_fullfilename}[^@]*" | tr '%' '\n' > /tmp/petget_slackware_pkg_extra_info #170107
  sync
  if [ ! -s /tmp/petget_slackware_pkg_extra_info ];then #170107
   echo "$(gettext 'Sorry, could not find the package information.')
$(gettext 'Perhaps you need to update the package database')
$(gettext "-- see the 'Configure package manager' button")" > /tmp/petget_slackware_pkg_extra_info
  fi
  nohup defaulttextviewer /tmp/petget_slackware_pkg_extra_info &
 ;;
 debian|raspbian)
  nohup defaulthtmlviewer https://packages.debian.org/${DB_RELEASE}/${DB_nameonly} &
 ;;
 devuan) #150419
  nohup defaulthtmlviewer https://packages.devuan.org/ &
 ;;
 ubuntu)
  nohup defaulthtmlviewer https://packages.ubuntu.com/${DB_RELEASE}/${DB_nameonly} &
 ;;
 arch) #20220122 fix
  nohup defaulthtmlviewer https://www.archlinux.org/packages/${DB_SUB}/x86_64/${DB_nameonly}/ &
 ;;
 puppy|t2|gentoo|oe) #190219 add oe
  #rm -f /tmp/gethomepage_1 2>/dev/null
  #wget --tries=2 --output-document=/tmp/gethomepage_1 http://club.mandriva.com/xwiki/bin/view/rpms/Application/$DB_nameonly
  #LINK1="`grep 'View package information' /tmp/gethomepage_1 | head -n 1 | grep -o 'href=".*' | cut -f 2 -d '"'`"
  #rm -f /tmp/gethomepage_2 2>/dev/null
  #wget --tries=2 --output-document=/tmp/gethomepage_2 http://club.mandriva.com/xwiki/bin/view/rpms/Application/${LINK1}
  #HOMELINK="`grep 'Homepage:' /tmp/gethomepage_2 | grep -o 'href=".*' | cut -f 2 -d '"'`"
  #w019 fast (see also /usr/sbin/indexgen.sh)...
  HOMESITE="http://en.wikipedia.org/wiki/${DB_nameonly}"
  #121217 pkg name might differ - and _ chars...
  #nEXPATTERN="^${DB_nameonly} "
  #REALHOME="`cat /root/.packages/PKGS_HOMEPAGES | grep -i "$nEXPATTERN" | head -n 1 | cut -f 2 -d ' '`"
  nPTN1="^$(echo "${DB_nameonly}" | tr '-' '_') "
  nPTN2="^$(echo "${DB_nameonly}" | tr '_' '-') "
  REALHOME="`cat /root/.packages/PKGS_HOMEPAGES | grep -i "$nPTN1" | head -n 1 | cut -f 2 -d ' '`"
  [ "$REALHOME" = "" ] && REALHOME="`cat /root/.packages/PKGS_HOMEPAGES | grep -i "$nPTN2" | head -n 1 | cut -f 2 -d ' '`"
  [ "$REALHOME" != "" ] && HOMESITE="$REALHOME"
  nohup defaulthtmlviewer $HOMESITE &
 ;;
 scientific) #110523
  ###THIS IS INCOMPLETE###
  if [ ! -f /root/.packages/primary.xml ];then
   gtkdialog-splash -close never -bg orange -text "$(gettext 'Please wait, downloading database file to') /root/.packages/primary.xml..." &
   X5PID=$!
   cd /root/.packages
   wget http://ftp.scientificlinux.org/linux/scientific/${DISTRO_COMPAT_VERSION}/i386/os/repodata/primary.xml.gz
   sync
   gunzip primary.xml.gz
   kill $X5PID
  fi
  sync
  ###TODO: NEED TO EXTRACT INFO ON ONE PKG ONLY###
  nohup defaulttextviewer /root/.packages/primary.xml &
 ;;
 *) #20240226 void
  HOMESITE="$(grep -i -G "^${DB_nameonly} " /root/.packages/PKGS_HOMEPAGES | cut -f 2 -d ' ' | head -n 1)"
  if [ -z "$HOMESITE" ];then
   HOMESITE="http://en.wikipedia.org/wiki/${DB_nameonly}"
  fi
  nohup defaulthtmlviewer ${HOMESITE} &
 ;;
esac

###END###
