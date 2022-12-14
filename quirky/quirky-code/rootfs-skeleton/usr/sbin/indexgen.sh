#!/bin/bash
#(c) Copyright Barry Kauler 2009, puppylinux.com.
#2009 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html)
#generates index.html master help page. called from petget, rc.update,
#  /usr/local/petget/installpreview.sh, 3builddistro (in Woof).
#w012 commented-out drop-down for all installed pkgs as too big in Ubuntu-Puppy.
#w016 support/find_homepages (in Woof) used to manually update HOMEPAGEDB variable.
#w019 now have /root/.packages/PKGS_HOMEPAGES
#w464 reintroduce dropdown help for all builtin packages.
#v423 file PKGS_HOMEPAGES is now a db of all known pkgs, not just in puppy.
#120225 copy from raw doc files.
#131209 Packages-puppy- files renamed to Packages-pet-
#131214 fix for substitutions in index.html.bottom
#140204 fix substitutions in index.html.top. see also rootfs-skeleton/pinstall.sh

export LANG=C
. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION, DISTRO_PUPPYDATE
. /root/.packages/DISTRO_PKGS_SPECS

WKGDIR="`pwd`"

#120225 this is done in Woof by rootfs-skeleton/pinstall.sh, but do need to do it
#here to support language translations (see /usr/share/sss/doc_strings)...
if [ -f /usr/share/doc/index.html.top-raw ];then #see Woof rootfs-skeleton/pinstall.sh, also /usr/share/sss/doc_strings
 cp -f /usr/share/doc/index.html.top-raw /usr/share/doc/index.html.top
 cp -f /usr/share/doc/index.html.bottom-raw /usr/share/doc/index.html.bottom
 cp -f /usr/share/doc/home-raw.htm /usr/share/doc/home.htm

 cutDISTRONAME="`echo -n "$DISTRO_NAME" | cut -f 1 -d ' '`"
 cPATTERN="s/cutDISTRONAME/${cutDISTRONAME}/g"
 RIGHTVER="$DISTRO_VERSION"
 dPATTERN="s/PUPPYDATE/${DISTRO_PUPPYDATE}/g"
 PATTERN1="s/RIGHTVER/${RIGHTVER}/g"
 PATTERN2="s/DISTRO_VERSION/${DISTRO_VERSION}/g"
 nPATTERN="s/DISTRO_NAME/${DISTRO_NAME}/g"
 PATTERN9="s/DISTRO_FILE_PREFIX/${DISTRO_FILE_PREFIX}/g" #140204
 
 sed -i -e "$PATTERN9" -e "$PATTERN1" -e "$PATTERN2" /usr/share/doc/index.html.top #140204 split.
 sed -i -e "$nPATTERN" -e "$dPATTERN" -e "$cPATTERN" /usr/share/doc/index.html.top
 sed -i -e "$PATTERN1" -e "$PATTERN2" -e "$nPATTERN" -e "$dPATTERN" -e "$cPATTERN" /usr/share/doc/index.html.bottom #131214
 #...note, /usr/sbin/indexgen.sh puts these together as index.html (normally via rc.update and 3builddistro).
 
 sed -i -e "$nPATTERN" /usr/share/doc/home.htm
fi

#search for installed pkgs with descriptions...

#search .desktop files...
PKGINFO1="`ls -1 /usr/share/applications | sed -e 's%^%/usr/share/applications/%' | xargs cat - | grep '^Name=' | cut -f 2 -d '='`"
#...normal format of each entry is 'name description', ex: 'Geany text editor'.

#w012 commented out...
##search pkg database...
##want to get entries 'nameonly|description', ex: 'abiword|A wonderful wordprocessor'
##user-installed...
#USER_INSTALLED_INFO="`cut -f 2,10 -d '|' /root/.packages/user-installed-packages`"
##builtin pet pkgs...
#if [ ! -f /tmp/petget_builtin_pet ];then
# BUILTIN_PET_NAMES="`echo "$PKGS_SPECS_TABLE" | grep '^yes' | cut -f 2,3 -d '|' | grep '|$' | sed -e 's%^%|%'`" #ex: '|abiword|'
# echo "$BUILTIN_PET_NAMES" > /tmp/petget_builtin_pet
#fi
#BUILTIN_PET_INFO="`grep --file=/tmp/petget_builtin_pet /root/.packages/Packages-pet-* | cut -f 2-9 -d ':' | cut -f 2,10 -d '|'`"
##builtin compatible-distro pkgs...
#if [ ! -f /tmp/petget_builtin_system ];then #pkg_chooser.sh creates this.
# BUILTIN_COMPAT_NAMES="`echo "$PKGS_SPECS_TABLE" | grep '^yes' | cut -f 3 -d '|' | tr ',' '\n' | sort -u | grep -v '^$' | sed -e 's%[0-9]$%%' -e 's%\\-%\\\\-%g' -e 's%\\*%.*%g' -e 's%^%^%'`"
# echo "$BUILTIN_COMPAT_NAMES" >/tmp/petget_builtin_system
#fi
#BUILTIN_COMPAT_INFO="`grep --file=/tmp/petget_builtin_system /root/.packages/Packages-${DISTRO_BINARY_COMPAT}-*  | cut -f 2-9 -d ':' | cut -f 2,10 -d '|'`"
#PKGINFODB="${USER_INSTALLED_INFO}
#${BUILTIN_PET_INFO}
#${BUILTIN_COMPAT_INFO}"
##tidy it up...
#PKGINFODB="`echo "$PKGINFODB" | grep -v -E '_DEV|_DOC|_NLD' | sort --key=1 --field-separator='|' --unique | sed -e 's%|%||||||||||||||||||||||||||||||%' | uniq --check-chars=32 | tr -s '|'`"
##...code on end gets rid of multiple hits.

