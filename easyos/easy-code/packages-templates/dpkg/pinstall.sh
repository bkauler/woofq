#!/bin/sh
#20241025
#scarthgap 6.4+, running woofQ, then create wrapper around dpkg

if [ "$(pwd)" != "/" ];then
 #running in woofQ
 mv -f usr/bin/dpkg usr/bin/dpkg.bin
 cp -a -f usr/bin/dpkg-wrap usr/bin/dpkg
fi
