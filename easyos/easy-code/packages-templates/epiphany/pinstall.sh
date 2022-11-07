#!/bin/sh
#20200928 oe dunfell 

if [ "`pwd`" != "/" ];then
 #running in woofq.
 
 echo "Configuring Epiphany browser..."
 
 echo '#!/bin/sh' > ./usr/local/bin/defaultbrowser
 echo 'exec epiphany "$@"' >> ./usr/local/bin/defaultbrowser
 chmod 755 ./usr/local/bin/defaultbrowser

 echo "...ok, setup for Epiphany."
 echo -n "epiphany" > /tmp/rightbrwsr.txt
 
fi
