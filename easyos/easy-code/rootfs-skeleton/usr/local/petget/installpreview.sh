#!/bin/bash
#(c) Copyright Barry Kauler 2009, puppylinux.com
#2009 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html).
#called from pkg_chooser.sh
#package to be previewed prior to installation is TREE1 -- inherited from parent.
#/tmp/petget/current-repo-triad has the repository that installing from.
#100821 bug in Lucid 5.1, /tmp/pup_event_sizefreem had two identical lines.
#101221 yaf-splash fix.
#120101 01micko: jwm >=547 has -reload, no screen flicker.
#120116 rev. 514 introduced icon rendering method which broke -reload at 547. fixed at rev. 574.
#120203 BK: internationalized.
#120504 if no pkgs in category, then when click in window in main dlg, comes here with TREE1="".
#120504 select correct repo when have chosen a pkg from multiple-repo list.
#120604 fix for prepended icons field.
#120811 category field now supports sub-category |category;subcategory|, use as icon in ppm main window.
#120827 if pkg already installed, do not examine dependencies (doesn't work).
#120903 ubuntu, have lots pkgs installed, check_deps.sh takes ages, remove for now, need to rewrite in C.
#120904 "examine dependencies" button did not create any /tmp/petget_missing_dbentries-*, workaround.
#120905 better advice if too many deps. 120907 revert.
#120907 max frames increase 5 to 10. Note, precise puppy gave 72 deps for vlc, which would require 10 frames.
#130511 popup warning if a dep in devx but devx not loaded.
#150326 devx now pet not sfs. popup for entire duration of install.
#150808 was only allowing 80 deps in FRAME_CNT, make limit bigger: 16x30=480
#151116 16 deps is too high, reduce DEP_CNT max to 14. so, 14x30 = 420
#170715 linuxcbon: /root/Startup/freememapplet_tray used to write to /tmp/pup_event_sizefreem, but no more.
#170815 now PKGget. 170823 indexgen.sh no longer used.
#180619 df might not work in a container, so ec-chroot-admin exports ecSIZEFREEM
#181122 q*.sfs renamed to easy*.sfs
#190219 bug fix.
#200405 no deps, add button to download only.
#20210612 replaced all yaf-splash with gtkdialog-splash. note, still ok to kill yaf-splash, see gtkdialog-splash script.
#20220126 PETget now named PKGget
#20230326 remove all reference to file EASYPAK, not used anymore.
#20230914 stupid grep: "grep: warning: stray \ before -" use busybox grep.
#20240227 work in easyvoid. 20240229 20240301
#20240302 easyvoid: app to run non-root. 20240306 full path /usr/bin/xbps-install
#20240307 cannot run non-root in container.
#20240308 WKGFREEK is empty in a container.
#20240503 remove woofV.
#20241020 examine deps for already-installed pkg.
#20241101 default install pkg non-root (based on code in qv installpreview.sh).
#20241104 run build-rox-sendto as a separate process, because slow.
#20241124 maybe allow install app non-root in container.
#20241124 hard-code some exclusions run non-root.
#20241212 force some apps to run non-root.
#20250316 /usr/local/easy-apt/apt exports RUNASROOT=yes
#20250330 install seamonkey as root only.
#20250510 remove ".sh" from TEXTDOMAIN

export TEXTDOMAIN=petget___installpreview
export OUTPUT_CHARSET=UTF-8
#. gettext.sh #120905 120907

[ "$TREE1" = "" ] && exit #120504 nothing to install.

echo -n '' > /tmp/delay-install-sendto-desktops #20241104

. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS
. /etc/rc.d/PUPSTATE #180627 has BOOT_DEV, BOOT_FS, BOOT_DIR, WKG_DEV, WKG_FS, WKG_DIR, QSFS_PATH

case "$DISTRO_TARGETARCH" in #20240227
 amd64) xARCH='x86_64' ;;
 *)     xARCH="$DISTRO_TARGETARCH" ;;
esac
export XBPS_ARCH="$xARCH"
#mkdir -p /tmp/woofV

size_func() {
 local SK
 SK=$1
 #$1 is size in KiB, change to more human-readable
 if [ $SK -gt 1048576 ];then #1024*1024
  SM="$(LANG=C dc -e "2 k ${SK} 1048576 / p")"
  SM="$(LANG=C printf "%.2f" $SM)GB"
 else
  if [ $SK -lt 100 ];then
   SM="${SK}KB"
  else
   SM="$(LANG=C dc -e "1 k ${SK} 1024 / p")"
   SM="$(LANG=C printf "%.1f" $SM)MB"
  fi
 fi
}

#20240228 xbps: replaces code in installpkg.sh
#this func only valid if running in zram...
create_deposed_sfs() {
 local PKG
 PKG="$1" #ex: libwv-1.2.9_5
 #list of installed pkgs: /root/.packages/${PKG}.files
 while read aF <&3
 do
  [ -z "$aF" ] && continue
  #[ "${aF: -1}" == "/" ] && continue #ends with / it is a folder. why get syntax error?
  aREV="$(echo -n "$aF" | rev)"
  [ "${aREV:0:1}" == "/" ] && continue #ends with / it is a folder.
  if [ -e /mnt/wkg/.session${aF} ];then
   aD="${aF%/*}"
   mkdir -p /audit/deposed/${PKG}DEPOSED${aD}
   cp -a /mnt/wkg/.session${aF} /audit/deposed/${PKG}DEPOSED${aD}/
  fi
 done 3</root/.packages/${PKG}.files
 if [ -d /audit/deposed/${PKG}DEPOSED ];then
  mksquashfs /audit/deposed/${PKG}DEPOSED /audit/deposed/${PKG}DEPOSED.sfs
  sync
  rm -rf /audit/deposed/${PKG}DEPOSED
 fi
}

#ex: TREE1=abiword-1.2.4 (first field in database entry).
DB_FILE=Packages-`cat /tmp/petget/current-repo-triad` #ex: Packages-slackware-12.2-official
tPATTERN='^'"$TREE1"'|'
#xtPATTERN='|'"$TREE1"'|'
CR='
'

