#!/bin/sh

##patch for Easy Linux versus Quirky...
#if [ -f root/.config/libreoffice/4/user/registrymodifications.xcu ];then
# if [ -d file ];then
#  #must be quirky
#  sed -i -e 's%/home%/file%' root/.config/libreoffice/4/user/registrymodifications.xcu
# fi
#fi

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

