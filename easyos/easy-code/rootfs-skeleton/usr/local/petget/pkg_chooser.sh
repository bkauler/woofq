#!/bin/bash
#(c) Copyright Barry Kauler 2009, puppylinux.com
#2009 Lesser GPL licence v2 (/usr/share/doc/legal/lgpl-2.1.txt).
#The Puppy Package Manager main GUI window.
#v424 reintroduce the 'ALL' category, for ppup build only.
#v425 enable ENTER key for find box.
#100116 add quirky repo at ibiblio. 100126: bugfixes.
#100513 reintroduce the 'ALL' category for quirky (t2).
#100903 handle puppy-wary5 repo.
#100911 handle puppy-lucid repo.
#101126 prevent 'puppy-quirky' radiobutton first for quirky 1.4 (based on wary5 pkgs).
#101129 checkboxes for show EXE DEV DOC NLS.
#101205 bugfix for: make sure first radiobutton matches list of pkgs.
#110118 alternate User Interfaces. see also configure.sh.
#110505 support sudo for non-root user.
#110706 fix for deps checking.
#120203 BK: internationalized.
#120327 sometimes the selected repo radiobutton did not match listed packages at startup.
#120504 /tmp/petget_filterversion renamed to /tmp/petget/current-repo-triad
#120504 some files moved into /tmp/petget
#120504b improved separation of dev,doc,nls,exe, enhanced ubuntu,debian pkg support.
#120515 common code from pkg_chooser.sh, findnames.sh, filterpkgs.sh, extracted to /usr/local/petget/postfilterpkgs.sh.
#120527 change gtkdialog3 to gtkdialog4. icon patterns for postfilterpkgs.sh.
#120529 ui may show app thumbnail icons.
#120603 /root/.packages/user-installed-packages missing at first boot.
#120515 gentoo build.
#120811 category field now supports sub-category |category;subcategory|, use as icon in ppm main window.
#120822 in precise puppy have a pet 'cups' instead of the ubuntu debs. the latter are various pkgs, including 'libcups2'. we don't want libcups2 showing up as a missing dependency, so have to screen these alternative names out. see also findmissingpkgs.sh.
#120831 simplify repos radiobuttons. fixes a bug, when make selection in setup wasn't same in main window.
#120903 bugfix for 120831. 120905 fix window too wide.
#121125 offer to download a Service Pack, if available.
#130330 GUI filter. see also ui_Classic, ui_Ziggy, filterpkgs.sh.
#130331 more GUI filter options. See also filterpkgs.sh.
#130511 need to include devx-only-installed-packages, if loaded.
#131209 Packages-puppy- files renamed to Packages-pet-
#131211 modified for quirky6.
#131214 change default from "gui apps only" to "any type".
#150419 added devuan support. refer: dimkr: https://github.com/puppylinux-woof-CE/woof-CE/pull/528/files
#151105 change MAIN_DIALOG to PPM_MAIN_GUI. change gtkdialog4 to gtkdialog.
#170815 no longer using service packs.
#180428 reintroduce ALLCATEGORY for 'oe' (OpenEmbedded) build.
#190813 aborted update of db's resulted in *pre files getting left behind.
#20220903 optional dpkg|apt sync.  20220905
#20221023 may be running as zeus super-user. 20221031 think still need to bump to root.
#20230309 have removed /usr/local/debget. make repo radiobuttons shorter, remove "debian-"
#20230626 new sudo-sh
#20230711 when called from /usr/bin/*.install script, has passed param "gen-tmp-files-only"
#20230914 void: update pkg db every time run pkgget.
#20230914 stupid grep: "grep: warning: stray \ before -" use busybox grep. no, grep -P works. no, in case only have busybox grep, it doesn't understand -P
#20240228 when easyvoid has pkgget frontend for xbps, no need to update pkg db at startup. 20240229 revert.
#20241018 remove "devuan-" prefix on radiobuttons.
#20250510 remove ".sh" from TEXTDOMAIN

#/usr/local/petget/service_pack.sh & #121125 offer download Service Pack.

export TEXTDOMAIN=petget___pkg_chooser
export OUTPUT_CHARSET=UTF-8

#20230626
if [ "$(whoami)" != "root" ];then
 if [ -x /usr/bin/sudo-sh ];then
  exec sudo-sh ${PPID} ${0} ${@}
 else
  exec sudo -A ${0} ${@}
 fi
fi

PARAM1="$1" #20230711
#export LANG=C
mkdir -p /tmp/petget #120504
mkdir -p /var/local/petget

. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS

#this must be after running apt-setup
. /root/.packages/PKGS_MANAGEMENT #has PKG_REPOS_ENABLED, PKG_NAME_ALIASES

case "$DISTRO_TARGETARCH" in #20240228
 amd64) xARCH='x86_64' ;;
 *)     xARCH="$DISTRO_TARGETARCH" ;;
esac
#actually, do this in installpreview.sh, but probably good do it up-front...
export XBPS_ARCH="$xARCH"

#190813 aborted update of db's resulted in *pre files getting left behind...
for aPRE in `find /root/.packages -mindepth 1 -maxdepth 1 -type f -name 'Packages-*pre'`
do
 rm -f $aPRE
done

if [ "$DISTRO_BINARY_COMPAT" == "void" ];then #20230914 20240229
 #easyvoid; must update db...
 if [ ! -e /tmp/petget/void-db-updated-flg ];then
  ping -4 -c 1 -w 5 -q google.com
  if [ $? -ne 0 ];then
   E1="$(gettext 'PKGget requires Internet access')"
   popup "background=#ffa0a0 terminate=ok process=wait level=top|<big>${E1}</big>"
   exit
  fi
  W1="$(gettext 'As Void Linux is a rolling release, need to update the package database every time run PKGget. Please wait...')"
  popup "background=#ffd8e6 level=top|<big>${W1}</big>"
  /usr/local/petget/0setup q
  sync
  killall popup
  touch /tmp/petget/void-db-updated-flg
 fi
fi

#120811 removed...
##120527 need these patterns in postfilterpkgs.sh...
##the awk stuff sorts the line by length of line, longer lines first. if only one char on line, append ^ ...
##(fallback, any pkgs starting with 'k' are kde apps, or 'g' are gnome apps). also append '^' for 2-char lines...
#ICONPTNS="$(ls -1 /usr/share/icons/hicolor/16x16/apps | grep 'xpm$' | sed -e 's%\.xpm$%%' | awk '{print length, $0}' | sort -rn | awk '{$1=""; print $0 }' | sed -e 's%^ %%' | sed -r -e 's%(^[a-z][a-z]$)%^\1%' | sed -r -e 's%(^[a-z]$)%^\1%')"
#echo "$ICONPTNS" > /tmp/petget/postfilter_icon_ptns
##echo -e 'perl\npython\ntcl\nmail\nkde\nqt\nQt\ndbus\ndb\n' >> /tmp/petget/postfilter_icon_ptns

#120529 app icons
touch /root/.packages/user-installed-packages #120603 missing at first boot.
#120811 removed...
#if [ -f /var/local/petget/flg_appicons ];then
# FLG_APPICONS="`cat /var/local/petget/flg_appicons`"
#else
# #test if pet installed with set of 16x16 app icons...
# [ "`grep 'icons_puppy_app' /root/.packages/woof-installed-packages /root/.packages/user-installed-packages`" != "" ] && FLG_APPICONS='true'
#fi
#[ "$FLG_APPICONS" = "" ] && FLG_APPICONS='false'
#echo -n "$FLG_APPICONS" > /var/local/petget/flg_appicons

#101129 choose to display EXE, DEV, DOC, NLS pkgs... note, this code-block is also in findnames.sh and filterpkgs.sh...
DEF_CHK_EXE='true'
DEF_CHK_DEV='false'
DEF_CHK_DOC='false'
DEF_CHK_NLS='false'
[ -e /var/local/petget/postfilter_EXE ] && DEF_CHK_EXE="`cat /var/local/petget/postfilter_EXE`"
[ -e /var/local/petget/postfilter_DEV ] && DEF_CHK_DEV="`cat /var/local/petget/postfilter_DEV`"
[ -e /var/local/petget/postfilter_DOC ] && DEF_CHK_DOC="`cat /var/local/petget/postfilter_DOC`"
[ -e /var/local/petget/postfilter_NLS ] && DEF_CHK_NLS="`cat /var/local/petget/postfilter_NLS`"
#120515 the script /usr/local/petget/postfilterpkgs.sh handles checkbox actions, is called from ui_Ziggy and ui_Classic.

#finds all user-installed pkgs and formats ready for display...
/usr/local/petget/finduserinstalledpkgs.sh #writes to /tmp/installedpkgs.results

