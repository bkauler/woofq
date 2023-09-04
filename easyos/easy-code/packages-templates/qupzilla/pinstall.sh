#!/bin/sh

if [ ! "`pwd`" = "/" ];then
 
 echo "Configuring Qupzilla web browser..."

 echo '#!/bin/sh' > ./usr/local/bin/defaultbrowser
 echo 'exec qupzilla "$@"' >> ./usr/local/bin/defaultbrowser
 chmod 755 ./usr/local/bin/defaultbrowser
 
 #if nothing suitable installed, do this...
 #note, helpsurfer not suitable, can't display my doc/index.html 
 HTMLVIEWERFLAG='no'
 [ "`find ./usr/bin -maxdepth 1 -type f -name netsurf`" != "" ] && HTMLVIEWERFLAG='yes'
 if [ "$HTMLVIEWERFLAG" = "no" ];then
  echo '#!/bin/sh' > ./usr/local/bin/defaulthtmlviewer
  echo 'exec qupzilla "$@"' >> ./usr/local/bin/defaulthtmlviewer
  chmod 755 ./usr/local/bin/defaulthtmlviewer
 fi

fi

echo '[Desktop Entry]
Encoding=UTF-8
Name=QupZilla web browser
Icon=qupzilla.png
Comment=QupZilla web browser
Exec=qupzilla
Terminal=false
Type=Application
Categories=X-Internet-browser
GenericName=QupZilla' > usr/share/applications/qupzilla.desktop

