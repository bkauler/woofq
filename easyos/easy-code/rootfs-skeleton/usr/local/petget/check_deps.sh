#!/bin/sh
#choose an installed pkg and find all its dependencies.
#when entered with a passed param, it is a list of pkgs, '|' delimited,
#ex: abiword-1.2.3|aiksaurus-3.4.5|yabby-5.0
#100718 bug fix: code block copied from /usr/local/petget/pkg_chooser.sh
#100718 reduce size of missing-libs list, to fit in window.
#100830 missing libs, but some pkgs have a startup script that makes some libs visible.
#101220 reported missing 'alsa-lib' but wary has 'alsa-lib21a', quick hack fix.
#101221 yaf-splash fix.
#110706 finding missing dependencies fix (running mageia 1).
#120203 BK: internationalized.
#120222 npierce: use list widget, support '_' in name.
#120905 vertical scrollbars, fix window too high.
#130511 need to include devx-only-installed-packages, if loaded.
#140214 remove duplicate missing libs.
#151105 change gtkdialog4 to gtkdialog.
#170815 now PKGget. 180208 now PETget
#20210612 replaced all yaf-splash with gtkdialog-splash. note, still ok to kill yaf-splash, see gtkdialog-splash script.
#20220126 now PKGget.
#20220629 replace "Puppy" with "EasyOS".
#20220905 dpkg/apt support.
#20230708 handle file names with space char.
#20250510 remove ".sh" from TEXTDOMAIN

export TEXTDOMAIN=petget___check_deps
export OUTPUT_CHARSET=UTF-8

. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS

echo -n "" > /tmp/missinglibs.txt
echo -n "" > /tmp/missinglibs_details.txt
echo -n "" > /tmp/missingpkgs.txt
echo -n "" > /tmp/missinglibs_cut.txt #100830
echo -n "" > /tmp/missinglibs_hidden.txt #100830

###130511 also this copied from pkg_chooser.sh...
if [ ! -f /root/.packages/layers-installed-packages ];then
 #need to include devx-only-installed-packages, if loaded...
 if which gcc;then
  cp -f /root/.packages/woof-installed-packages /tmp/petget/ppm-layers-installed-packages
  cat /root/.packages/devx-only-installed-packages >> /tmp/petget/ppm-layers-installed-packages
  sort -u /tmp/petget/ppm-layers-installed-packages > /root/.packages/layers-installed-packages
 else
  cp -f /root/.packages/woof-installed-packages /root/.packages/layers-installed-packages
 fi
fi

#######100718 code block copied from /usr/local/petget/pkg_chooser.sh#######
. /root/.packages/PKGS_MANAGEMENT #has PKG_REPOS_ENABLED, PKG_NAME_ALIASES

#finds all user-installed pkgs and formats ready for display...
/usr/local/petget/finduserinstalledpkgs.sh #writes to /tmp/installedpkgs.results

#100711 moved from findmissingpkgs.sh...
if [ ! -f /tmp/petget/petget_installed_patterns_system ];then
 INSTALLED_PATTERNS_SYS="`cat /root/.packages/layers-installed-packages | cut -f 2 -d '|' | sed -e 's%^%|%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
 echo "$INSTALLED_PATTERNS_SYS" > /tmp/petget/petget_installed_patterns_system
 #PKGS_SPECS_TABLE also has system-installed names, some of them are generic combinations of pkgs...
 INSTALLED_PATTERNS_GEN="`echo "$PKGS_SPECS_TABLE" | grep '^yes' | cut -f 2 -d '|' |  sed -e 's%^%|%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
 echo "$INSTALLED_PATTERNS_GEN" >> /tmp/petget/petget_installed_patterns_system
 sort -u /tmp/petget/petget_installed_patterns_system > /tmp/petget/petget_installed_patterns_systemx
 mv -f /tmp/petget/petget_installed_patterns_systemx /tmp/petget/petget_installed_patterns_system
fi
#100711 this code repeated in findmissingpkgs.sh...
cp -f /tmp/petget/petget_installed_patterns_system /tmp/petget/petget_installed_patterns_all
INSTALLED_PATTERNS_USER="`cat /root/.packages/user-installed-packages | cut -f 2 -d '|' | sed -e 's%^%|%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
echo "$INSTALLED_PATTERNS_USER" >> /tmp/petget/petget_installed_patterns_all

