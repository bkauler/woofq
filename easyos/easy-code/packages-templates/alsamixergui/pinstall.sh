#!/bin/sh

if [ "`pwd`" != "/" ];then
 echo '#!/bin/sh
 exec alsamixergui' > usr/local/bin/defaultaudiomixer
 chmod 755 usr/local/bin/defaultaudiomixer
fi
