#!/bin/sh
#post-install script.

#woof: current directory is rootfs-complete, which has the final filesystem.
#ppm: current directory is /.

if [ ! -f usr/bin/inkscape ];then
 echo '#!/bin/sh' > ./usr/local/bin/defaultdraw
 echo 'exec sdraw "$@"' >> ./usr/local/bin/defaultdraw
 chmod 755 ./usr/local/bin/defaultdraw
fi

#20200808 debian buster  20220529 remove
##remove lib that has libstaroffice dep:
#STARLIB="$(find usr/lib -type f -name 'libwpft*lo.so' | head -n 1)"
#[ "$STARLIB" ] && rm -f ./${STARLIB}
