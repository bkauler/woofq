#!/bin/sh
#post-install script.

#woof: current directory is rootfs-complete, which has the final filesystem.
#ppm: current directory is /.

if [ "`pwd`" != "/" ];then
 echo '#!/bin/sh' > ./usr/local/bin/defaultdraw
 echo 'exec inkscape "$@"' >> ./usr/local/bin/defaultdraw
 chmod 755 ./usr/local/bin/defaultdraw
fi
