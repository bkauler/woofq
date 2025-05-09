#!/bin/sh
#called from /usr/local/petget/installpreview.sh
#/tmp/petget_installpreview_pkgname (writen in installpreview.sh) has name of package being
#  previewed prior to installation. ex: abiword-1.2.3
#/tmp/petget/current-repo-triad has the repository that installing from (written in pkgchooser.sh).
#  ex: slackware-12.2-slacky
#  ...full package database file is /root/.packages/Packages-slackware-12.2-slacky
#/tmp/petget_missingpkgs_patterns (written in findmissingpkgs.sh) has a list of missing dependencies, format ex:
#  |kdebase|
#  |kdelibs|
#  |mesa-lib|
#  |qt|
#  ...that is, pkg name-only with vertical-bars on both ends, one name per line.
#/tmp/petget/petget_installed_patterns_all (writen in findmissingpkgs.sh) has a list of already installed
#  packages, both builtin and user-installed. One on each line, exs:
#  |915resolution|
#  |a52dec|
#  |absvolume_puppy|
#  |alsa\-lib|
#  |cyrus\-sasl|
#  ...notice the '-' are backslashed.
#110722 versioning info added to dependencies.
#110723 remove hardcoded path /root/.packages, so can run script in Woof.
#110822 versioning operators can be chained, ex: +linux_kernel&ge2.6.32&lt2.6.33
#111107 01micko: fix for '||' messing things up.
#120203 BK: internationalized.
#120221 jemimah: grep '[a-zA-Z]' so as to find deps with all capitals (ex: SDL).
#120831 npierce, jemimah: findmissingpkgs.sh creates /tmp/petget_missingpkgs_patterns and /tmp/petget_missingpkgs_patterns_with_versioning, need to use latter here.
#       refer: http://www.murga-linux.com/puppy/viewtopic.php?p=648934#648934
#120903 revert 120831, broken.
#120903 improve pkg db selection. fixes for versioned dependencies.
#120905 search 4 levels for dependencies.
#120907 max 11 levels, greatly improved speed. progress display at top of screen.
#121102 Packages-pet-${DISTRO_FILE_PREFIX}- (or Packages-pet-${DISTRO_COMPAT_VERSION}-) is now Packages-pet-${DISTRO_DB_SUBNAME}-. refer /etc/DISTRO_SPECS.
#130511 vercmp failed this test: if vercmp 2.2.1 ge 2.2~2011week36; then echo 'greater'; fi -- have solved this in woof, support debdb2pupdb.bac
#131209 Packages-puppy- files renamed to Packages-pet-
#20210612 replaced all yaf-splash with gtkdialog-splash. note, still ok to kill yaf-splash, see gtkdialog-splash script.
#20220903 now supporting foreign dpkg|apt
#20250510 remove ".sh" from TEXTDOMAIN

export TEXTDOMAIN=petget___dependencies
export OUTPUT_CHARSET=UTF-8

if [ -f ./PKGS_MANAGEMENT ];then #110723
. ./PKGS_MANAGEMENT
. ./DISTRO_PET_REPOS
. ./DISTRO_SPECS
 RUNNINGWOOF='yes'
 PREPATH='./'
else
. /root/.packages/PKGS_MANAGEMENT #has PKG_ALIASES_INSTALLED
. /root/.packages/DISTRO_PET_REPOS
. /etc/DISTRO_SPECS
 RUNNINGWOOF='no'
 PREPATH='/root/.packages/'
fi

#a problem is that the dependencies may have their own dependencies. Some pkg
#databases have all dependencies up-front, whereas some only list the higher-level
#dependencies and the dependencies of those have to be looked for.

#/usr/X11R7/bin/yaf-splash -font "8x16" -outline 0 -margin 4 -bg orange -text "Please wait, processing package database files..." &
gtkdialog-splash -bg orange -close never -text "$(gettext 'Please wait, processing package database files...')" &
X1PID=$!

ALLINSTALLEDPKGS="`cat /tmp/petget/petget_installed_patterns_all`"
TREE1="`cat /tmp/petget_installpreview_pkgname`"