gtkdialog-splash -close never -bg orange -text "$(gettext 'Please wait, processing package database files...')" &
X1PID=$!

#120827 'examine dependencies' button does not work if pkg already installed...
EXAMDEPSFLAG='yes'
#20241020 yes it does, remove...
#ttPTN='^'"$TREE1"'|.*ALREADY INSTALLED'
#if [ "`grep "$ttPTN" /tmp/petget/filterpkgs.results.post`" != "" ];then #created by postfilterpkgs.sh
# EXAMDEPSFLAG='no'
#fi

#120504 if findnames.sh searched multiple repos, /tmp/petget/current-repo-triad (set in pkg_chooser.sh) might be wrong...
[ -f /tmp/petget/current-repo-triad.previous ] && rm -f /tmp/petget/current-repo-triad.previous
if [ -f /tmp/petget/filterpkgs.results.post ];then
 #file ex line: abiword-1.2.3|[puppy-4-official] Abiword word processor|puppy-4-official|
 #120811 removed...
 #120604 fix for prepended icons field...
 #FLG_APPICONS="`cat /var/local/petget/flg_appicons`" #see configure.sh
 #if [ "$FLG_APPICONS" = "true" ];then
 # ALTSEARCHREPO="$(grep "$xtPATTERN" /tmp/petget/filterpkgs.results.post | grep '|\[' | cut -f 2 -d '[' | cut -f 1 -d ']')"
 #else
  ALTSEARCHREPO="$(grep "$tPATTERN" /tmp/petget/filterpkgs.results.post | grep '|\[' | cut -f 2 -d '[' | cut -f 1 -d ']')"
 #fi
 [ "$ALTSEARCHREPO" ] && DB_FILE="Packages-${ALTSEARCHREPO}"
 #hmmm, other scripts, ex dependencies.sh, will need to have this correct...
 if [ "$ALTSEARCHREPO" ];then
  mv -f /tmp/petget/current-repo-triad /tmp/petget/current-repo-triad.previous #need to restore old one before exit this script.
  echo -n "$ALTSEARCHREPO" > /tmp/petget/current-repo-triad
 fi
fi

rm -f /tmp/petget_missing_dbentries-* 2>/dev/null

DB_ENTRY="`grep "$tPATTERN" /root/.packages/$DB_FILE | head -n 1`"
#line format: pkgname|nameonly|version|pkgrelease|category|size|path|fullfilename|dependencies|description|
#optionally on the end: compileddistro|compiledrelease|repo| (fields 11,12,13)

DB_pkgname="`echo -n "$DB_ENTRY" | cut -f 1 -d '|'`"
DB_nameonly="`echo -n "$DB_ENTRY" | cut -f 2 -d '|'`"
DB_version="`echo -n "$DB_ENTRY" | cut -f 3 -d '|'`"
DB_pkgrelease="`echo -n "$DB_ENTRY" | cut -f 4 -d '|'`"
DB_category="`echo -n "$DB_ENTRY" | cut -f 5 -d '|'`"
DB_size="`echo -n "$DB_ENTRY" | cut -f 6 -d '|'`"
DB_path="`echo -n "$DB_ENTRY" | cut -f 7 -d '|'`"
DB_fullfilename="`echo -n "$DB_ENTRY" | cut -f 8 -d '|'`"
DB_dependencies="`echo -n "$DB_ENTRY" | cut -f 9 -d '|'`"
DB_description="`echo -n "$DB_ENTRY" | cut -f 10 -d '|'`"

[ "$DB_description" = "" ] && DB_description="$(gettext 'no description available')"

#180619 df might not work in a container, so ec-chroot-admin exports ecSIZEFREEM...
#170715 /root/Startup/freememapplet_tray used to write to this file, but no more...
#SIZEFREEM=`cat /tmp/pup_event_sizefreem | head -n 1` #100821 bug in Lucid 5.1, file had two identical lines.
if [ "$ecSIZEFREEM" ];then #190219 bug fix.
 SIZEFREEM="$ecSIZEFREEM"
else
 SIZEFREEM=`df -m | grep ' /$' | tr -s ' ' | cut -f 4 -d ' '`
fi

SIZEFREEK=`expr $SIZEFREEM \* 1024`

if [ $DB_size ];then
 SIZEMK="`echo -n "$DB_size" | rev | cut -c 1`"
 SIZEVAL=`echo -n "$DB_size" | rev | cut -c 2-9 | rev`
 SIZEINFO="<text><label>$(gettext 'After installation, this package will occupy') ${SIZEVAL}${SIZEMK}B. $(gettext 'The amount of free space that you have for installation is') ${SIZEFREEM}MB (${SIZEFREEK}KB).</label></text>"
 SIZEVALz=`expr $SIZEVAL \/ 3`
 SIZEVALz=`expr $SIZEVAL + $SIZEVALz`
 SIZEVALx2=`expr $SIZEVALz + 10000`
 if [ $SIZEVALx2 -ge $SIZEFREEK ];then
  MSGWARN1="${SIZEINFO}<text use-markup=\"true\"><label>\"<b>$(gettext "A general rule-of-thumb is that the free space should be at least the original-package-size plus installed-package-size plus 10MB to allow for sufficient working space during and after installation. It does not look to good, so you had better click the 'Cancel' button")</b> -- $(gettext "note, if you are running Puppy in a mode that has a 'pupsave' file, then the Utility menu has an entry 'Resize personal storage file' that should solve the problem.")\"</label></text>"
 else
  MSGWARN1="${SIZEINFO}<text use-markup=\"true\"><label>\"<b>$(gettext "...free space looks ok, so click 'Install' button:")</b>\"</label></text>"
 fi
else
 MSGWARN1="<text use-markup=\"true\"><label>\"<b>$(gettext 'Unfortunately the provider of the package database has not supplied the size of this package when installed. If you are able to see the size of the compressed package, multiple that by 3 to get the approximate installed size. The free available space, which is') ${SIZEFREEM}MB (${SIZEFREEK}KB), $(gettext 'should be at least 4 times greater.')</b>\"</label></text>"
