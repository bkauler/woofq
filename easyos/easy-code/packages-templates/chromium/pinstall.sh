#!/bin/sh
#190906 update for easyos

if [ ! "`pwd`" = "/" ];then
 
 echo "Configuring Chromium web browser..."

 [ -e usr/bin/chromium ] && CBEXE='chromium'
 [ -e usr/bin/chromium-browser ] && CBEXE='chromium' #coz of symlink
 [ ! -e usr/bin/chromium ] && ln -s chromium-browser usr/bin/chromium

# CBPARAM=''
# if [ "`file usr/bin/${CBEXE} | grep 'shell'`" = "" ];then
#  CBPARAM=" --user-data-dir=/files/portable/chromium/profile"
# fi

 echo '#!/bin/sh' > ./usr/local/bin/defaultbrowser
# echo "exec chromium${CBPARAM} \"\$@\"" >> ./usr/local/bin/defaultbrowser
 echo "exec chromium \"\$@\"" >> ./usr/local/bin/defaultbrowser
 chmod 755 ./usr/local/bin/defaultbrowser
 
# #if nothing suitable installed, do this...
# #note, helpsurfer not suitable, can't display my doc/index.html 
# HTMLVIEWERFLAG='no'
# [ "`find ./bin ./usr/bin -maxdepth 1 -type f -name netsurf`" != "" ] && HTMLVIEWERFLAG='yes'
# if [ "$HTMLVIEWERFLAG" = "no" ];then
#  echo '#!/bin/sh' > ./usr/local/bin/defaulthtmlviewer
#  echo "exec chromium${CBPARAM} \"\$@\"" >> ./usr/local/bin/defaulthtmlviewer
#  chmod 755 ./usr/local/bin/defaulthtmlviewer
# fi

fi

#140215 seamonkey symlinks created, see 3builddistro.