#20220905 dpkg/apt support. this code also in pkg_chooser.sh and findmissingpkgs.sh
echo -n '' > /tmp/petget/petget_installed_patterns_dpkg
if [ -s /var/local/pkgget/deb_compat_specs ];then
 if [ -d /var/lib/dpkg/info ];then
  (cd /var/lib/dpkg/info && ls -1 *.list) > /tmp/petget/petget_installed_patterns_dpkg
  sed -i -e 's%\.list$%%' /tmp/petget/petget_installed_patterns_dpkg
  sed -i -e 's%^%|%' -e 's%$%|%' -e 's%\-%\\-%g' /tmp/petget/petget_installed_patterns_dpkg
  if [ -s /tmp/petget/petget_installed_patterns_dpkg ];then
   cat /tmp/petget/petget_installed_patterns_dpkg >> /tmp/petget/petget_installed_patterns_all
   sort -u /tmp/petget/petget_installed_patterns_all > /tmp/petget/petget_installed_patterns_allTEMP
   mv -f /tmp/petget/petget_installed_patterns_allTEMP /tmp/petget/petget_installed_patterns_all
  fi
 fi
fi

#process name aliases into patterns (used in filterpkgs.sh, findmissingpkgs.sh) ... 100126...
xPKG_NAME_ALIASES="`echo "$PKG_NAME_ALIASES" | tr ' ' '\n' | grep -v '^$' | sed -e 's%^%|%' -e 's%$%|%' -e 's%,%|,|%g' -e 's%\\*%.*%g'`"
echo "$xPKG_NAME_ALIASES" > /tmp/petget/petget_pkg_name_aliases_patterns_raw #110706
cp -f /tmp/petget/petget_pkg_name_aliases_patterns_raw /tmp/petget/petget_pkg_name_aliases_patterns #110706 _raw see findmissingpkgs.sh

sed -e 's%\\%%g' /tmp/petget/petget_installed_patterns_all > /tmp/petget/petget_installed_patterns_all2 #101220 hack bugfix, \- should be just -.

#100711 above has a problem as it has wildcards. need to expand...
#ex: PKG_NAME_ALIASES has an entry 'cxxlibs,glibc*,libc-*', the above creates '|cxxlibs|,|glibc.*|,|libc\-.*|',
#    after expansion: '|cxxlibs|,|glibc|,|libc-|,|glibc|,|glibc_dev|,|glibc_locales|,|glibc-solibs|,|glibc-zoneinfo|'
echo -n "" > /tmp/petget/petget_pkg_name_aliases_patterns_expanded
for ONEALIASLINE in `cat /tmp/petget/petget_pkg_name_aliases_patterns | tr '\n' ' '` #ex: |cxxlibs|,|glibc.*|,|libc\-.*|
do
 echo -n "" > /tmp/petget/petget_temp1
 for PARTONELINE in `echo -n "$ONEALIASLINE" | tr ',' ' '`
 do
  grep "$PARTONELINE" /tmp/petget/petget_installed_patterns_all2 >> /tmp/petget/petget_temp1 #101220 hack see above.
 done
 ZZZ="`echo "$ONEALIASLINE" | sed -e 's%\.\*%%g' | tr -d '\\'`"
 [ -s /tmp/petget/petget_temp1 ] && ZZZ="${ZZZ},`cat /tmp/petget/petget_temp1 | tr '\n' ',' | tr -s ',' | tr -d '\\'`"
 ZZZ="`echo -n "$ZZZ" | sed -e 's%,$%%'`"
 echo "$ZZZ" >> /tmp/petget/petget_pkg_name_aliases_patterns_expanded
done
cp -f /tmp/petget/petget_pkg_name_aliases_patterns_expanded /tmp/petget/petget_pkg_name_aliases_patterns

#w480 PKG_NAME_IGNORE is definedin PKGS_MANAGEMENT file... 100126...
xPKG_NAME_IGNORE="`echo "$PKG_NAME_IGNORE" | tr ' ' '\n' | grep -v '^$' | sed -e 's%^%|%' -e 's%$%|%' -e 's%,%|,|%g' -e 's%\\*%.*%g'`"
echo "$xPKG_NAME_IGNORE" > /tmp/petget/petget_pkg_name_ignore_patterns
#######100718 end copied code block#######