#130511 need to include devx-only-installed-packages, if loaded...
#note, this code block also in check_deps.sh.
if which gcc >/dev/null ;then
 cp -f /root/.packages/woof-installed-packages /tmp/petget/ppm-layers-installed-packages
 cat /root/.packages/devx-only-installed-packages >> /tmp/petget/ppm-layers-installed-packages
 sort -u /tmp/petget/ppm-layers-installed-packages > /root/.packages/layers-installed-packages
else
 cp -f /root/.packages/woof-installed-packages /root/.packages/layers-installed-packages
fi

#100711 moved from findmissingpkgs.sh... 130511 rename woof-installed-packages to layers-installed-packages...
if [ ! -f /tmp/petget/petget_installed_patterns_system ];then
 INSTALLED_PATTERNS_SYS="`cat /root/.packages/layers-installed-packages | cut -f 2 -d '|' | sed -e 's%^%|%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
 echo "$INSTALLED_PATTERNS_SYS" > /tmp/petget/petget_installed_patterns_system
 #PKGS_SPECS_TABLE also has system-installed names, some of them are generic combinations of pkgs...
 INSTALLED_PATTERNS_GEN="`echo "$PKGS_SPECS_TABLE" | grep '^yes' | cut -f 2 -d '|' |  sed -e 's%^%|%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
 echo "$INSTALLED_PATTERNS_GEN" >> /tmp/petget/petget_installed_patterns_system
 
 #120822 in precise puppy have a pet 'cups' instead of the ubuntu debs. the latter are various pkgs, including 'libcups2'.
 #we don't want libcups2 showing up as a missing dependency, so have to screen these alternative names out...
 case $DISTRO_BINARY_COMPAT in
  ubuntu|debian|raspbian|devuan) #150419
   #for 'cups' pet, we want to create a pattern '/cups|' so can locate all debs with that DB_path entry '.../cups'
   #INSTALLED_PTNS_SYS_PET="`grep '\.pet|' /root/.packages/layers-installed-packages | cut -f 2 -d '|' | sed -e 's%^%/%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
   INSTALLED_PTNS_PET="$(busybox grep '\.pet|' /root/.packages/layers-installed-packages | cut -f 2 -d '|' | sed -e 's%^%/%' -e 's%$%|%' -e 's%\-%\\-%g')" #20230914
   if [ "$INSTALLED_PTNS_PET" != "/|" ];then
    echo "$INSTALLED_PTNS_PET" > /tmp/petget/installed_ptns_pet
    INSTALLED_ALT_NAMES="$(grep --no-filename -f /tmp/petget/installed_ptns_pet /root/.packages/Packages-${DISTRO_BINARY_COMPAT}-${DISTRO_COMPAT_VERSION}-* | cut -f 2 -d '|')"
    if [ "$INSTALLED_ALT_NAMES" ];then
     INSTALLED_ALT_PTNS="$(echo "$INSTALLED_ALT_NAMES" | sed -e 's%^%|%' -e 's%$%|%' -e 's%\-%\\-%g')"
     echo "$INSTALLED_ALT_PTNS" >> /tmp/petget/petget_installed_patterns_system
    fi
   fi
  ;;
 esac
 sort -u /tmp/petget/petget_installed_patterns_system > /tmp/petget/petget_installed_patterns_systemx
 mv -f /tmp/petget/petget_installed_patterns_systemx /tmp/petget/petget_installed_patterns_system