fi


#find missing dependencies...
if [ "$DB_dependencies" = "" ];then
 #DEPINFO="<text><label>The provider of the package database has not supplied any dependency information for this package. However, after installing it you will have the option to test for any missing shared library files. If uncertain, you might want to look for online documentation for this package that explains any required dependencies.</label></text>"
 DEPINFO="<text><label>$(gettext 'It seems that all dependencies are already installed. Sometimes though, the dependency information in the database is incomplete, however a check for presence of needed shared libraries will be done after installation.')</label></text>"
else

 #find all missing pkgs...
 /usr/local/petget/findmissingpkgs.sh "$DB_dependencies"
 #...returns /tmp/petget/petget_installed_patterns_all, /tmp/petget/petget_pkg_deps_patterns, /tmp/petget_missingpkgs_patterns
 MISSINGDEPS_PATTERNS="`cat /tmp/petget_missingpkgs_patterns`"
 #/tmp/petget_missingpkgs_patterns has a list of missing dependencies, format ex:
 #|kdebase|
 #|kdelibs|
 #|mesa|
 #|qt|

 DEPBUTTON=""
 ONLYMSG=""
 if [ "$MISSINGDEPS_PATTERNS" = "" ];then
  #200405 no deps, add button to download only...
  DEPBUTTON="<button>
   <label>$(gettext 'Download only')</label>
   <action>echo \"${TREE1}\" > /tmp/petget_installpreview_pkgname</action>
   <action type=\"exit\">BUTTON_DL1</action>
   </button>"
  DEPINFO="<text><label>$(gettext 'It seems that all dependencies are already installed. Sometimes though, the dependency information in the database is incomplete, however a check for presence of needed shared libraries will be done after installation.')</label></text>"
 else
  ONLYMSG=" $(gettext 'ONLY')"
  xMISSINGDEPS="`echo "$MISSINGDEPS_PATTERNS" | sed -e 's%|%%g' | tr '\n' ' '`"
  if [ "$EXAMDEPSFLAG" != "no" ];then #120828
   DEPBUTTON="<button>
   <label>$(gettext 'Examine dependencies')</label>
   <action>echo \"${TREE1}\" > /tmp/petget_installpreview_pkgname</action>
   <action type=\"exit\">BUTTON_EXAMINE_DEPS</action>
   </button>"
   DEPINFO="<text><label>$(gettext 'Warning, the following dependent packages are missing:')</label></text>
   <text use-markup=\"true\"><label>\"<b>${xMISSINGDEPS}</b>\"</label></text>
   <text><label>$(gettext "A warning, these dependencies may have other dependencies not necessarily listed here. It is recommended that you click the 'Examine dependencies' button to find all dependencies before installing.")</label></text>
   <text use-markup=\"true\"><label>\"<b>$(gettext "Please click 'Examine dependencies' to install") ${TREE1} $(gettext "as well as its dependencies")</b>\"</label></text>"
  else 
   DEPINFO="<text><label>$(gettext 'Warning, the following dependent packages are missing:')</label></text>
   <text use-markup=\"true\"><label>\"<b>${xMISSINGDEPS}</b>\"</label></text>"
  fi
  if [ $DB_size ];then
   MSGWARN1="<text><label>$(gettext 'After installation, this package will occupy') ${SIZEVAL}${SIZEMK}B, $(gettext 'however the dependencies will need more space so you really need to find what they will need first.')</label></text>"
  else
   MSGWARN1="<text><label>$(gettext 'Also, the package database provider has not supplied the installed size of this package, so you will have to try and estimate whether you have enough free space for it (and the dependencies)')</label></text>"
  fi
 fi 
fi

kill $X1PID

export PREVIEW_DIALOG="<window title=\"$(gettext 'PKGget Package Manager: preinstall')\" icon-name=\"gtk-about\">
<vbox>
 <text><label>$(gettext 'You have chosen to install package') '${TREE1}'. $(gettext 'A short description of this package is:')</label></text>
 <text use-markup=\"true\"><label>\"<b>${DB_description}</b>\"</label></text>
 ${DEPINFO}
 
 ${MSGWARN1}
 
 <frame>
  <hbox>
   <text><label>$(gettext 'If you would like more information about') '${TREE1}', $(gettext 'such as what it is for and the dependencies, this button will display detailed information:')</label></text>
   <vbox>
    <button><label>$(gettext 'More info')</label><action>/usr/local/petget/fetchinfo.sh ${TREE1} & </action></button>
   </vbox>
  </hbox>
 </frame>
 
 <hbox>
  ${DEPBUTTON}
  <button>
   <label>$(gettext 'Install') ${TREE1}${ONLYMSG}</label>
   <action>echo \"${TREE1}\" > /tmp/petget_installpreview_pkgname</action>
   <action type=\"exit\">BUTTON_INSTALL</action>
  </button>
  <button cancel></button>
 </hbox>
</vbox>
</window>
"

RETPARAMS="`gtkdialog --center --program=PREVIEW_DIALOG`"

eval "$RETPARAMS"
outnowflg=1
[ "$EXIT" == "BUTTON_INSTALL" ] && outnowflg=0
[ "$EXIT" == "BUTTON_EXAMINE_DEPS" ] && outnowflg=0
[ "$EXIT" == "BUTTON_DL1" ] && outnowflg=0 #200405
#if [ "$EXIT" != "BUTTON_INSTALL" -a "$EXIT" != "BUTTON_EXAMINE_DEPS" ];then
if [ $outnowflg -eq 1 ];then
 [ -f /tmp/petget/current-repo-triad.previous ] && mv -f /tmp/petget/current-repo-triad.previous /tmp/petget/current-repo-triad
 exit
fi

#DB_ENTRY has the database entry of the main package that we want to install.
#DB_FILE has the name of the database file that has the main entry, ex: Packages-slackware-12.2-slacky

