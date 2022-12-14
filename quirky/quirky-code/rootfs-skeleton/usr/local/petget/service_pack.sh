#!/bin/sh
#(c) Copyright Barry Kauler November 2012, bkhome.org
#License GPL v3 (/usr/share/doc/legal).
#look online for a service-pack.
#called by ppm (pkg_chooser.sh) at startup, as a separate process.
#121128 first release.
#121129 bug fix.
#121206 faster internet check. remove window centralise.
#121217 DISTRO_VERSION getting reset by 'init' in initrd, need workaround.
#131227 fix for quirky6.
#140106 preferred-choice radiobutton was incorrect.
#140106 call devx_service_pack.sh
#151105 change MAIN_DIALOG to PPM_MAIN_GUI.
#160923 rename Quirky Package Manager back to Puppy Package Manager. 170815 now PKGget. 180208 now PETget

#121206 speed this up...
#exit if no internet connection...
#check_internet
#check_internet
#if [ $? -ne 0 ];then
# sleep 2
# check_internet
#fi
IFCONFIG="`ifconfig | grep '^[pwe]' | grep -v 'wmaster'`"
[ ! "$IFCONFIG" ] && exit 1 #no network connection.
ping -4 -c 1 www.google.com
if [ $? -ne 0 ];then
 sleep 1
 ping -4 -c 1 www.google.com
 [ $? -ne 0 ] && exit 1 #no internet.
fi

export TEXTDOMAIN=petget___service_pack.sh
export OUTPUT_CHARSET=UTF-8
#. gettext.sh

. /etc/DISTRO_SPECS #has DISTRO_DB_SUBNAME
. /root/.packages/DISTRO_PET_REPOS #has PET_REPOS, PKG_DOCS_PET_REPOS

mkdir -p /tmp/petget

DBFILE="Packages\-pet\-${DISTRO_DB_SUBNAME}\-" #131227 -puppy- to -pet-
URLSPEC0="$(echo "$PKG_DOCS_PET_REPOS" | tr ' ' '\n' | grep "$DBFILE" | head -n 1 | cut -f 2 -d '|' | rev | cut -f 2-9 -d '/' | rev)"
[ "$URLSPEC0" = "" ] && exit 2
URLSPEC="${URLSPEC0}/pet_packages-${DISTRO_DB_SUBNAME}/"

#i think should test that repo is working...
URLPING="$(echo "$PKG_DOCS_PET_REPOS" | tr ' ' '\n' | grep "$DBFILE" | head -n 1 | cut -f 1 -d '|')"
ping -4 -c 1 $URLPING
[ $? -ne 0 ] && exit 1

#find all service packs...
#note, can use wildcard to test if file exists, if need to look for alternate versions, ex:
# wget -4 -t 2 -T 20 --waitretry=20 --spider -S --recursive --no-parent --no-directories -A 'avast-*.pet' 'http://distro.ibiblio.org/quirky/pet_packages-common/'
wget -4 -t 2 -T 20 --waitretry=20 --spider -S --recursive --no-parent --no-directories -A 'service_pack*.pet' "$URLSPEC" > /tmp/petget/service_pack_probe 2>&1
PTN1=" ${URLSPEC}service_pack.*\.pet$"
#ex line in file: --2012-11-25 09:01:13--  http://distro.ibiblio.org/quirky/pet_packages-precise/service_pack-5.4.1_TO_5.4.1.1_precise.pet
FNDPETURLS="$(grep -o "$PTN1" /tmp/petget/service_pack_probe | grep -v '\*' | tr '\n' ' ')"

[ "$FNDPETURLS" = "" ] && exit 3
[ "$FNDPETURLS" = " " ] && exit 3

spPTN1="|service_pack.*\.pet|"

#121217 precaution, check highest already installed...
INSTBIGGEST="$DISTRO_VERSION" #140106
INSTALLEDVERS="$(grep "$spPTN1" /root/.packages/user-installed-packages /root/.packages/woof-installed-packages | cut -f 3 -d '|' | cut -f 3 -d '_' | cut -f 1 -d '-' | tr '\n' ' ')"
for ONEIN in $INSTALLEDVERS
do
 if vercmp $ONEIN ge $INSTBIGGEST;then
  INSTBIGGEST="$ONEIN"
 fi
done

#140106 run devx_service_pack.sh as separate process...
/usr/local/petget/devx_service_pack.sh ${DISTRO_VERSION} &

