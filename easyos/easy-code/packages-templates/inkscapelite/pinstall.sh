#!/bin/sh
#post-install script.

#woof: current directory is rootfs-complete, which has the final filesystem.
#ppm: current directory is /.

echo '#!/bin/sh' > ./usr/local/bin/defaultdraw
echo 'exec inkscapelite "$@"' >> ./usr/local/bin/defaultdraw
chmod 755 ./usr/local/bin/defaultdraw
