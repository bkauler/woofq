#!/bin/sh

if [ "`pwd`" != "/" ]; then
   echo '#!/bin/sh' > ./usr/local/bin/defaultaudioplayer
   echo 'exec deadbeef "$@"' >> ./usr/local/bin/defaultaudioplayer
   chmod 755 ./usr/local/bin/defaultaudioplayer
fi