fi
#100711 this code repeated in findmissingpkgs.sh...
cp -f /tmp/petget/petget_installed_patterns_system /tmp/petget/petget_installed_patterns_all
if [ -s /root/.packages/user-installed-packages ];then
 INSTALLED_PATTERNS_USER="`cat /root/.packages/user-installed-packages | cut -f 2 -d '|' | sed -e 's%^%|%' -e 's%$%|%' -e 's%\\-%\\\\-%g'`"
 echo "$INSTALLED_PATTERNS_USER" >> /tmp/petget/petget_installed_patterns_all
 #120822 find alt names in compat-distro pkgs, for user-installed pets...
 case $DISTRO_BINARY_COMPAT in
  ubuntu|debian|raspbian|devuan) #150419
   #120904 bugfix, was very slow...
   MODIF1=`stat --format=%Y /root/.packages/user-installed-packages` #seconds since epoch.
   MODIF2=0
   [ -f /var/local/petget/installed_alt_ptns_pet_user ] && MODIF2=`stat --format=%Y /var/local/petget/installed_alt_ptns_pet_user`
   if [ $MODIF1 -gt $MODIF2 ];then
    INSTALLED_PTNS_PET="$(busybox grep '\.pet|' /root/.packages/user-installed-packages | cut -f 2 -d '|')" #20230914
    if [ "$INSTALLED_PTNS_PET" != "" ];then
     xINSTALLED_PTNS_PET="$(echo "$INSTALLED_PTNS_PET" | sed -e 's%^%/%' -e 's%$%|%' -e 's%\-%\\-%g')"
     echo "$xINSTALLED_PTNS_PET" > /tmp/petget/fmp_xipp1
     INSTALLED_ALT_NAMES="$(grep --no-filename -f /tmp/petget/fmp_xipp1 /root/.packages/Packages-${DISTRO_BINARY_COMPAT}-${DISTRO_COMPAT_VERSION}-* | cut -f 2 -d '|')"
     if [ "$INSTALLED_ALT_NAMES" ];then
      INSTALLED_ALT_PTNS="$(echo "$INSTALLED_ALT_NAMES" | sed -e 's%^%|%' -e 's%$%|%' -e 's%\-%\\-%g')"
      echo "$INSTALLED_ALT_PTNS" > /var/local/petget/installed_alt_ptns_pet_user
      echo "$INSTALLED_ALT_PTNS" >> /tmp/petget/petget_installed_patterns_all
     fi
    fi
    touch /var/local/petget/installed_alt_ptns_pet_user
   else
    cat /var/local/petget/installed_alt_ptns_pet_user >> /tmp/petget/petget_installed_patterns_all
   fi
  ;;
 esac
fi

#20220905 apt/dpkg support... this code also in check_deps.sh and findmissingpkgs.sh
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
cp -f /tmp/petget/petget_pkg_name_aliases_patterns_raw /tmp/petget/petget_pkg_name_aliases_patterns #110706 _raw see findmissingpkgs.sh.

#100711 above has a problem as it has wildcards. need to expand...
#ex: PKG_NAME_ALIASES has an entry 'cxxlibs,glibc*,libc-*', the above creates '|cxxlibs|,|glibc.*|,|libc\-.*|',
#    after expansion: '|cxxlibs|,|glibc|,|libc-|,|glibc|,|glibc_dev|,|glibc_locales|,|glibc-solibs|,|glibc-zoneinfo|'
echo -n "" > /tmp/petget/petget_pkg_name_aliases_patterns_expanded
for ONEALIASLINE in `cat /tmp/petget/petget_pkg_name_aliases_patterns | tr '\n' ' '` #ex: |cxxlibs|,|glibc.*|,|libc\-.*|
do
 echo -n "" > /tmp/petget/petget_temp1
 for PARTONELINE in `echo -n "$ONEALIASLINE" | tr ',' ' '`
 do
  grep "$PARTONELINE" /tmp/petget/petget_installed_patterns_all >> /tmp/petget/petget_temp1
 done
 ZZZ="`echo "$ONEALIASLINE" | sed -e 's%\.\*%%g' | tr -d '\\'`"
 [ -s /tmp/petget/petget_temp1 ] && ZZZ="${ZZZ},`cat /tmp/petget/petget_temp1 | tr '\n' ',' | tr -s ',' | tr -d '\\'`"
 ZZZ="`echo -n "$ZZZ" | sed -e 's%,$%%'`"
 echo "$ZZZ" >> /tmp/petget/petget_pkg_name_aliases_patterns_expanded
done
cp -f /tmp/petget/petget_pkg_name_aliases_patterns_expanded /tmp/petget/petget_pkg_name_aliases_patterns

#w480 PKG_NAME_IGNORE is definedin PKGS_MANAGEMENT file... 100126...
xPKG_NAME_IGNORE="`echo "$PKG_NAME_IGNORE" | tr ' ' '\n' | grep -v '^$' | sed -e 's%^%|%' -e 's%$%|%' -e 's%,%|,|%g' -e 's%\\*%.*%g' -e 's%\-%\\-%g'`"
echo "$xPKG_NAME_IGNORE" > /tmp/petget/petget_pkg_name_ignore_patterns

repocnt=0
COMPAT_REPO=""
COMPAT_DBS=""
echo -n "" > /tmp/petget/petget_active_repo_list

#120831 simplify...
REPOS_RADIO=""
repocnt=0
#sort with -pet-* repos last...
#20230914 stupid grep: "grep: warning: stray \ before -" use busybox grep...
if [ "$DISTRO_BINARY_COMPAT" = "puppy" ];then
 aPRE="`echo -n "$PKG_REPOS_ENABLED" | tr ' ' '\n' | busybox grep '\-pet\-' | tr -s '\n' | tr '\n' ' '`"
 bPRE="`echo -n "$PKG_REPOS_ENABLED" | tr ' ' '\n' | busybox grep -v '\-pet\-' | tr -s '\n' | tr '\n' ' '`"
