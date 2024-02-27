#!/bin/sh
#(c) Copyright Barry Kauler 2009, puppylinux.com
#2009 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html).
#called from pkg_chooser.sh, provides filtered formatted list of uninstalled pkgs.
# ...this has written to /tmp/petget/petget_pkg_first_char, ex: 'mn'
#filter category may be passed param to this script, ex: 'Document'
# or, /tmp/petget/petget_filtercategory was written by pkg_chooser.sh.
#repo may be written to /tmp/petget/current-repo-triad by pkg_chooser.sh, ex: slackware-12.2-official
#/tmp/petget/petget_pkg_name_aliases_patterns setup in pkg_chooser.sh, name aliases.
#written for Woof, standardised package database format.
#v425 'ALL' may take awhile, put up please wait msg.
#100716 PKGS_MANAGEMENT file has new variable PKG_PET_THEN_BLACKLIST_COMPAT_KIDS.
#101129 checkboxes for show EXE DEV DOC NLS.
#101221 yaf-splash fix.
#110530 ignore packages with different kernel version number, format -k2.6.32.28- in pkg name (also findnames.sh)...
#120203 BK: internationalized.
#120504 some files moved into /tmp/petget
#120504b improved dev,doc,nls,exe pkg selection.
#120515 dev,doc,exe selection for Mageia .rpm pkgs, fix for 120504b.
#120515 common code from pkg_chooser.sh, findnames.sh, filterpkgs.sh, extracted to /usr/local/petget/postfilterpkgs.sh.
#120719 support raspbian.
#120811 category field now supports sub-category |category;subcategory|, use as icon in ppm main window.
#120813 fix search pattern for optional subcategory. 120813 fix.
#120817 modification of category field now done in postfilterpkgs.sh.
#130330 GUI filtering. see pkg_chooser.sh, ui_Classic, ui_Ziggy. 130331 ignore case. need backslashes.
#130331 more GUI filter options.
#130507 fix GUI filter.
#130511 pkg_chooser.sh has created layers-installed-packages (use instead of woof-installed-packages).
#140107 add fox pkg to gui filter.
#150419 added devuan support. refer: dimkr: https://github.com/puppylinux-woof-CE/woof-CE/pull/528/files
#180429 woofQ changed "Package-*" 2nd field from "puppy" to "pet" ages ago.
#20210612 replaced all yaf-splash with gtkdialog-splash. note, still ok to kill yaf-splash, see gtkdialog-splash script.
#20230914 stupid grep now objects to '\-' use busybox grep. no, grep -P works. no, in case only have busybox grep, it doesn't understand -P
#20240227 add gtk4, qt6

export TEXTDOMAIN=petget___filterpkgs.sh
export OUTPUT_CHARSET=UTF-8

#export LANG=C

. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS
. /root/.packages/PKGS_MANAGEMENT #has PKG_ALIASES_INSTALLED, PKG_NAME_ALIASES

#130330 GUI filtering... 20240227...
DEFGUIFILTER="$(cat /var/local/petget/gui_filter)"
#$GUIONLYSTR $ANYTYPESTR are exported from pkg_chooser.sh ... 130331 need backslashes...
guigtk2PTN='\+libgtk2|\+libgtk\+2|\+libgtkmm-2|\+gtk\+2|\+gtk\+,|\+gtkdialog|\+xdialog|\+python-gtk2'
guigtk3PTN='\+libgtk-3|\+libgtk\+3|\+libgtkmm-3|\+gtk\+3'
guigtk4PTN='\+gtk4'
guiqt4PTN='\+libqtgui4|\+qt,'
guiqt5PTN='\+libqt5gui|\+libqtgui5'
guiqt6PTN='\+qt6|\+libqt6'
exclguiPTN=''
EXCPARAM=''
case $DEFGUIFILTER in
 $GUIONLYSTR) guiPTN='\+libx11|\+fox'"|$guigtk2PTN|$guigtk3PTN|$guiqt4PTN|$guiqt5PTN" ;; #140107 add fox.
 GTK+2*)      guiPTN="$guigtk2PTN" ;;
 GTK+3*)      guiPTN="$guigtk3PTN" ;;
 GTK4*)      guiPTN="$guigtk4PTN" ;;
 Qt4*KDE)     guiPTN="$guiqt4PTN" ; exclguiPTN='kde' ;; #130331
 Qt4*)        guiPTN="$guiqt4PTN" ;;
 Qt5*KDE)     guiPTN="$guiqt5PTN" ; exclguiPTN='kde' ;; #130331
 Qt5*)        guiPTN="$guiqt5PTN" ;;
 Qt6*)        guiPTN="$guiqt6PTN" ;;
 Qt6*KDE)     guiPTN="$guiqt6PTN" ; exclguiPTN='kde' ;;
 $NONGUISTR)  guiPTN='\+libx11|\+fox'"|$guigtk2PTN|$guigtk3PTN|$guigtk4PTN|$guiqt4PTN|$guiqt5PTN|$guiqt6PTN" ; EXCPARAM='-v' ;; #130331 140107
 *)           guiPTN="|" ;; #$ANYTYPESTR, let everything through.
