#!/bin/sh
#(c) Copyright Barry Kauler 2009, puppylinux.com
#2009 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html).
#called from /usr/local/petget/pkg_chooser.sh
#configure package manager
#110118 alternate user interfaces.
#120203 BK: internationalized.
#120210 01micko: Ziggy ui crashes if *all* repos unticked here (no one would do that, but it is still a bug).
#120515 in some cases, Packages-pet-${DISTRO_FILE_PREFIX}-* may not exist (ex, Racy only has Packages-pet-wary5-official).
#120529 checkbox to display app thumbnail icons.
#120811 category field now supports sub-category |category;subcategory|, use as icon in ppm main window. -- always enabled.
#121102 Packages-pet-${DISTRO_FILE_PREFIX}- (or Packages-pet-${DISTRO_COMPAT_VERSION}-) is now Packages-pet-${DISTRO_DB_SUBNAME}-. refer /etc/DISTRO_SPECS.
#121129 Update: d/l Packages-pet-squeeze-official, which wasn't there before, upset this script.
#131209 Packages-puppy- files renamed to Packages-pet-
#151105 change "gtkdialog3" to "gtkdialog". restart ppm at exit.
#170107 remove /root/.packages/PACKAGES.TXT* after update db, so fetchinfo.sh will re-download.
#170815 now PKGget. 180208 now PETget 20220126 now PKGget
#20220903 optional dpkg|apt sync
#20230309 have removed /usr/local/debget
#20250510 remove ".sh" from TEXTDOMAIN

export TEXTDOMAIN=petget___configure
export OUTPUT_CHARSET=UTF-8

#export LANG=C
. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION
. /root/.packages/DISTRO_PKGS_SPECS
. /root/.packages/DISTRO_PET_REPOS
. /root/.packages/PKGS_MANAGEMENT #has PKG_REPOS_ENABLED

#find what repos are currently in use... 120510...
CHECKBOXES_REPOS=""
#for ONEREPO in `ls -1 /root/.packages/Packages-*`
#120510 bugfix with ui_Ziggy. add CHECKBOX_MAIN_REPO var to gui
MAIN_REPO="`ls -1 /root/.packages/Packages-* | grep "puppy\-${DISTRO_DB_SUBNAME}\-" | head -n 1 | sed 's%^/root/.packages/%%'`" #121102 121129
#120515 hmmm, in some cases, Packages-pet-${DISTRO_FILE_PREFIX}-* may not exist (ex, Racy only has Packages-pet-wary5-official)...
#121102 ...now using DISTRO_DB_SUBNAME, should always exist.
[ "$MAIN_REPO" = "" ] && MAIN_REPO="`echo "$PACKAGELISTS_PET_ORDER" | tr ' ' '\n' | head -n 1`" #PACKAGELISTS_PET_ORDER is in /root/.packages/DISTRO_PET_REPOS.
[ "$MAIN_REPO" = "" ] && MAIN_REPO="Packages-pet-noarch-official" #paranoid precaution.
bMAIN_PATTERN=' '"$MAIN_REPO"' '
MAIN_DBNAME="`echo -n "$MAIN_REPO" | sed -e 's%Packages\-%%'`"
CHECKBOX_MAIN_REPO="<checkbox><default>true</default><label>${MAIN_DBNAME}</label><variable>CHECK_${MAIN_DBNAME}</variable><visible>disabled</visible></checkbox>" #hard coded "true"

DBFILESLIST="$(ls -1 /root/.packages/Packages-*)" #121129

PKG_REPOS_ENABLED=" ${PKG_REPOS_ENABLED} " #121129 precaution.
for ONEREPO in `echo "$DBFILESLIST" | grep -v "${MAIN_REPO}" | tr '\n' ' '` #120515 fix. 121129
do
 BASEREPO="`basename $ONEREPO`"
 bPATTERN=' '"${BASEREPO}"' '
 DEFAULT='true'
 [ "`echo -n "$PKG_REPOS_ENABLED" | grep "$bPATTERN"`" = "" ] && DEFAULT='false'
 DBNAME="`echo -n "$BASEREPO" | sed -e 's%Packages\-%%'`"
 CHECKBOXES_REPOS="${CHECKBOXES_REPOS}<checkbox><default>${DEFAULT}</default><label>${DBNAME}</label><variable>CHECK_${DBNAME}</variable></checkbox>"
done

#110118 choose a user interface...
UI="`cat /var/local/petget/ui_choice`"
[ "$UI" = "" ] && UI="Classic"
UI_RADIO="<radiobutton><label>${UI}</label><action>echo -n ${UI} > /var/local/petget/ui_choice</action></radiobutton>"
for ONEUI in Classic Ziggy
do
 [ "$ONEUI" = "$UI" ] && continue
 UI_RADIO="${UI_RADIO}<radiobutton><label>${ONEUI}</label><action>echo -n ${ONEUI} > /var/local/petget/ui_choice</action></radiobutton>"
done

#  <text><label>Choose an alternate User Interface:</label></text>

#120811 remove...
##120529 note, same code in pkg_chooser.sh, so probably this not req'd...
#if [ -f /var/local/petget/flg_appicons ];then
# FLG_APPICONS="`cat /var/local/petget/flg_appicons`"
#else
# #test if pet installed with set of 16x16 app icons...
# [ "`grep 'icons_puppy_app' /root/.packages/woof-installed-packages /root/.packages/user-installed-packages`" != "" ] && FLG_APPICONS='true'
#fi
#[ "$FLG_APPICONS" = "" ] && FLG_APPICONS='false'