PASSEDPRM="" #200405 moved up.
if [ "$EXIT" == "BUTTON_DL1" ];then #200405
 echo -n '' > /tmp/petget_missing_dbentries-${DB_FILE}
 PASSEDPRM='DOWNLOADONLY'
fi

if [ "$EXIT" = "BUTTON_EXAMINE_DEPS" ];then
 /usr/local/petget/dependencies.sh
 [ $? -ne 0 ] && exec /usr/local/petget/installpreview.sh #reenter.
 #returns with /tmp/petget_missing_dbentries-* has the database entries of missing deps.
 #the '*' on the end is the repo-file name, ex: Packages-slackware-12.2-slacky
 
 #120904
 FNDMISSINGDBENTRYFILE="`ls -1 /tmp/petget_missing_dbentries-* 2>/dev/null`"
 if [ "$FNDMISSINGDBENTRYFILE" = "" ];then
  pupdialog --title "$(gettext 'PPM: examine dependencies')" --background LightYellow --msgbox "$(gettext 'There seem to be no missing dependencies.')

$(gettext 'Note: if the previous window indicated that there are missing dependencies, they were not found. Sometimes, a package database lists a dependency that does not actually exist anymore and is not required.')" 0 0
  exec /usr/local/petget/installpreview.sh #reenter.
 fi
 
 #170815 easy, devx is now an sfs
 #130511 popup warning if a dep in devx but devx not loaded... 150326 fix...
 if ! which gcc; then
  NEEDGCC="$(cat /tmp/petget_missing_dbentries-* | grep -E '\|gcc\||\|gcc_dev_DEV\|' | cut -f 1 -d '|')"
  if [ "$NEEDGCC" ];then
   rm -f /tmp/petget/petget_installed_patterns_system #see pkg_chooser.sh
   #create a separate process for the popup, with delay...
   DEVXNAME="devx-${DISTRO_VERSION}-${DISTRO_FILE_PREFIX}.sfs"
   echo "#!/bin/sh
sleep 3
pupdialog --background pink --colors --ok-label \"$(gettext 'OK')\" --backtitle \"$(gettext 'WARNING: devx not installed')\" --msgbox \"$(gettext 'Package:')  \Zb${TREE1}\ZB
$(gettext "This package has dependencies that are in the 'devx' SFS file, which is Easy's C/C++/Vala/Genie/BaCon mega-package, a complete compiling environment.")

$(gettext 'The devx file is named:') \Zb${DEVXNAME}\ZB