EXCLLISTsd=" 0rootfs_skeleton autologin bootflash burniso2cd cd/dvd check configure desktop format network pupdvdtool wallpaper pbackup pburn pcdripper pdict pdisk pdvdrsab pmetatagger pschedule pstopwatch prename pprocess pmirror pfind pcdripper pmount puppy pupctorrent pupscan pupx pwireless set text "

cp -f /usr/share/doc/index.html.top /tmp/newinfoindex.xml

#dropdown menu for apps in menu...
echo '<p>Applications available in the desktop menu:</p>' >>/tmp/newinfoindex.xml
echo '<center>
<form name="form">
<select name="site" size="1" onchange="javascript:formHandler()">
' >>/tmp/newinfoindex.xml
echo "$PKGINFO1" |
while read ONEINFO
do
 NAMEONLY="`echo "$ONEINFO" | cut -f 1 -d ' ' | tr [A-Z] [a-z]`"
 EXPATTERN=" $NAMEONLY "
 nEXPATTERN="^$NAMEONLY "
 [ "`echo "$EXCLLISTsd" | grep -i "$EXPATTERN"`" != "" ] && continue
 HOMESITE="http://en.wikipedia.org/wiki/${NAMEONLY}"
 REALHOME="`cat /root/.packages/PKGS_HOMEPAGES | grep -i "$nEXPATTERN" | head -n 1 | cut -f 2 -d ' '`"
 [ "$REALHOME" != "" ] && HOMESITE="$REALHOME"
 echo "<option value=\"${HOMESITE}\">${ONEINFO}" >> /tmp/newinfoindex.xml
done
echo '</select>
</form>
</center>
' >> /tmp/newinfoindex.xml

#w464 dropdown list of all builtin pkgs...
echo '<p>Complete list of packages (in Puppy or not):</p>' >>/tmp/newinfoindex.xml
echo '<center>
<form name="form2">
<select name="site2" size="1" onchange="javascript:formHandler2()">
' >>/tmp/newinfoindex.xml
sed -e 's% %|%' -e 's%$%|%' /root/.packages/PKGS_HOMEPAGES > /tmp/pkgs_homepages_mod
printcols /tmp/pkgs_homepages_mod 2 1 | sed -e 's%^%<option value="%' -e 's%|$%#%' -e 's%|%">%' -e 's%#$%%' >> /tmp/newinfoindex.xml
sync
echo '</select>
</form>
</center>
' >> /tmp/newinfoindex.xml

#w012 commented out...
##dropdown menu for all installed pkgs...
#echo '<p>All packages installed in Puppy:</p>' >>/tmp/newinfoindex.xml
#echo '<center>
#<form name="form2">
#<select name="site2" size="1" onchange="javascript:formHandler2()">
#' >>/tmp/newinfoindex.xml
#echo "$PKGINFODB" |
#while read ONEINFO
#do
# [ "$ONEINFO" = "" ] && continue
# NAMEONLY="`echo "$ONEINFO" | cut -f 1 -d '|' | tr [A-Z] [a-z]`"
# EXPATTERN=" $NAMEONLY "
# nEXPATTERN="^$NAMEONLY "
# [ "`echo "$EXCLLISTsd" | grep -i "$EXPATTERN"`" != "" ] && continue
# HOMESITE="http://en.wikipedia.org/wiki/${NAMEONLY}"
# REALHOME="`echo "$HOMEPAGEDB" | grep -i "$nEXPATTERN" | head -n 1 | cut -f 2 -d ' '`"
# [ "$REALHOME" != "" ] && HOMESITE="$REALHOME"
# xONEINFO="`echo -n "$ONEINFO" | sed 's%|%:  %'`"
# echo "<option value=\"${HOMESITE}\">${xONEINFO}" >> /tmp/newinfoindex.xml
#done
#echo '</select>
#</form>
#</center>
#' >> /tmp/newinfoindex.xml

##dropdown menu for all executables...
#echo '<p>All executable files in Puppy:</p>' >>/tmp/newinfoindex.xml
#echo '<center>
#<form name="form">
#<select name="site" size="1" onchange="javascript:formHandler()">
#' >>/tmp/newinfoindex.xml
#echo "$PKGINFONODESCR" |
#while read ONEINFO
#do
# [ "`echo "$ONEINFO" | grep -E 'NOTUSED|FULL|\.bin$|config$|README|OLD|\.glade$'`" != "" ] && continue
# EXPATTERN=" $ONEINFO "
# [ "`echo "$EXCLLISTsd" | grep -i "$EXPATTERN"`" != "" ] && continue
# echo "<option value=\"http://linux.die.net/man/${ONEINFO}\">${ONEINFO}</option>" >> /tmp/newinfoindex.xml
#done
#echo '</select>
#</form>
#</center>
#' >> /tmp/newinfoindex.xml

#now complete the index.html file...
cat /usr/share/doc/index.html.bottom >> /tmp/newinfoindex.xml
mv -f /tmp/newinfoindex.xml /usr/share/doc/index.html


###END###