CNT=0; RADIOXML=''; STARTVER=0.0; ENDVER='0.0'; ENDVERbiggest='0.0'; PETbest=''
#echo -n "" > /tmp/petget/service_pack_hack
for APETURL in $FNDPETURLS
do
 ABASE="$(basename $APETURL)"
 STARTVER="$(echo -n "$ABASE" | cut -f 2 -d '-' | cut -f 1 -d '_')" #ex: extract 5.4.1 from service_pack-5.4.1_TO_5.4.1.1_precise.pet
 ENDVER="$(echo -n "$ABASE" | cut -f 2 -d '-' | cut -f 3 -d '_' | cut -f 1 -d '-' | sed -e 's%\.pet$%%')"   #ex: extract 5.4.1.1  121217 fix.
 if vercmp $ENDVER gt $INSTBIGGEST;then #121217 precaution
  if vercmp $STARTVER eq $DISTRO_VERSION;then #140106 changed from 'le'
   if vercmp $ENDVER gt $DISTRO_VERSION;then #121129
    #check whether already installed...
    spPTN2="_TO_${ENDVER}" #do not append further qualifier.
    FNDINST="$(cat /root/.packages/user-installed-packages /root/.packages/woof-installed-packages | grep "$spPTN1" | grep "$spPTN2" | cut -f 1 -d '|')"
    [ "$FNDINST" != "" ] && continue
    CNT=`expr $CNT + 1`
    #find the size...
    PARAS="$(cat /tmp/petget/service_pack_probe | sed -e 's%^$%BLANKLINE%' | tr '\n' ' ' | tr -s ' ' | sed -e 's%BLANKLINE%\n%g')"
    LENB=`echo "$PARAS" | grep "/${ABASE}" | grep -o ' Length: [0-9]* ' | cut -f 3 -d ' '`
    [ ! $LENB ] && LENB=0
    LENK=`expr $LENB \/ 1024`
    RADIOXML="${RADIOXML}
<radiobutton><label>${ABASE} SIZE:${LENK}K</label><variable>RADIOVAR_${CNT}_</variable></radiobutton>"
    #echo "PACKAGE: ${ABASE}  SIZE: ${LENK}K" >> /tmp/petget/service_pack_hack
    if vercmp $ENDVER gt $ENDVERbiggest;then
     ENDVERbiggest="$ENDVER"
     PETbest="$ABASE"
     BESTXML="<radiobutton><label>${ABASE} SIZE:${LENK}K</label><variable>RADIOVAR_${CNT}_</variable></radiobutton>"
    fi
   fi
  fi
 fi
done

[ $CNT -eq 0 ] && exit 4

WINTITLETXT="$(gettext 'PETget Package Manager: Service Pack')" #no:   decorated=\"false\"
MSG0TXT="$(gettext 'Service Pack available!')"
MSG1TXT="$(gettext 'The current version of Quirky:')"
MSG2TXT="$(gettext 'The highest available upgrade version:')"
MSG3TXT="$(gettext 'A Service Pack is a PET package that will upgrade your Quirky, and it is highly recommended to do this.')"
case $CNT in
 1) MSG4TXT=" " ;;
 *)
  RADIOXML="$(echo "$RADIOXML" | grep -v "$PETbest")"
  RADIOXML="${BESTXML}
${RADIOXML}"
  MSG4TXT="$(gettext 'The most appropriate Service Pack is already chosen below.') "
 ;;
esac
MSG5TXT="$(gettext 'Please click the <b>OK</b> button right now, to download and install the Service Pack.')"

#121206  window_position=\"1\" 
export QSP_DIALOG="<window title=\"${WINTITLETXT}\" icon-name=\"gtk-about\">
<vbox>
 <pixmap><input file>/usr/local/lib/X11/pixmaps/question.xpm</input></pixmap>
 <text use-markup=\"true\"><label>\"<big><b>${MSG0TXT}</b></big>\"</label></text>
 <text use-markup=\"true\"><label>\"${MSG1TXT} <b>${DISTRO_VERSION}</b>\"</label></text>
 <text use-markup=\"true\"><label>\"${MSG2TXT} <b>${ENDVERbiggest}</b>\"</label></text>
 <text use-markup=\"true\"><label>\"${MSG3TXT} ${MSG4TXT}${MSG5TXT}\"</label></text>
 <frame>
  ${RADIOXML}
 </frame>
 <hbox>
  <button ok></button>
  <button cancel></button>
 </hbox>
</vbox>
</window>"

RETVALS="$(gtkdialog --program=QSP_DIALOG)"

[ "`echo "$RETVALS" | grep '^EXIT="OK"'`" = "" ] && exit 5

TAG="$(echo "$RETVALS" | grep '^RADIOVAR_' | grep '"true"' | cut -f 1 -d '=')" #ex: RADIOVAR_1_="true"
DLPET="$(echo "$RADIOXML" | grep "$TAG" | sed -e 's%^<radiobutton><label>%%' -e 's%\.pet.*%.pet%')"

#kill ppm...
ALLPS="`ps`"
PID1="$(echo "$ALLPS" | grep 'PPM_MAIN_GUI$' | sed -e 's%^ %%g' | cut -f 1 -d ' ')"
PID2="$(echo "$ALLPS" | grep 'ppm$' | sed -e 's%^ %%g' | cut -f 1 -d ' ')"
[ "$PID1" ] && kill $PID1
[ "$PID2" ] && kill $PID2 2>/dev/null

cd /root
[ -f /root/$DLPET ] && rm -f /root/$DLPET
download_file "${URLSPEC}${DLPET}"
if [ $? -eq 0 ];then
 if [ -f /root/$DLPET ];then
  petget /root/$DLPET #install the PET
  rm -f /root/$DLPET
 else
  pupmessage -bg '#FF8080' -title "$(gettext 'Download failed')" "$(gettext 'Sorry, the PET did not download. Perhaps try later.')"
  exit 6
 fi
fi

exit 0
###END###