dependcheckfunc() {
 #entered with ex: APKGNAME=abiword-1.2.3
 
 gtkdialog-splash -close never -bg orange -placement center -text "$(gettext 'Checking') ${APKGNAME} $(gettext 'for missing shared library files...')" &
 X1PID=$!
 
 #a hack if OO is installed...
 if [ "`echo -n "$APKGNAME" | grep 'openoffice'`" != "" ];then
  [ -d /opt ] && FNDOO="`find /opt -maxdepth 2 -type d -iname 'openoffice*'`"
  [ "$FNDOO" = "" ] && FNDOO="`find /usr -maxdepth 2 -type d -iname 'openoffice*'`"
  [ "$FNDOO" = "" ] && LD_LIBRARY_PATH="${FNDOO}/program:${LD_LIBRARY_PATH}"
 fi

 #20230708 handle files with space char...
 #FNDFILES="`cat /root/.packages/$APKGNAME.files`"
 #for ONEFILE in $FNDFILES
 while read ONEFILE
 do
  #ignore path/file if has space...
  if [ "${ONEFILE/ /}" != "${ONEFILE}" ];then
   continue
  fi
  ISANEXEC="`file --brief $ONEFILE | grep --extended-regexp "LSB executable|shared object"`"
  if [ ! "$ISANEXEC" = "" ];then
   LDDRESULT="`ldd $ONEFILE`"
   MISSINGLIBS="`echo "$LDDRESULT" | grep "not found" | cut -f 2 | cut -f 1 -d " " | tr "\n" " "`"
   if [ ! "$MISSINGLIBS" = "" ];then
    echo "$(gettext 'File') $ONEFILE $(gettext 'has these missing library files:')" >> /tmp/missinglibs_details.txt #100718
    echo " $MISSINGLIBS" >> /tmp/missinglibs_details.txt #100718
    echo " $MISSINGLIBS" >> /tmp/missinglibs.txt #100718
   fi
  fi
 done<<_END1
$(cat /root/.packages/$APKGNAME.files)
_END1
 if [ -s /tmp/missinglibs.txt ];then #100718 reduce size of list, to fit in window...
  MISSINGLIBSLIST="`cat /tmp/missinglibs.txt | tr '\n' ' ' | tr -s ' ' | tr ' ' '\n' | sort -u | tr '\n' ' '`"
  echo "$MISSINGLIBSLIST" > /tmp/missinglibs.txt
  #100830 some packages, such as EudoraOSE-1.0rc1-Lucid.pet used in Lucid Puppy 5.1, have a
  #startup script that makes some libs visible (/opt/eudora), so do this extra check...
  for ONEMISSINGLIB in `cat /tmp/missinglibs.txt` #100830
  do
   if [ "`find /opt /usr/lib /usr/local/lib -maxdepth 3 -name $ONEMISSINGLIB`" == "" ];then
    echo -n "$ONEMISSINGLIB " >> /tmp/missinglibs_cut.txt
   else
    echo -n "$ONEMISSINGLIB " >> /tmp/missinglibs_hidden.txt
   fi
  done
  cp -f /tmp/missinglibs_cut.txt /tmp/missinglibs.txt
 fi
 kill $X1PID
}

#searches deps of all user-installed pkgs...
missingpkgsfunc() {
# yaf-splash -close never -font "8x16" -outline 0 -margin 4 -bg orange -text "Checking all user-installed packages for any missing dependencies..." &
 gtkdialog-splash -close never -bg orange -text "$(gettext 'Checking all user-installed packages for any missing dependencies...')" &
 X2PID=$!
  USER_DB_dependencies="`cat /root/.packages/user-installed-packages | cut -f 9 -d '|' | tr ',' '\n' | sort -u | tr '\n' ','`"
  /usr/local/petget/findmissingpkgs.sh "$USER_DB_dependencies"
  #...returns /tmp/petget/petget_installed_patterns_all, /tmp/petget/petget_pkg_deps_patterns, /tmp/petget_missingpkgs_patterns
  MISSINGDEPS_PATTERNS="`cat /tmp/petget_missingpkgs_patterns`" #v431
  #/tmp/petget_missingpkgs_patterns has a list of missing dependencies, format ex:
  #|kdebase|
  #|kdelibs|
  #|mesa|
  #|qt|
  kill $X2PID
}

if [ $1 ];then
 for APKGNAME in `echo -n $1 | tr '|' ' '`
 do
  [ -f /root/.packages/${APKGNAME}.files ] && dependcheckfunc
 done
else
 #ask user what pkg to check...
 ACTIONBUTTON="<button>
     <label>$(gettext 'Check dependencies')</label>
     <action type=\"exit\">BUTTON_CHK_DEPS</action>
    </button>"
 echo -n "" > /tmp/petget_depchk_buttons
 cat /root/.packages/user-installed-packages | cut -f 1,10 -d '|' |
 while read ONEPKGSPEC
 do
  [ "$ONEPKGSPEC" = "" ] && continue
  ONEPKG="`echo -n "$ONEPKGSPEC" | cut -f 1 -d '|'`"
  ONEDESCR="`echo -n "$ONEPKGSPEC" | cut -f 2 -d '|'`"
  #120222 npierce: replaced radiobuttons with list and items 
  echo "<item>${ONEPKG} DESCRIPTION: ${ONEDESCR}</item>" >> /tmp/petget_depchk_buttons
 done
 RADBUTTONS="`cat /tmp/petget_depchk_buttons`"
 if [ "$RADBUTTONS" = "" ];then
  ACTIONBUTTON=""
  RADBUTTONS="<item>$(gettext "No packages installed by user, click 'Cancel' button")</item>"
 fi
 export DEPS_DIALOG="<window title=\"$(gettext 'PKGget Package Manager')\" icon-name=\"gtk-about\">
  <vbox>
   <text><label>$(gettext 'Please choose what package you would like to check the dependencies of:')</label></text>
   <frame $(gettext 'User-installed packages')>
    <list selection-mode=\"2\">
     <variable>LIST</variable>
     ${RADBUTTONS}
    </list>
   </frame>
   <hbox>
    ${ACTIONBUTTON}
    <button cancel></button>
   </hbox>
  </vbox>
 </window>
