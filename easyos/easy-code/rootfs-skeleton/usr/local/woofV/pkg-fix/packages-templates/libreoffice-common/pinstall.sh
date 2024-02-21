#!/bin/sh

if [ "`pwd`" != "/" ];then

 echo '#!/bin/sh
 exec scalc "$@"' > usr/local/bin/defaultspreadsheet
 chmod 755 usr/local/bin/defaultspreadsheet

 if [ ! -f usr/bin/inkscape ];then
  echo '#!/bin/sh' > ./usr/local/bin/defaultdraw
  echo 'exec sdraw "$@"' >> ./usr/local/bin/defaultdraw
  chmod 755 ./usr/local/bin/defaultdraw
 fi

 echo '#!/bin/sh' > ./usr/local/bin/defaultwordprocessor
 echo 'exec swriter "$@"' >> ./usr/local/bin/defaultwordprocessor
 chmod 755 ./usr/local/bin/defaultwordprocessor

fi

#20240220
rm -f usr/share/applications/libreoffice*.desktop