#this is the db of the main pkg...
DB_MAIN="${PREPATH}Packages-`cat /tmp/petget/current-repo-triad`" #ex: Packages-slackware-12.2-official 110723
if [ "$RUNNINGWOOF" = "no" ];then
 #20220903 now supporting foreign dpkg|apt
 MAINDISTRO="$(cut -f 1 -d '-' /tmp/petget/current-repo-triad)" #exs: oe, debian
 if [ "$MAINDISTRO" != "pet" ];then
  #restrict deps search to only Packages-${MAINDISTRO}-*
  #this is desirable regardless whether supporting dpkg|apt.
  DB_OTHERS="$(ls -1 ${PREPATH}Packages-${MAINDISTRO}-* | grep -v "$DB_MAIN")"
 else
  #old code was here. tidy up. only look in these...
  DB_OTHERS="$(ls -1 ${PREPATH}Packages-${DISTRO_BINARY_COMPAT}-* | grep -v "$DB_MAIN")"
 fi
else
 #running woof, restrict search for deps to only the one pkg db file.
 DB_OTHERS=""
fi
DB_OTHERS="`echo "$DB_OTHERS" | tr '\n' ' '`"

#the question is, how deep to search for deps? i'll go down 2 levels... make it 3...
#120905 ubuntu precise: vlc: finds deps for -main, -universe: 3-deep: 24 23, 4-deep: 33 23, 5-deep: 36 23, 6-deep: 38 23, 7-deep: 40 23. 10-deep: 72 23.
# ...never-ending. bump to 4, final "check deps" window (after installation) will identify more missing deps. 120907 bump to 11.
SIZE2=0 #120907
echo -n "" > /tmp/petget_missingpkgs_patterns_acc #120903
echo -n "" > /tmp/petget_missingpkgs_patterns_acc0 #120903
cp -f /tmp/petget_missingpkgs_patterns /tmp/petget_missingpkgs_patternsx
echo "$(gettext 'HIERARCHY OF MISSING DEPENDENCIES OF PACKAGE') $TREE1" > /tmp/petget_deps_visualtreelog #w017
echo "$(gettext "Format of each line: 'a-missing-dependent-pkg: missing dependencies of a-missing-dependent-pkg'")" >> /tmp/petget_deps_visualtreelog #w017
for ONELEVEL in 1 2 3 4 5 6 7 8 9 10 11
do
 [ $ONELEVEL -gt 1 ] && pupkill $XXPID #120907
 gtkdialog-splash -bg "#FF8080" -placement top -close never -fontsize large -text "$(gettext 'Number of missing dependencies:') ${SIZE2}" & #120907
 XXPID=$!
 echo "" >> /tmp/petget_deps_visualtreelog #w017
 echo -n "" > /tmp/petget_missingpkgs_patterns2
 for depPATTERN in `cat /tmp/petget_missingpkgs_patternsx`
 do
  ONEDEP="`echo -n "$depPATTERN" | sed -e 's%|%%g'`" #convert to exact name, ex: abiword
  depPATTERN="`echo -n "$depPATTERN" | sed -e 's%\\-%\\\\-%g'`" #backslash '-'
  #find database entry for this package...
  for ONEDB in $DB_MAIN $DB_OTHERS
  do
   DB_dependencies="`cat $ONEDB | cut -f 1,2,9 -d '|' | grep "$depPATTERN" | cut -f 3 -d '|' | head -n 1 | sed -e 's%,$%%'`"
   xDB_dependencies="" #120903
   if [ "$DB_dependencies" != "" ];then
    xDB_dependencies="`echo -n "$DB_dependencies" | tr ',' '\n' | cut -f 1 -d '&' | tr '\n' ','`" #120903 chop off any versioning info.
    ALLDEPS_PATTERNS="`echo -n "$xDB_dependencies" | tr ',' '\n' | grep '^+' | sed -e 's%^+%%' -e 's%$%|%' -e 's%^%|%'`" #put '|' on each end.
    echo "$ALLDEPS_PATTERNS" > /tmp/petget_subpkg_deps_patterns
    cp -f /tmp/petget/petget_installed_patterns_all /tmp/petget/petget_installed_patterns_allxx #120907
    cat /tmp/petget_missingpkgs_patterns_acc >> /tmp/petget/petget_installed_patterns_allxx #120907 greatly speeds search, improves hierarchy view.
    MISSINGDEPS_PATTERNS="`grep --file=/tmp/petget/petget_installed_patterns_allxx -v /tmp/petget_subpkg_deps_patterns`"
    echo "$MISSINGDEPS_PATTERNS" >> /tmp/petget_missingpkgs_patterns2
    #w017 log a visual tree...
    MISSDEPSLIST="`echo "$MISSINGDEPS_PATTERNS" | sed -e 's%|%%g' | tr '\n' ' '`"
    case $ONELEVEL in
     1)  echo "$ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     2)  echo "    $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     3)  echo "        $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     4)  echo "            $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     5)  echo "                $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     6)  echo "                    $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     7)  echo "                        $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     8)  echo "                            $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     9)  echo "                            $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     10) echo "                                $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
     11) echo "                                    $ONEDEP: $MISSDEPSLIST" >> /tmp/petget_deps_visualtreelog ;;
    esac
    break
   fi
  done
 done
 cp -f /tmp/petget_missingpkgs_patterns_acc /tmp/petget_missingpkgs_patterns_acc-prev #120907
 sort -u /tmp/petget_missingpkgs_patterns2 > /tmp/petget_missingpkgs_patternsx0
 grep -v '^$' /tmp/petget_missingpkgs_patternsx0 > /tmp/petget_missingpkgs_patternsx
 cat /tmp/petget_missingpkgs_patternsx >> /tmp/petget_missingpkgs_patterns_acc0 #accumulate them.
 sort -u /tmp/petget_missingpkgs_patterns_acc0 > /tmp/petget_missingpkgs_patterns_acc
 #120907 get out of loop when no more missing deps found...
 SIZE1=$(cat /tmp/petget_missingpkgs_patterns_acc-prev | wc -l)
 SIZE2=$(cat /tmp/petget_missingpkgs_patterns_acc | wc -l)
 [ $SIZE1 -eq $SIZE2 ] && break
