#!/bin/sh
#post-install script.

#woof: current directory is in rootfs, which has the final filesystem.
#ppm: current directory is /.

if [ "`pwd`" != "/" ];then
 echo '#!/bin/sh' > ./usr/local/bin/defaultdraw
 echo 'exec inkscape "$@"' >> ./usr/local/bin/defaultdraw
 chmod 755 ./usr/local/bin/defaultdraw
fi

#20240222 de-bloat...
if [ -d usr/lib/libreoffice/help ];then
 rm -rf usr/lib/libreoffice/help
 mkdir usr/lib/libreoffice/help
fi