else
 aPRE="`echo -n "$PKG_REPOS_ENABLED" | tr ' ' '\n' | busybox grep -v '\-pet\-' | tr -s '\n' | tr '\n' ' '`"
 bPRE="`echo -n "$PKG_REPOS_ENABLED" | tr ' ' '\n' | busybox grep '\-pet\-' | tr -s '\n' | tr '\n' ' '`"
fi
for ONEREPO in $aPRE $bPRE #ex: ' Packages-pet-precise-official Packages-pet-noarch-official Packages-ubuntu-precise-main Packages-ubuntu-precise-multiverse '
do
 [ ! -f /root/.packages/$ONEREPO ] && continue
 REPOCUT="`echo -n "$ONEREPO" | cut -f 2-4 -d '-'`"
 [ "$REPOS_RADIO" = "" ] && FIRST_DB="$REPOCUT"
 xREPOCUT="$(echo -n "$REPOCUT" | sed -e 's%\-official$%%')" #120905 window too wide.
 xREPOCUT="$(echo -n "$xREPOCUT" | sed -e 's%^debian\-%%' -e 's%^devuan\-%%')" #20230309  20241018 devuan
 REPOS_RADIO="${REPOS_RADIO}<radiobutton><label>${xREPOCUT}</label><action>/tmp/petget/filterversion.sh ${REPOCUT}</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>"
 echo "$REPOCUT" >> /tmp/petget/petget_active_repo_list #120903 needed in findnames.sh
 repocnt=`expr $repocnt + 1`
 [ $repocnt -ge 5 ] && break
done

#20230711
if [ "$PARAM1" == "gen-tmp-files-only" ];then
 exit 0
fi

FILTER_CATEG="Desktop"
#note, cannot initialise radio buttons in gtkdialog...
echo "Desktop" > /tmp/petget/petget_filtercategory #must start with Desktop.
echo "$FIRST_DB" > /tmp/petget/current-repo-triad #ex: slackware-12.2-official

#if [ "$DISTRO_BINARY_COMPAT" = "ubuntu" -o "$DISTRO_BINARY_COMPAT" = "debian" ];then
if [ 0 -eq 1 ];then #w020 disable this choice.
 #filter pkgs by first letter, for more speed. must start with ab...
 echo "ab" > /tmp/petget/petget_pkg_first_char
 FIRSTCHARS="
<radiobutton><label>a,b</label><action>echo ab > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>c,d</label><action>echo cd > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>e,f</label><action>echo ef > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>g,h</label><action>echo gh > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>i,j</label><action>echo ij > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>k,l</label><action>echo kl > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>m,n</label><action>echo mn > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>o,p</label><action>echo op > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>q,r</label><action>echo qr > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>s,t</label><action>echo st > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>u,v</label><action>echo uv > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>w,x</label><action>echo wx > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>y,z</label><action>echo yz > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>0-9</label><action>echo 0123456789 > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
<radiobutton><label>ALL</label><action>echo ALL > /tmp/petget/petget_pkg_first_char</action><action>/usr/local/petget/filterpkgs.sh</action><action>refresh:TREE1</action></radiobutton>
"
 xFIRSTCHARS="<hbox>
${FIRSTCHARS}
</hbox>"
else
 #do not dispay the alphabetic radiobuttons...
 echo "ALL" > /tmp/petget/petget_pkg_first_char
 FIRSTCHARS=""
 xFIRSTCHARS=""
fi

#130330 GUI filtering. see also ui_Classic, ui_Ziggy, filterpkgs.sh ...
GUIONLYSTR="$(gettext 'GUI apps only')"
ANYTYPESTR="$(gettext 'Any type')"
GUIEXCSTR="$(gettext 'GUI, not')" #130331 (look in ui_Classic, ui_Ziggy to see context)
NONGUISTR="$(gettext 'Any non-GUI type')" #130331
export GUIONLYSTR ANYTYPESTR GUIEXCSTR NONGUISTR #used in ui_classic and ui_ziggy
#[ ! -f /var/local/petget/gui_filter ] && echo -n "$GUIONLYSTR" > /var/local/petget/gui_filter
[ ! -f /var/local/petget/gui_filter ] && echo -n "$ANYTYPESTR" > /var/local/petget/gui_filter #131214

