#!/bin/sh

if [ "`pwd`" != "/" ];then

 echo "Configuring Audacious..."

 echo '#!/bin/sh' > ./usr/local/bin/defaultaudioplayer
 echo 'exec audacious "$@"' >> ./usr/local/bin/defaultaudioplayer
 chmod 755 ./usr/local/bin/defaultaudioplayer

fi