esac
#130507 remove...
#[ ! -f /var/local/petget/gui_filter_prev ] && cp -f /var/local/petget/gui_filter /var/local/petget/gui_filter_prev
#PREVGUIFILTER="$(cat /var/local/petget/gui_filter_prev)"

#130507
xDEFGUIFILTER="$(echo -n "$DEFGUIFILTER" | tr -d ' ' | tr -d '-' | tr -d '+' | tr -d ',')" #ex, translate 'Qt4 GUI apps only' to 'Qt4GUIappsonly'

#alphabetic group...
PKG_FIRST_CHAR="`cat /tmp/petget/petget_pkg_first_char`" #written in pkg_chooser.sh, ex: 'mn'
[ "$PKG_FIRST_CHAR" = "ALL" ] && PKG_FIRST_CHAR='a-z0-9'

X1PID=0
if [ "`cat /tmp/petget/petget_pkg_first_char`" = "ALL" ];then
# /usr/X11R7/bin/yaf-splash -font "8x16" -outline 0 -margin 4 -bg orange -text "Please wait, processing all entries may take awhile..." &
 gtkdialog-splash -close never -bg orange -text "$(gettext 'Please wait, processing all entries may take awhile...')" &
 X1PID=$!
fi

#which repo...
FIRST_DB="`ls -1 /root/.packages/Packages-${DISTRO_BINARY_COMPAT}-${DISTRO_COMPAT_VERSION}* | head -n 1 | rev | cut -f 1 -d '/' | rev | cut -f 2-4 -d '-'`"
fltrREPO_TRIAD="$FIRST_DB" #ex: slackware-12.2-official
#or, a selection was made in the main gui (pkg_chooser.sh)...
[ -f /tmp/petget/current-repo-triad ] && fltrREPO_TRIAD="`cat /tmp/petget/current-repo-triad`"

REPO_FILE="`find /root/.packages -type f -name "Packages-${fltrREPO_TRIAD}*" | head -n 1`"

#choose a category in the repo...
#$1 exs: Document, Internet, Graphic, Setup, Desktop
fltrCATEGORY="Desktop" #show Desktop category pkgs.
if [ $1 ];then
 fltrCATEGORY="$1"
 echo "$1" > /tmp/petget/petget_filtercategory
else
 #or, a selection was made in the main gui (pkg_chooser.sh)...
 [ -f /tmp/petget/petget_filtercategory ] && fltrCATEGORY="`cat /tmp/petget/petget_filtercategory`"
fi
#120813 there may be optional subcategory, put ; into pattern...
categoryPATTERN="|${fltrCATEGORY}[;|]"
[ "$fltrCATEGORY" = "ALL" ] && categoryPATTERN="|" #let everything through.

#130507 remove...
##130330...
#if [ "$DEFGUIFILTER" != "$PREVGUIFILTER" ];then
# rm -f /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_Packages-${fltrREPO_TRIAD}
# echo -n "$DEFGUIFILTER" > /var/local/petget/gui_filter_prev
#fi