#120811 removed...
#  <checkbox><label>$(gettext 'Show application thumbnail icons')</label><variable>CHK_APPICONS</variable><default>${FLG_APPICONS}</default></checkbox>
#151105 removed...
#<text use-markup=\"true\"><label>\"<b>$(gettext 'Requires restart of PPM to see changes')</b>\"</label></text>

##20220903 optional dpkg|apt sync
DEBDLxml=''

export CONFIG_DIALOG="<window title=\"$(gettext 'PKGget Package Manager: configure')\" icon-name=\"gtk-about\">
<hbox>

<vbox>
 <frame $(gettext 'Update database')>
  <hbox>
   <text><label>$(gettext 'EasyOS has a database file for each package repository. Click this button to download the latest information on what packages are in the repository:')</label></text>
   <button>
    <label>$(gettext 'Update now')</label>
    <action>rxvt -bg yellow -title 'download databases' -e /usr/local/petget/0setup</action>
    ${DEBDLxml}
    <action>rm -f /root/.packages/PACKAGES.TXT* </action>
   </button>
  </hbox>
  <text><label>$(gettext "Note: some repositories are 'fixed' and do not need to be updated. An example of this is the Slackware official version 12.2 repo. An example that does change is the Slackware 'slacky' 12.2 repo which has extra packages for Slackware 12.2. Anyway, to be on the safe side, clicking the above button will update all database files.")</label></text>
  <text><label>$(gettext "Warning: The database information for some repositories is quite large, about 1.5MB for 'slacky' and several MB for Ubuntu/Debian.")</label></text>
  <text><label>$(gettext 'Technical note: if you would like to see the package databases, they are at') /root/.packages/Packages-*. $(gettext 'These are in a standardised format, regardless of which distribution they were obtained from. This format is considerably smaller than that of the original distro.')</label></text>
 </frame>
 <frame $(gettext 'User Interface')>
  ${UI_RADIO}
 </frame>
</vbox>

<vbox>
 <text use-markup=\"true\"><label>\"<b>   </b>\"</label></text>
 <frame $(gettext 'Choose repositories')>
  <text><label>$(gettext 'Choose what repositories you would like to have appear in the main GUI window (tick a maximum of 5 boxes):')</label></text>
  ${CHECKBOXES_REPOS}
  ${CHECKBOX_MAIN_REPO}
  <hbox>
   <text><label>$(gettext 'Adding a new repository currently requires manual editing of some text files. Click this button for further information:')</label></text>
   <button><label>$(gettext 'Add repo help')</label>
   <action>nohup defaulthtmlviewer file:///usr/local/petget/README-add-repo.htm & </action>
   </button>
  </hbox>
 </frame>
 <hbox>
  <button ok></button>
  <button cancel></button>
 </hbox>
</vbox>

</hbox>
</window>"

RETPARAMS="`gtkdialog --program=CONFIG_DIALOG`"
#ex:
#  CHECK_puppy-2-official="false"
#  CHECK_puppy-3-official="true"
#  CHECK_puppy-4-official="true"
#  CHECK_puppy-woof-official="false"
#  CHECK_ubuntu-intrepid-main="true"
#  CHECK_ubuntu-intrepid-multiverse="true"
#  CHECK_ubuntu-intrepid-universe="true"
#  EXIT="OK"

[ "`echo -n "$RETPARAMS" | grep 'EXIT' | grep 'OK'`" = "" ] && exit

#120811 removed...
##120529
#PREVFLG="`cat /var/local/petget/flg_appicons`"
#if [ "`echo -n "$RETPARAMS" | grep 'CHK_APPICONS' | grep 'true'`" != "" ];then
# echo -n 'true' > /var/local/petget/flg_appicons
# NEWFLG='true'
#else
# echo -n 'false' > /var/local/petget/flg_appicons
# NEWFLG='false'
#fi
#if [ "$PREVFLG" != "$NEWFLG" ];then
# #rm -f /tmp/petget_fltrd_repo_*
# #rm -f /tmp/petget_installed_*
# rm -f /tmp/installedpkgs.results.post*
# rm -f /tmp/petget/filterpkgs.results.post*
#fi

enabledrepos=" "
repocnt=1
for ONEREPO in `echo "$DBFILESLIST" | tr '\n' ' '` #121129
do
 REPOBASE="`basename $ONEREPO`"
 repoPATTERN="`echo -n "$REPOBASE" | sed -e 's%Packages\\-%%' | sed -e 's%\\-%\\\\-%g'`"
 if [ "`echo "$RETPARAMS" | grep "$repoPATTERN" | grep 'false'`" = "" ];then
  enabledrepos="${enabledrepos}${REPOBASE} "
  repocnt=`expr $repocnt + 1`
  [ $repocnt -gt 5 ] && break #only allow 5 active repos in PPM.
 fi
done
grep -v '^PKG_REPOS_ENABLED' /root/.packages/PKGS_MANAGEMENT > /tmp/pkgs_management_tmp2
mv -f /tmp/pkgs_management_tmp2 /root/.packages/PKGS_MANAGEMENT
echo "PKG_REPOS_ENABLED='${enabledrepos}'" >> /root/.packages/PKGS_MANAGEMENT

#151105 restart package manager...
for I in `grep -E "PPM_MAIN_GUI|pkg_chooser|/usr/local/bin/ppm" <<< "$(ps -eo pid,command)" | awk '{print $1}' `; do kill -9 $I; done
sleep 0.5
exec /usr/local/petget/pkg_chooser.sh

###END###
