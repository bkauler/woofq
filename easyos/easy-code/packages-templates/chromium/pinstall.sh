#!/bin/sh

if [ "`pwd`" != "/" ];then
 
 echo "Configuring Chromium web browser..."

 echo '#!/bin/sh' > ./usr/local/bin/defaultbrowser
 echo "exec chromium \"\$@\"" >> ./usr/local/bin/defaultbrowser
 chmod 755 ./usr/local/bin/defaultbrowser
 
 #20230130 replace seamonkey 'www' container...
 sed -i -e 's% seamonkey% chromium%' usr/sbin/ec-chroot-www 

else
 #installing in running easyos, run as root...
 if [ -e usr/bin/chromium-browser ];then
  if [ ! -e usr/bin/chromium  ];then
   ln -s chromium-browser usr/bin/chromium
  fi
 fi
 if [ ! -e usr/bin/chromium ];then #oe kirkstone
  echo '#!/bin/ash
exec /usr/lib/chromium/chromium-wrapper --test-type --no-sandbox --user-data-dir=${HOME}/.config/chromium --disk-cache-size=10000000 --media-cache-size=10000000 $@' > usr/bin/chromium
  chmod 755 usr/bin/chromium
 fi
fi