#find pkgs in db starting with $PKG_FIRST_CHAR and by distro and category...
#each line: pkgname|nameonly|version|pkgrelease|category|size|path|fullfilename|dependencies|description|
#optionally on the end: compileddistro|compiledrelease|repo| (fields 11,12,13)
#filter the repo pkgs by first char and category, also extract certain fields...
#w017 filter out all 'lib' pkgs, too many for gtkdialog (ubuntu/debian only)...
#w460 filter out all 'language-' pkgs, too many (ubuntu/debian)...
if [ ! -f /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_${xDEFGUIFILTER}_Packages-${fltrREPO_TRIAD} ];then
 case $DISTRO_BINARY_COMPAT in
  ubuntu|debian|raspbian|devuan) #150419
   FLTRD_REPO="`printcols $REPO_FILE 1 2 3 5 10 6 9 | grep -v -E '^lib|^language\\-' | grep -i "^[${PKG_FIRST_CHAR}]" | grep "$categoryPATTERN" | grep -i ${EXCPARAM} -E "$guiPTN" | sed -e 's%||$%|unknown|%'`" #130330  130331 ignore case.
  ;;
  *)
   FLTRD_REPO="`printcols $REPO_FILE 1 2 3 5 10 6 9 | grep -i "^[${PKG_FIRST_CHAR}]" | grep "$categoryPATTERN" | grep -i ${EXCPARAM} -E "$guiPTN" | sed -e 's%||$%|unknown|%'`" #130330  130331 ignore case.
  ;;
 esac
 #...extracted fields, reordered: pkgname|nameonly|version|category|description|size|dependencies
 if [ "$exclguiPTN" ];then #130331
  #well well, news to me, this has to be done in two steps...
  FLTRD_REPO1="$(echo "$FLTRD_REPO" | grep -i -v "$exclguiPTN")"
  FLTRD_REPO="$FLTRD_REPO1"
 fi
 echo "$FLTRD_REPO" > /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_${xDEFGUIFILTER}_Packages-${fltrREPO_TRIAD}
 #...file ex: /tmp/petget/petget_fltrd_repo_a_Document_Packages-slackware-12.2-official
fi

#w480 extract names of packages that are already installed...
shortPATTERN="`cut -f 2 -d '|' /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_${xDEFGUIFILTER}_Packages-${fltrREPO_TRIAD} | sed -e 's%^%|%' -e 's%$%|%'`"
echo "$shortPATTERN" > /tmp/petget/petget_shortlist_patterns
INSTALLED_CHAR_CAT="`cat /root/.packages/layers-installed-packages /root/.packages/user-installed-packages | grep --file=/tmp/petget/petget_shortlist_patterns`" #130511
#make up a list of filter patterns, so will be able to filter pkg db...
if [ "$INSTALLED_CHAR_CAT" ];then #100711
 INSTALLED_PATTERNS="`echo "$INSTALLED_CHAR_CAT" | cut -f 2 -d '|' | sed -e 's%^%|%' -e 's%$%|%'`"
 echo "$INSTALLED_PATTERNS" > /tmp/petget/petget_installed_patterns
else
 echo -n "" > /tmp/petget/petget_installed_patterns
fi

#packages may have different names, add them to installed list (refer pkg_chooser.sh)...
INSTALLEDALIASES="`grep --file=/tmp/petget/petget_installed_patterns /tmp/petget/petget_pkg_name_aliases_patterns | tr ',' '\n'`"
[ "$INSTALLEDALIASES" ] && echo "$INSTALLEDALIASES" >> /tmp/petget/petget_installed_patterns

#w480 pkg_chooser has created this, pkg names that need to be ignored (for whatever reason)...
cat /tmp/petget/petget_pkg_name_ignore_patterns >> /tmp/petget/petget_installed_patterns

#110530 ignore packages with different kernel version number, format -k2.6.32.28- in pkg name...
GOODKERNPTN="`uname -r | sed -e 's%\.%\\\.%g' -e 's%^%\\\-k%' -e 's%$%$%'`" #ex: \-k2.6.32$
BADKERNPTNS="`busybox grep -o '\-k2\.6\.[^-|a-zA-Z]*' /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_${xDEFGUIFILTER}_Packages-${fltrREPO_TRIAD} | cut -f 1 -d '|' | grep -v "$GOODKERNPTN" | sed -e 's%$%-%' -e 's%\.%\\\.%g' -e 's%\-%\\\-%g'`" #ex: \-k2\.6\.32\.28\-
[ "$BADKERNPTNS" ] && echo "$BADKERNPTNS" >> /tmp/petget/petget_installed_patterns