$(gettext "Please cancel installation, and install the devx SFS first. Click the desktop icon \Zbsfsget\ZB to download SFS files.")\" 0 0" > /tmp/petget_devx_popup.sh #'geany
   chmod 755 /tmp/petget_devx_popup.sh
   /tmp/petget_devx_popup.sh &
  fi
 fi
 
 #compose pkgs into checkboxes...
 MAIN_REPO="`echo "$DB_FILE" | cut -f 2-9 -d '-'`"
 MAINPKG_NAME="`echo "$DB_ENTRY" | cut -f 1 -d '|'`"
 MAINPKG_SIZE="`echo "$DB_ENTRY" | cut -f 6 -d '|'`"
 MAINPKG_DESCR="`echo "$DB_ENTRY" | cut -f 10 -d '|'`"
 MAIN_CHK="<checkbox><default>true</default><label>${MAINPKG_NAME} SIZE: ${MAINPKG_SIZE}B DESCRIPTION: ${MAINPKG_DESCR}</label><variable>CHECK_PKG_${MAIN_REPO}_${MAINPKG_NAME}</variable></checkbox>"
 INSTALLEDSIZEK=0
 [ "$MAINPKG_SIZE" != "" ] && INSTALLEDSIZEK=`echo "$MAINPKG_SIZE" | rev | cut -c 2-10 | rev`
 
 #making up the dependencies into tabs, need limit of 8 per tab...
 #also limit to 6 tabs (gedit is way beyond this!)... 150808 now 16 per tab, max 30 tabs.
 echo -n "" > /tmp/petget_moreframes
 echo -n "" > /tmp/petget_tabs
 echo "0" > /tmp/petget_frame_cnt
 DEP_CNT=0
 ONEREPO=""
 for ONEDEPSLIST in `ls -1 /tmp/petget_missing_dbentries-*`
 do
  ONEREPO_PREV="$ONEREPO"
  ONEREPO="`echo "$ONEDEPSLIST" | grep -o 'Packages.*' | sed -e 's%Packages\\-%%'`"
  FRAME_CNT=`cat /tmp/petget_frame_cnt`
  if [ "$ONEREPO_PREV" != "" ];then #next repo, so start a new tab.
   DEP_CNT=0
   FRAME_CNT=`expr $FRAME_CNT + 1`
   echo "$FRAME_CNT" > /tmp/petget_frame_cnt
   #w017 bugfix, prevent double frame closure...
   [ "`cat /tmp/petget_moreframes | tail -n 1 | grep '</frame>$'`" = "" ] && echo "</frame>" >> /tmp/petget_moreframes
  fi
  cat $ONEDEPSLIST |
  while read ONELIST
  do
   DEP_NAME="`echo "$ONELIST" | cut -f 1 -d '|'`"
   DEP_SIZE="`echo "$ONELIST" | cut -f 6 -d '|'`"
   DEP_DESCR="`echo "$ONELIST" | cut -f 10 -d '|'`"
   DEP_CNT=`expr $DEP_CNT + 1`
   case $DEP_CNT in
    1)
     echo -n "<frame $(gettext 'REPOSITORY:') ${ONEREPO}>" >> /tmp/petget_moreframes #190219
     echo -n "$(gettext 'Deps')|" >> /tmp/petget_tabs #150808 shorten "Dependencies"
     echo -n "<checkbox><default>true</default><label>${DEP_NAME} $(gettext 'SIZE:') ${DEP_SIZE}B $(gettext 'DESCRIPTION:') ${DEP_DESCR}</label><variable>CHECK_PKG_${ONEREPO}_${DEP_NAME}</variable></checkbox>" >> /tmp/petget_moreframes
    ;;
    14) #150808 changed from 8. 151116 reduced from 16.
     FRAME_CNT=`cat /tmp/petget_frame_cnt`
     FRAME_CNT=`expr $FRAME_CNT + 1`
     if [ $FRAME_CNT -gt 30 ];then #120907 150808 changed from 10
      #echo -n "<text use-markup=\"true\"><label>\"<b>$(gettext 'SORRY! Too many dependencies, list truncated. Suggest install some deps first.')</b>\"</label></text>" >> /tmp/petget_moreframes #120907
      #echo -n "<text width-chars=\"47\" use-markup=\"true\"><label>\"<b>$(eval_gettext "SORRY! Too many dependencies, list truncated. Suggest untick '\${TREE1}' and install all of the ticked dependencies, then install '\${TREE1}' later along with remaining dependencies.")</b>\"</label></text>" >> /tmp/petget_moreframes #120905
      echo -n "<text use-markup=\"true\"><label>\"<b>$(gettext 'SORRY! Too many dependencies, list truncated. Suggest click Cancel button and install some deps first.')</b>\"</label></text>" >> /tmp/petget_moreframes #120907
     else
      echo -n "<checkbox><default>true</default><label>${DEP_NAME} SIZE: ${DEP_SIZE}B DESCRIPTION: ${DEP_DESCR}</label><variable>CHECK_PKG_${ONEREPO}_${DEP_NAME}</variable></checkbox>" >> /tmp/petget_moreframes
     fi
     echo "</frame>" >> /tmp/petget_moreframes
     DEP_CNT=0
     echo "$FRAME_CNT" > /tmp/petget_frame_cnt
    ;;
    *)
     echo -n "<checkbox><default>true</default><label>${DEP_NAME} SIZE: ${DEP_SIZE}B DESCRIPTION: ${DEP_DESCR}</label><variable>CHECK_PKG_${ONEREPO}_${DEP_NAME}</variable></checkbox>" >> /tmp/petget_moreframes
    ;;
   esac
   [ $FRAME_CNT -gt 30 ] && break #too wide! 120907  150808 changed from 10.
   ADDSIZEK=0
   [ "$DEP_SIZE" != "" ] && ADDSIZEK=`echo "$DEP_SIZE" | rev | cut -c 2-10 | rev`
   INSTALLEDSIZEK=`expr $INSTALLEDSIZEK + $ADDSIZEK`
   echo "$INSTALLEDSIZEK" > /tmp/petget_installedsizek
  done
  INSTALLEDSIZEK=`cat /tmp/petget_installedsizek`
  FRAME_CNT=`cat /tmp/petget_frame_cnt`
  [ $FRAME_CNT -gt 30 ] && break #too wide! 120907 150808 changed from 10.
 done
 TABS="`cat /tmp/petget_tabs`"
 MOREFRAMES="`cat /tmp/petget_moreframes`"
 #make sure last frame has closed...
 [ "`echo "$MOREFRAMES" | tail -n 1 | grep '</frame>$'`" = "" ] && MOREFRAMES="${MOREFRAMES}</frame>"
 
 INSTALLEDSIZEM=`expr $INSTALLEDSIZEK \/ 1024`
 MSGWARN2="$(gettext "If that looks like enough free space, go ahead and click the 'Install' button...")"
 testSIZEK=`expr $INSTALLEDSIZEK \/ 3`
 testSIZEK=`expr $INSTALLEDSIZEK + $testSIZEK`
 testSIZEK=`expr $testSIZEK + 8000`
 [ $testSIZEK -gt $SIZEFREEK ] && MSGWARN2="$(gettext "Not too good! recommend that you make more space before installing -- see 'Resize personal storage file' in the 'Utility' menu.")"
 
 export DEPS_DIALOG="<window title=\"$(gettext 'PKGget Package Manager: dependencies')\" icon-name=\"gtk-about\">
<vbox>
 
 <frame $(gettext "REPOSITORY:") ${MAIN_REPO}>
  ${MAIN_CHK}
 </frame>

 <notebook labels=\"${TABS}\">
 ${MOREFRAMES}
 </notebook>
 
 <hbox>
 <text><label>$(gettext "Automatic dependency checking may find deps that don't really need to be installed, or are already installed under a different name. If uncertain, just accept them all, but if one does not seem to be needed, then un-tick it.")</label></text>
 
 <text><label>$(gettext 'The same dep is not usually listed twice if it exists in two repositories. However, if the same package is listed twice, choose the one that seems the most appropriate.')</label></text>
 </hbox>
 
 <hbox>
  <vbox>
   <text><label>$(gettext 'Click to see the hierarchy of the dependencies:')</label></text>
   <hbox>
    <button>
     <label>$(gettext 'View hierarchy')</label>
     <action>/usr/local/bin/defaulttextviewer /tmp/petget_deps_visualtreelog & </action>
    </button>
   </hbox>
  </vbox>
  <text><label>\"   \"</label></text>
  <text use-markup=\"true\"><label>\"<b>$(gettext 'If all of the above packages are selected, the total installed size will be') ${INSTALLEDSIZEK}KB (${INSTALLEDSIZEM}MB). $(gettext 'The free space available for installation is') ${SIZEFREEK}KB (${SIZEFREEM}MB). ${MSGWARN2}</b>\"</label></text>
 </hbox>
 
 <hbox>
  <button>
   <label>$(gettext 'Download-only selected packages')</label>
   <action type=\"exit\">BUTTON_PKGS_DOWNLOADONLY</action>
  </button>
  <button>
   <label>$(gettext 'Download-and-install selected packages')</label>
   <action type=\"exit\">BUTTON_PKGS_INSTALL</action>
  </button>
  <button cancel></button>
 </hbox>
