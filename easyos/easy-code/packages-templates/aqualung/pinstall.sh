#!/bin/sh

if [ "`pwd`" != "/" ];then

 echo "Configuring Aqualung..."

 echo '#!/bin/sh' > ./usr/local/bin/defaultaudioplayer
 echo 'exec aqualung "$@"' >> ./usr/local/bin/defaultaudioplayer
 chmod 755 ./usr/local/bin/defaultaudioplayer

fi