#100716 PKGS_MANAGEMENT file has new variable PKG_PET_THEN_BLACKLIST_COMPAT_KIDS...
#180429 woofQ changed field from "puppy" to "pet" ages ago. fix...
xDBC="`echo -n "${fltrREPO_TRIAD}" | cut -f 1 -d '-'`" #ex: slackware-12.2-official 1st-param is $DISTRO_BINARY_COMPAT
if [ "$xDBC" != "pet" ];then #not PET pkgs. 180429
 for ONEPTBCK in $PKG_PET_THEN_BLACKLIST_COMPAT_KIDS
 do
  pONEPTBCK='|'"$ONEPTBCK"'|' #ex: |ffmpeg|
  fONEPTBCK="`grep "$pONEPTBCK" /root/.packages/layers-installed-packages /root/.packages/user-installed-packages | busybox grep '\.pet|'`" #130511 20230914
  #if it is a PET, then filter-out any compat-distro pkgs that depend on it...
  [ "fONEPTBCK" != "" ] && echo '+'"$ONEPTBCK"'[,|]' >> /tmp/petget/petget_installed_patterns
 done
fi

#clean it up...
grep -v '^$' /tmp/petget/petget_installed_patterns > /tmp/petget/petget_installed_patterns-tmp
mv -f /tmp/petget/petget_installed_patterns-tmp /tmp/petget/petget_installed_patterns

#filter out installed pkgs from the repo pkg list...
#ALIASES_PATTERNS="`echo -n "$PKG_ALIASES_INSTALLED" | tr -s ' ' | sed -e 's%^ %%' -e 's% $%%' | tr ' ' '\n' | sed -e 's%^%|%' -e 's%$%|%'`"
#echo "$ALIASES_PATTERNS" >> /tmp/petget/petget_installed_patterns
fprPTN="s%$%|${fltrREPO_TRIAD}%" #120504 append repo-triad on end of each line.
#FPR="`grep --file=/tmp/petget/petget_installed_patterns -v /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_Packages-${fltrREPO_TRIAD} | cut -f 1,5 -d '|' | sed -e "$fprPTN"`"
#120811 keep subcategory for icon (if no subcategory, will use category)... 120813 fix...
#120813 pick subcategory if it exists...
#120817 no, modify category field in postfilterpkgs.sh...
#FPR="`grep --file=/tmp/petget/petget_installed_patterns -v /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_Packages-${fltrREPO_TRIAD} | cut -f 1,4,5 -d '|' | sed -e 's%|Document;%|%' -e 's%|Desktop;%|%' -e 's%|System;%|%' -e 's%|Setup;%|%' -e 's%|Utility;%|%' -e 's%|Filesystem;%|%' -e 's%|Graphic;%|%' -e 's%|Business;%|%' -e 's%|Personal;%|%' -e 's%|Network;%|%' -e 's%|Internet;%|%' -e 's%|Multimedia;%|%' -e 's%|Fun;%|%' | sed -e "$fprPTN"`"
FPR="`grep --file=/tmp/petget/petget_installed_patterns -v /tmp/petget/petget_fltrd_repo_${PKG_FIRST_CHAR}_${fltrCATEGORY}_${xDEFGUIFILTER}_Packages-${fltrREPO_TRIAD} | cut -f 1,4,5 -d '|' | sed -e "$fprPTN"`"
if  [ "$FPR" = "|${fltrREPO_TRIAD}" ];then
 echo -n "" > /tmp/petget/filterpkgs.results #nothing.
else
 echo "$FPR" > /tmp/petget/filterpkgs.results
fi
#...'pkgname|category|description|repo-triad' has been written to /tmp/petget/filterpkgs.results for main gui.

#120515 post-filter /tmp/petget/filterpkgs.results.post according to EXE,DEV,DOC,NLS checkboxes...
/usr/local/petget/postfilterpkgs.sh
#...main gui will read /tmp/petget/filterpkgs.results.post (actually that happens in ui_Classic or ui_Ziggy, which is included in pkg_chooser.sh).

[ $X1PID -ne 0 ] && kill $X1PID

###END###