" 
 #RETPARAMS="`gtkdialog --program=DEPS_DIALOG`"
 RETPARAMS="`gtkdialog --geometry=630x327 --program=DEPS_DIALOG`" #120222
 #ex returned:
 #LIST="audacious-1.5.1"
 #EXIT="BUTTON_CHK_DEPS"

 #eval "$RETPARAMS"
 #[ "$EXIT" != "BUTTON_CHK_DEPS" ] && exit
 [ "`echo "$RETPARAMS" | grep 'BUTTON_CHK_DEPS'`" = "" ] && exit
 
 #120222 npierce: Allow '_' in package name.  CAUTION: Names must not contain spaces. 
 APKGNAME="`echo "$RETPARAMS" | grep '^LIST=' | cut -f 1 -d ' ' | cut -f 2 -d '"'`" #'geanyfix
 dependcheckfunc
 
fi

missingpkgsfunc

#present results to user...
MISSINGMSG1="<text use-markup=\"true\"><label>\"<b>$(gettext 'No missing shared libraries')</b>\"</label></text>"
if [ -s /tmp/missinglibs.txt ];then
 MSORT="$(cat /tmp/missinglibs.txt | tr ' ' '\n' | sort -u | tr '\n' ' ')" #140214
 echo -n "$MSORT" > /tmp/missinglibs.txt #140214
 MISSINGMSG1="<text><label>$(gettext 'These libraries are missing:')</label></text><text use-markup=\"true\"><label>\"<b>`cat /tmp/missinglibs.txt`</b>\"</label></text>"
fi
if [ -s /tmp/missinglibs_hidden.txt ];then #100830
 MSORT="$(cat /tmp/missinglibs_hidden.txt | tr ' ' '\n' | sort -u | tr '\n' ' ')" #140214
 echo -n "$MSORT" > /tmp/missinglibs_hidden.txt #140214
 #[ ! -s /tmp/missinglibs.txt ] && MISSINGMSG1=""
 MISSINGMSG1="${MISSINGMSG1} <text><label>$(gettext 'These needed libraries exist but are not in the library search path (it is assumed that a startup script in the package makes these libraries loadable by the application):')</label></text><text use-markup=\"true\"><label>\"<b>`cat /tmp/missinglibs_hidden.txt`</b>\"</label></text>"
fi
MISSINGMSG2="<text use-markup=\"true\"><label>\"<b>$(gettext 'No missing dependent packages')</b>\"</label></text>"
if [ "$MISSINGDEPS_PATTERNS" != "" ];then #[ -s /tmp/petget_missingpkgs ];then
 MISSINGPKGS="`echo "$MISSINGDEPS_PATTERNS" | sed -e 's%|%%g' | tr '\n' ' '`" #v431
 MISSINGMSG2="<text use-markup=\"true\"><label>\"<b>${MISSINGPKGS}</b>\"</label></text>"
fi

DETAILSBUTTON=""
if [ -s /tmp/missinglibs.txt -o -s /tmp/missinglibs_hidden.txt ];then #100830 details button
 DETAILSBUTTON="<button><label>$(gettext 'View details')</label><action>defaulttextviewer /tmp/missinglibs_details.txt & </action></button>"
fi

PKGS="$APKGNAME"
[ $1 ] && PKGS="`echo -n "${1}" | tr '|' ' '`"

#120905 vertical scrollbars, fix window too high... 20220629
export DEPS_DIALOG="<window title=\"$(gettext 'PKGget Package Manager')\" icon-name=\"gtk-about\">
  <vbox>
   <text><label>$(gettext 'EasyOS has searched for any missing shared libraries of these packages:')</label></text>
   <vbox scrollable=\"true\" height=\"100\">
    <text><label>${PKGS}</label></text>
   </vbox>
   <vbox scrollable=\"true\" height=\"100\">
    ${MISSINGMSG1}
   </vbox>
   <text><label>$(gettext 'EasyOS has examined all user-installed packages and found these missing dependencies:')</label></text>
   ${MISSINGMSG2}
   <hbox>
    ${DETAILSBUTTON}
    <button ok></button>
   </hbox>
  </vbox>
 </window>
" 
 RETPARAMS="`gtkdialog --center --program=DEPS_DIALOG`"


###END###
