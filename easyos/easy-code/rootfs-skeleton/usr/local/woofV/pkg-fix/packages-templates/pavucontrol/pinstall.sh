#!/bin/sh

if [ "`pwd`" != "/" ];then
 if [ ! -e usr/bin/alsamixergui ];then #20201012
  echo '#!/bin/sh
  exec pavucontrol' > usr/local/bin/defaultaudiomixer
  chmod 755 usr/local/bin/defaultaudiomixer
 fi
fi
