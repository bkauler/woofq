#!/bin/sh

if [ "`pwd`" != "/" ];then
 echo '#!/bin/sh' > ./usr/local/bin/defaultimageviewer
 echo 'exec gpicview "$@"' >> ./usr/local/bin/defaultimageviewer
 chmod 755 ./usr/local/bin/defaultimageviewer
fi