</vbox>
</window>
"

 RETPARAMS="`gtkdialog --center --program=DEPS_DIALOG`"

 #example if 'Install' button clicked:
 #CHECK_PKG_slackware-12.2-official_libtermcap-1.2.3="true"
 #CHECK_PKG_slackware-12.2-official_pygtk-2.12.1="true"
 #CHECK_PKG_slackware-12.2-slacky_beagle-0.3.9="true"
 #CHECK_PKG_slackware-12.2-slacky_libgdiplus-2.0="true"
 #CHECK_PKG_slackware-12.2-slacky_libgdiplus-2.2="true"
 #CHECK_PKG_slackware-12.2-slacky_mono-2.2="true"
 #CHECK_PKG_slackware-12.2-slacky_monodoc-2.0="true"
 #EXIT="BUTTON_PKGS_INSTALL"

 if [ "`echo "$RETPARAMS" | grep '^EXIT' | grep -E 'BUTTON_PKGS_INSTALL|BUTTON_PKGS_DOWNLOADONLY'`" != "" ];then
  #remove any unticked pkgs from the list...
  for ONECHK in `echo "$RETPARAMS" | grep '^CHECK_PKG_' | grep '"false"' | tr '\n' ' '`
  do
   ONEREPO="`echo -n "$ONECHK" | cut -f 1 -d '=' | cut -f 3 -d '_'`" #ex: slackware-12.2-slacky
   ONEPKG="`echo -n "$ONECHK" | cut -f 1 -d '=' | cut -f 4-9 -d '_'`"  #ex: libtermcap-1.2.3
   opPATTERN='^'"$ONEPKG"'|'
   grep -v "$opPATTERN" /tmp/petget_missing_dbentries-Packages-${ONEREPO} > /tmp/petget_tmp
   mv -f /tmp/petget_tmp /tmp/petget_missing_dbentries-Packages-${ONEREPO}
  done
 else
  [ -f /tmp/petget/current-repo-triad.previous ] && mv -f /tmp/petget/current-repo-triad.previous /tmp/petget/current-repo-triad #120504
  exit
 fi
fi

#come here, want to install pkg(s)...

#150326 want a popup that stays up until all install operations are finished...
popup "name=petgetinstall background='#FFC040' level=top placement=top-middle|<big>$(gettext 'Package Manager: please wait, installing')</big>"

#DB_ENTRY has the database entry of the main package that we want to install.
#DB_FILE has the name of the database file that has the main entry, ex: Packages-slackware-12.2-slacky
#TREE1 is name of main pkg, ex: abiword-1.2.3

#check to see if main pkg entry already in install-lists...
touch /tmp/petget_missing_dbentries-${DB_FILE} #create if doesn't exist.
mPATTERN='^'"$TREE1"'|'
if [ "`grep "$mPATTERN" /tmp/petget_missing_dbentries-${DB_FILE}`" = "" ];then
 echo "$DB_ENTRY" >> /tmp/petget_missing_dbentries-${DB_FILE}
fi

#now do the actual install...
[ "`echo "$RETPARAMS" | grep '^EXIT' | grep 'BUTTON_PKGS_DOWNLOADONLY'`" != "" ] && PASSEDPRM="DOWNLOADONLY"
/usr/local/petget/downloadpkgs.sh $PASSEDPRM
if [ $? -ne 0 ];then
 [ -f /tmp/petget/current-repo-triad.previous ] && mv -f /tmp/petget/current-repo-triad.previous /tmp/petget/current-repo-triad #120504
 #popadd "name=petgetinstall terminate=now|" #150326
 echo "terminate=now|" > /tmp/popup_petgetinstall
 exit 1
fi
if [ "$PASSEDPRM" = "DOWNLOADONLY" ];then
 #popadd "name=petgetinstall terminate=now|" #150326
 echo "terminate=now|" > /tmp/popup_petgetinstall
 exit
fi

#w482 adjust msg as appropriate, restart jwm and update menu if required...
#popadd "name=petgetinstall background='#FF8000' writemode=replace|<big>$(gettext 'Package Manager: please wait, post-install')</big>"
echo "background='#FF8000' writemode=replace|<big>$(gettext 'Package Manager: please wait, post-install')</big>" >> /tmp/popup_petgetinstall
INSTALLEDCAT="menu" #any string.
[ "`cat /tmp/petget-installed-pkgs-log | grep -o 'CATEGORY' | grep -v 'none'`" = "" ] && INSTALLEDCAT="none"
RESTARTMSG="$(gettext 'Please wait, updating help page and menu...')"
if [ "`pidof jwm`" != "" ];then #120101
 JWMVER=`jwm -v|head -n1|cut -d ' ' -f2|cut -d - -f2`
 if vercmp $JWMVER lt 574;then #120116 introduced rev 547, but 574 fixes -reload.
  RESTARTMSG="$(gettext 'Please wait, updating help page and menu (the screen will flicker!)...')"
 fi
fi
[ "$INSTALLEDCAT" = "none" ] && RESTARTMSG="$(gettext 'Please wait, updating help page...')"
#/usr/X11R7/bin/yaf-splash -font "8x16" -outline 0 -margin 4 -bg orange -text "${RESTARTMSG}" &
gtkdialog-splash -bg orange -text "${RESTARTMSG}" &
X3PID=$!

#w091019 update image cache...
iUPDATE='no'
for iONE in `cat /tmp/petget_missing_dbentries-* | cut -f 1 -d '|' | tr '\n' ' '`
do
 if [ -f /root/.packages/${iONE}.files ];then
  [ "`grep 'usr/share/icons/hicolor' /root/.packages/${iONE}.files`" != "" ] && iUPDATE='yes'
 fi
done
[ "$iUPDATE" = "yes" ] && gtk-update-icon-cache -f /usr/share/icons/hicolor/

#170823 not needed...
##master help index has to be updated...
#/usr/sbin/indexgen.sh #${WKGDIR}/${APKGNAME}

#Reconstruct configuration files for JWM, Fvwm95, IceWM...
if [ "$INSTALLEDCAT" != "none" ];then
 /usr/sbin/fixmenus
 if [ "`pidof jwm`" != "" ];then #120101
  if vercmp $JWMVER lt 574;then #120116 547 to 574.
   jwm -restart #w482
  else
   jwm -reload
  fi
 fi