done
pupkill $XXPID

#120903 bring back the versioning info from level1 (/tmp/petget_missingpkgs_patterns_with_versioning is created in findmissingpkgs.sh)...
#restore the format ex |abiword|gt3.4| becomes |abiword&gt3.4| ...
grep -v --file=/tmp/petget_missingpkgs_patterns /tmp/petget_missingpkgs_patterns_acc > /tmp/petget_missingpkgs_patterns_accx #make sure that 2nd file does not have any level1 deps.
mv -f /tmp/petget_missingpkgs_patterns_accx /tmp/petget_missingpkgs_patterns_acc
sed -e 's%|%\&%g' -e 's%^\&%|%' -e 's%\&$%|%' /tmp/petget_missingpkgs_patterns_with_versioning >> /tmp/petget_missingpkgs_patterns_acc
sort -u /tmp/petget_missingpkgs_patterns_acc > /tmp/petget_missingpkgs_patternsx
mv -f /tmp/petget_missingpkgs_patternsx /tmp/petget_missingpkgs_patterns_and_versioning_level1
#...be careful here, _with_versioning file has |abiword|gt3.4|, _and_versioning has |abiword&gt3.4| format.
#...a limitation, only versioning of the "level 1" deps is being retained here.

#now find the entries in the databases...
rm -f /tmp/petget_missing_dbentries* 2>/dev/null
#for depPATTERN in `cat /tmp/petget_missingpkgs_patterns` #ex depPATTERN=|kdelibs| ex2: |kdelibs&gt2.3.6|
#111107 01micko: fix for '||' messing things up...
for depPATTERN in `grep '[a-zA-Z]' /tmp/petget_missingpkgs_patterns_and_versioning_level1` #ex depPATTERN=|kdelibs| ex2: |kdelibs&gt2.3.6|. 120221 jemimah. 120903 versioning.
do

 #110722 separate out any versioning... (see also findmissingpkgs.sh)
 xdepPATTERN="`echo -n "$depPATTERN" | sed -e 's%&.*%|%'`" #ex: changes |kdelibs&gt2.3.6| to |kdelibs|
 depVERSIONING="`echo -n "$depPATTERN" | grep -o '&.*' | tr -d '|'`" #ex: &gt2.3.6
 if [ "$depVERSIONING" ];then
  #110822 similar code in support/findpkgs in woof...
  DEPCONDS="`echo -n "$depVERSIONING" | cut -f 2-9 -d '&' | tr '&' ' '`" #can have chained operators, ex: ge2.6.32 lt2.6.33
 fi
 depPATTERN="`echo -n "$xdepPATTERN" | sed -e 's%\\-%\\\\-%g'`" #backslash '-'. 120903 fix.
 
 for ONEREPODB in $DB_MAIN $DB_OTHERS
 do
  DBFILE="`basename $ONEREPODB`" #ex: Packages-slackware-12.2-official
  #find database entry(s) for this package...
  DB_ENTRIES="`cat $ONEREPODB | grep "$depPATTERN"`" #120903 more than one entry may have been found.
  if [ "$DB_ENTRIES" != "" ];then
   echo "$DB_ENTRIES" | #120903
   while read DB_ENTRY
   do
    DB_version="`echo -n "$DB_ENTRY" | cut -f 3 -d '|'`"
    if [ "$depVERSIONING" ];then #110722
     #110822 support chained operators...
     condFLG='good'
     for ACOND in $DEPCONDS #ex: gt5.6.7 lt6.7.8
     do
      DEPOP="`echo -n "$ACOND" | cut -c 1,2`"
      DEPVER="`echo -n "$ACOND" | cut -c 3-99`"
      
      #130511 vercmp failed this test: if vercmp 2.2.1 ge 2.2~2011week36; then echo 'greater'; fi
      # ...this is libqtwebkit4 dep of phantomjs in precise pup, but actual libqtwebkit4 is 2.2.1.
      #try a workaround...
      #FIRSTVERFLG="$(echo -n "${DB_version}" | grep -o '~')"
      #SECONDVERFLG="$(echo -n "${DEPVER}" | grep -o '~')"
      #if [ "$FIRSTVERFLG" = "" ];then
      # [ "$SECONDVERFLG" = "~" ] && DEPVER=
      #else
      #fi
      #no, too much fussing, just always remove everything...
      #DB_versiontmp="$(echo -n "$DB_version" | cut -f 1 -d '~')"
      #DB_version="$DB_versiontmp"
      #DEPVERtmp="$(echo -n "$DEPVER" | cut -f 1 -d '~')"
      #DEPVER="$DEPVERtmp"
      #no, have solved this in woof, support/debdb2pupdb.bac.
      
      if ! vercmp ${DB_version} ${DEPOP} ${DEPVER};then
       condFLG='bad'
      fi
     done
     if [ "$condFLG" = "good" ];then
      echo "$DB_ENTRY" >> /tmp/petget_missing_dbentries-${DBFILE}-2
      break 2
     fi
    else
     echo "$DB_ENTRY" >> /tmp/petget_missing_dbentries-${DBFILE}-2
     break 2
    fi
   done
  fi
 done
done
#clean them up...
for ONEREPODB in $DB_MAIN $DB_OTHERS
do
 DBFILE="`basename $ONEREPODB`" #ex: Packages-slackware-12.2-official
 if [ -f /tmp/petget_missing_dbentries-${DBFILE}-2 ];then
  sort -u /tmp/petget_missing_dbentries-${DBFILE}-2 > /tmp/petget_missing_dbentries-${DBFILE}
  rm -f /tmp/petget_missing_dbentries-${DBFILE}-2
 fi
done

kill $X1PID

###END###

