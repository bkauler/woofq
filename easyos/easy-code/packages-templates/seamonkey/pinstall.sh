#!/bin/sh
#post-install script for Mozilla.
#woof: current directory is rootfs-complete, which has the final filesystem.
#191008 do not create nss/nspr symlinks if system libs exist.

if [ ! "`pwd`" = "/" ];then

 echo "Configuring Mozilla SeaMonkey browser..."
 
 #20211107 the default is already mozstart, in woofq rootfs-skeleton.
 #need to know whether firefox has grabbed it...
 grep -q 'firefox' ./usr/local/bin/defaultbrowser 2>/dev/null
 if [ $? -ne 0 ];then #redoing it...
  echo '#!/bin/sh' > ./usr/local/bin/defaultbrowser
  echo 'exec mozstart "$@"' >> ./usr/local/bin/defaultbrowser
  chmod 755 ./usr/local/bin/defaultbrowser
 fi

  #091118 sm2 cannot have gtkmoz or puppybrowser...
  if [ ! -f usr/local/bin/gtkmoz ];then
   ln -s mozstart usr/local/bin/gtkmoz
  fi

  echo '#!/bin/sh' > ./usr/local/bin/defaultemail
  echo 'exec mozmail "$@"' >> ./usr/local/bin/defaultemail
  chmod 755 ./usr/local/bin/defaultemail

  echo '#!/bin/sh' > ./usr/local/bin/defaulthtmleditor
  echo 'exec mozedit "$@"' >> ./usr/local/bin/defaulthtmleditor
  chmod 755 ./usr/local/bin/defaulthtmleditor

  #echo 'exec mozcalendar $@' > ./usr/local/bin/defaultcalendar

  echo '#!/bin/sh' > ./usr/local/bin/defaultcontact
  echo 'exec mozaddressbook "$@"' >> ./usr/local/bin/defaultcontact
  chmod 755 ./usr/local/bin/defaultcontact

  NOCHAT="true"
  [ -e usr/bin/ayttm ] && NOCHAT="false"
  [ -e usr/bin/xchat ] && NOCHAT="false"
  [ -e usr/bin/qutim ] && NOCHAT="false"
  [ -e usr/bin/pidgin ] && NOCHAT="false"
  if [ "$NOCHAT" = "true" ];then
   echo '#!/bin/sh' > ./usr/local/bin/defaultchat
   echo 'exec mozchat "$@"' >> ./usr/local/bin/defaultchat
   chmod 755 usr/local/bin/defaultchat
  fi

 echo "...ok, setup for Mozilla (Seamonkey)."
 echo -n "seamonkey" > /tmp/rightbrwsr.txt

 #161230
 [ -e usr/lib/seamonkey ] && SMPATH='usr/lib'
 [ -e usr/lib64/seamonkey ] && SMPATH='usr/lib64' #slackware pkg.

 #150128 moved out of FIXUPHACK. 161230
 for ALIBLINK in libmozsqlite3.so libnspr4.so libnss3.so  libnssckbi.so libnssutil3.so libplc4.so libplds4.so libsmime3.so libsoftokn3.so libssl3.so
 do
  [ -e usr/lib/${ALIBLINK} ] && continue #191008
  [ -e usr/lib64/${ALIBLINK} ] && continue #191008 note, debian|ubuntu lib64 is a symlink.
  #if [ ! -e ${SMPATH}/${ALIBLINK} ];then
   #if [ -e usr/lib/seamonkey/${ALIBLINK} ];then
    ln -s seamonkey/${ALIBLINK} ${SMPATH}/${ALIBLINK}
   #fi
  #fi
 done
 
 #161230
 if [ -d usr/share/hunspell ];then
  HUNSPELL="$(find usr/share/hunspell -maxdepth 1 -type f -name '*.dic' | head -n 1)"
  if [ "$HUNSPELL" ];then
   HSBASE="$(basename $HUNSPELL .dic)" #ex: en_US
   xHSBASE="$(echo -n $HSBASE | tr '_' '-')" #ex: en-US
   ln -snf ../../../share/hunspell/${HSBASE}.aff ${SMPATH}/seamonkey/dictionaries/${xHSBASE}.aff
   ln -snf ../../../share/hunspell/${HSBASE}.dic ${SMPATH}/seamonkey/dictionaries/${xHSBASE}.dic
  fi
 fi

fi