fi
kill $X3PID

#120905 restore...
#120903 ubuntu, have lots pkgs installed, this takes ages. remove for now, need to rewrite in C...
#check any missing shared libraries...
PKGS="`cat /tmp/petget_missing_dbentries-* | cut -f 1 -d '|' | tr '\n' '|'`"
/usr/local/petget/check_deps.sh $PKGS

[ -f /tmp/petget/current-repo-triad.previous ] && mv -f /tmp/petget/current-repo-triad.previous /tmp/petget/current-repo-triad #120504

#popadd "name=petgetinstall terminate=now|" #150326
echo "terminate=now|" > /tmp/popup_petgetinstall

#20241104 file writento in installpkg.sh ...
if [ -s /tmp/delay-install-sendto-desktops ];then
 DESKTOPFILES="$(cat /tmp/delay-install-sendto-desktops | tr '\n' ' ')"
 echo "#!/bin/ash
for ONEDESKTOP in ${DESKTOPFILES}
do
 [ -z \"\$ONEDESKTOP\" ] && continue
 build-rox-sendto \${ONEDESKTOP##*/}
done" > /tmp/sep-install-build-rox-sendto
 chmod 755 /tmp/sep-install-build-rox-sendto
 /tmp/sep-install-build-rox-sendto &
 rm -f /tmp/delay-install-sendto-desktops
fi

#20241101 install non-root
if [ -f /root/.packages/${TREE1}.files ];then #ex TREE1=abiword-1.2-amd64 (1st field in db)
 #code from qv installpreview.sh...
 NRflg=0; RETASK=''
 #20240307 cannot run non-root in container...
 ls -1 /INSIDE_* >/dev/null 2>&1
 NOflg=$?
 #20241124 this needs to be qualified...
 if [ $NOflg -eq 0 ];then
  CONTn="$(ls -1 /INSIDE_* | head -n 1 | cut -f 2- -d '_')" #ex: daedalus
  if [ -f /.control/${CONTn}.configuration ];then
   grep -q -F "EC_CAP_file='false'" /.control/${CONTn}.configuration
   if [ $? -eq 0 ];then
    #this means container is allowed to execute chmod and chown
    NOflg=1
   fi
  fi
 fi
 if [ $NOflg -ne 0 ];then
  grep -q 'usr/share/applications' /root/.packages/${TREE1}.files
  if [ $? -eq 0 ];then
   for aDT in $(grep '/usr/share/applications/.*desktop$' /root/.packages/${TREE1}.files)
   do
    [ -z "$aDT" ] && continue
    grep -q '^NoDisplay=true' ${aDT}
    if [ $? -ne 0 ];then
     #20240414 audacity.desktop has "Exec=env UBUNTU_MENUPROXY=0 audacity"
     grep -q '^Exec=env ' ${aDT}
     if [ $? -eq 0 ];then
      sed -i -e 's|^Exec=env [^ ]* |Exec=|' ${aDT}
     fi
     #20240405 vlc.desktop has "Exec=/usr/bin/vlc --started-from-file %U"
     #somewhere else knocks off that %U, but also need to get rid of /usr/bin/...
     sed -i -e 's|^Exec=/usr/bin/|Exec=|' ${aDT}
     EXEC="$(grep '^Exec=' ${aDT} | cut -f 2 -d '=' | cut -f 1 -d ' ' | head -n 1)"
     grep -q '/' <<<${EXEC}
     if [ $? -ne 0 ];then
      if [ -x /usr/bin/${EXEC} ];then
       #20241124 /usr/local/clients/choose-clients has some hard-coded exclusions.
       #copy those to here...
       #well, these are already builtin, but just in case not...
       ASKflg=1; RETASK='root'
       if [ "${RUNASROOT}" == "yes" ];then ASKflg=0; fi #20250316 called from /usr/local/easy-apt/apt
       #20250330 add seamonkey must run as root...
       case "${EXEC}" in
        awf-gtk2|awf-gtk3|bluepup|bluetooth-sendto|bootmanager|butniso2cd|ccrypt_gui) ASKflg=0 ;;
        cdburner-wizard|chooselocale|cups_shell|date-time-wizard) ASKflg=0 ;;
        default*|droidcam|easy*|eventmanager|ffconvert|ff*) ASKflg=0 ;;
        filemnt|firewall_ng|flapi|Floppy_Formatter|flsynclient|fluid|ghostview|glade) ASKflg=0 ;;
        gparted_shell|gtk3*|hostname-set|icon_switcher|input-wizard|ipinfo|jwmthememaker) ASKflg=0 ;;
        limine-installer|loginmanager|momanager|mount-img|moveicons|mscw|mtpaintsnapshot.sh) ASKflg=0 ;;
        notification-daemon|partview|pburn|Pdisk|petget|pmount|pprocess|Pudd|pupx) ASKflg=0 ;;
        pupzip|pwsget|qsync|quicksetup|qwallpaper|rox|rxvt|sakura|screeny|seamonkey|set_*|set-*) ASKflg=0 ;;
        tas|timezone-set|touchpad-toggle|urxvt*|usbviewshell|vv-dl-latest|wcpufreq|xarchive) ASKflg=0 ;;
        xdelt_gui|xfdiff-cut|xfontsel|xorgwizard|xvkbd-wrapper|youtubedl-gui|zarfywrapper) ASKflg=0 ;;
        gfnrename|gfontsel|gpptp|gtk*|pgprs|precord|prename|pupcamera|xdelta_gui) ASKflg=0 ;;
       esac
       #20241212 force some to run non-root...
       case "${EXEC}" in
        anydesk) ASKflg=0; RETASK='nonroot'; ;;
       esac
       if [ $ASKflg -eq 1 ];then
        #20241101 don't just default to run non-root, ask...
        export IPV_ASK_DLG="<window title=\"PKGget: $(gettext 'package installed')\" image-name=\"/usr/local/lib/X11/pixmaps/pkg24.png\">
     <vbox>
      <text use-markup=\"true\"><label>\"$(gettext 'This package has been installed:') <b>${TREE1}</b>