#finds pkgs in repository based on filter category and version and formats ready for display...
/usr/local/petget/filterpkgs.sh $FILTER_CATEG #writes to /tmp/petget/filterpkgs.results

echo '#!/bin/sh
echo $1 > /tmp/petget/current-repo-triad
' > /tmp/petget/filterversion.sh
chmod 777 /tmp/petget/filterversion.sh

#  <text use-markup=\"true\"><label>\"<b>To install or uninstall,</b>\"</label></text>

ALLCATEGORY=''
if [ "$DISTRO_BINARY_COMPAT" = "puppy" ];then #v424 reintroduce the 'ALL' category.
 ALLCATEGORY="<radiobutton><label>$(gettext 'ALL')</label><action>/usr/local/petget/filterpkgs.sh ALL</action><action>refresh:TREE1</action></radiobutton>"
fi
#100513 also for 't2' (quirky) builds...
if [ "$DISTRO_BINARY_COMPAT" = "t2" ];then #reintroduce the 'ALL' category.
 ALLCATEGORY="<radiobutton><label>$(gettext 'ALL')</label><action>/usr/local/petget/filterpkgs.sh ALL</action><action>refresh:TREE1</action></radiobutton>"
fi
#120515 ditto for gentoo build...
if [ "$DISTRO_BINARY_COMPAT" = "gentoo" ];then #reintroduce the 'ALL' category.
 ALLCATEGORY="<radiobutton><label>$(gettext 'ALL')</label><action>/usr/local/petget/filterpkgs.sh ALL</action><action>refresh:TREE1</action></radiobutton>"
fi
#180428 ditto for 'oe' (OpenEmbedded) build...
if [ "$DISTRO_BINARY_COMPAT" = "oe" ];then #reintroduce the 'ALL' category.
 ALLCATEGORY="<radiobutton><label>$(gettext 'ALL')</label><action>/usr/local/petget/filterpkgs.sh ALL</action><action>refresh:TREE1</action></radiobutton>"
fi
#20230914 ditto for void... no, it slows the UI down too much
#if [ "$DISTRO_BINARY_COMPAT" = "void" ];then #reintroduce the 'ALL' category.
# ALLCATEGORY="<radiobutton><label>$(gettext 'ALL')</label><action>/usr/local/petget/filterpkgs.sh ALL</action><action>refresh:TREE1</action></radiobutton>"
#fi

DB_ORDERED="$REPOS_RADIO" #120831
##w476 reverse COMPAT_DBS, PUPPY_DBS...
##100412 make sure first radiobutton matches list of pkgs...
##101205 bugfix...
#DB_ORDERED="${QUIRKY_DB}
#${PUPPY_DBS}
#${COMPAT_DBS}"
#FIRST_DB_cut="`echo -n "$FIRST_DB" | cut -f 1,2 -d '-' | sed -e 's%\\-%\\\\-%g'`" #ex: puppy-lucid-official cut to puppy\-lucid.
#fdPATTERN='>'"$FIRST_DB_cut"'<'
#DB_temp0="`echo "$DB_ORDERED" | sed -e 's%^$%%' | grep "$fdPATTERN"`"
#if [ ! "$DB_temp0" ];then #120327 above may fail.
# #ex: FIRST_DB=ubuntu-precise-main, DB_ORDERED=puppy-precise\npuppy-noarch\nubuntu-precise-main\nubuntu-precise-multiverse
# FIRST_DB_cut="`echo -n "$FIRST_DB" | cut -f 1,2,3 -d '-' | sed -e 's%\\-%\\\\-%g'`" #ex: ubuntu-precise-main becomes ubuntu\-precise\-main
# fdPATTERN='>'"$FIRST_DB_cut"'<'
# DB_temp0="`echo "$DB_ORDERED" | sed -e 's%^$%%' | grep "$fdPATTERN"`"
#fi
#DB_temp1="`echo "$DB_ORDERED" | sed -e 's%^$%%' | grep -v "$fdPATTERN"`"
#DB_ORDERED="$DB_temp0
#$DB_temp1"

#  <text use-markup=\"true\"><label>\"<b>Just click on a package!</b>\"</label></text>
#  <text><label>\" \"</label></text>

#110118 alternate User Interfaces...
touch /var/local/petget/ui_choice
UI="`cat /var/local/petget/ui_choice`"
[ "$UI" = "" ] && UI="Classic"
. /usr/local/petget/ui_${UI}


RETPARAMS="`gtkdialog --program=PPM_MAIN_GUI`"

#eval "$RETPARAMS"

###END###