$(gettext 'The executable is:') /usr/bin/${EXEC}

$(gettext 'Do you want to run the executable as the root user, or non-root?')
$(gettext 'Choose root if you want unfettered system-wide write access. Choose non-root to restrict the executable to only be able to write in the application home folder or inside /files folder.')
$(gettext 'Choose non-root if you are concerned about running the executable with maximum security.')
$(gettext 'If in doubt, choose non-root; the next window will explain how you can flip the executable between root and non-root later, if you decide to change.')
\"</label></text>
      <hbox>
       <button><label>root</label><action>EXIT:root</action></button>
       <button><label>$(gettext 'non-root')</label><action>EXIT:nonroot</action></button>
      </hbox>
     </vbox></window>"
        RETASK="$(gtkdialog --center --program=IPV_ASK_DLG)"
       fi
       #20241101 also test for .bin (installed flatpak or appimage will have .bin not .bin0)
       if [ -x /usr/bin/${EXEC}.bin0 -o -x /usr/bin/${EXEC}.bin ];then
        #this means previous version was already setup to run non-root
        #the update has installed a new /usr/bin/${EXEC}, so revert to run
        #as root, then back to non-root...
        rm -f /usr/bin/${EXEC}.bin0 2>/dev/null
        rm -f /usr/bin/${EXEC}.bin 2>/dev/null
        #hide, so setup-client can bring back in future...
        if [ -d /home/.${EXEC} ];then #precaution.
         rm -rf /home/.${EXEC}
        fi
        mv -f /home/${EXEC} /home/.${EXEC} 2>/dev/null
        sed -i -e "s%^${EXEC}=.*%${EXEC}=false%" /root/.clients-status
       fi
       grep -q -F 'nonroot' <<<"${RETASK}"
       if [ $? -eq 0 ];then
        /usr/local/clients/setup-client "${EXEC}=true"
        NRflg=1
       fi
       break
      fi
     fi
    fi
   done
  fi
 fi
 
 #now put up message...
 if [ $NRflg -eq 1 ];then
  PPM_VOID_MSG="$(gettext 'There are a couple of different ways to flip an application to run as the root user:')
    
<b>1: .bin0</b>
$(gettext 'Take the example of the word processor Abiword. You will find /usr/bin/abiword, but also there is /usr/bin/abiword.bin0. All that you have to do is execute the latter and Abiword will run as the root user. You can edit /usr/share/applications/abiword.desktop and a desktop icon if one exists, to run abiword.bin0. Or just run abiword.bin0 in a terminal.')

<b>2: LoginManager</b>
$(gettext 'There is a formal tool for flipping an app to run as non-root or root. The LoginManager is found in the System category of the menu. Alternatively, click on the <b>setup</b> desktop icon, choose the <b>EasyOS</b> tab and click the <b>Login Manager</b> button.')
    "
  export DLG_PPM_VOID="<window resizable=\"false\" title=\"PKGget: Help administrator\" image-name=\"/usr/local/lib/X11/pixmaps/pkg24.png\" window_position=\"1\">
     <vbox>
      <text use-markup=\"true\">
       <label>\"${PPM_VOID_MSG}\"</label><variable>VAR_PPM_VOID</variable>
      </text>
      <hbox>
       <button><label>Close</label><action type=\"closewindow\">VAR_PPM_VOID</action></button>
      </hbox></vbox></window>"

    
  export IPV_DLG="<window title=\"PKGget: $(gettext 'package installed')\" image-name=\"/usr/local/lib/X11/pixmaps/pkg24.png\">
     <vbox>
      <text use-markup=\"true\"><label>\"$(gettext 'This package has been installed:') <b>${TREE1}</b>
$(gettext 'This application has been installed:') <b>${EXEC}</b>
$(gettext 'The application will run non-root, as this user:') ${EXEC}
$(gettext 'With home directory:') /home/${EXEC}
$(gettext 'The app also has private write access to:') /files/apps/${EXEC}\"</label></text>
     
     <frame>
      <text use-markup=\"true\"><label>\"<b>$(gettext 'Administrator')</b>\"</label></text>
      <hbox>
       <text><label>$(gettext 'You may want some applications to have system-wide write permission, such as a file manager. It is very easy to flip to run as administrator (root user). Click button for explanation:')</label></text>
       <vbox>
        <button>
         <input file>/usr/local/lib/X11/mini-icons/mini-question.xpm</input>
         <action type=\"launch\">DLG_PPM_VOID</action>
        </button>
       </vbox>
      </hbox>
     </frame>
     
     <frame>
      <text use-markup=\"true\"><label>\"<b>$(gettext 'Desktop icon')</b>\"</label></text>
      <text use-markup=\"true\"><label>\"$(gettext 'An entry has been created in the menu; however, you can also create a desktop icon.')
$(gettext 'All that you need to do is drag the icon from ROX-Filer, onto the desktop, that is it.')
$(gettext 'You can do it any time in the future, and also can delete the desktop icon by right-click and choose Remove.')\"</label></text>
      <hbox>
       <text><label>$(gettext 'Click for ROX-Filer window:')</label></text>
       <button>
        <label>ROX-Filer</label>
        <action>rox -d /home/${EXEC} & </action>
       </button>
      </hbox>
     </frame>
     <hbox>
      <button ok></button>
     </hbox>
     </vbox></window>"
  gtkdialog --center --program=IPV_DLG
 else
  grep -q -F 'root' <<<"${RETASK}"
  if [ $? -eq 0 ];then
   vM1="$(gettext 'You have installed this package, to run as root:') ${TREE1} ${CR}$(gettext '(Choose Login and Security Manager in the Setup menu to flip to non-root)')"
   popup "terminate=5 timecount=dn name=vinstallmsg background=#a0ffa0|<big>${vM1}</big>"
  fi
 fi
fi
###END###
