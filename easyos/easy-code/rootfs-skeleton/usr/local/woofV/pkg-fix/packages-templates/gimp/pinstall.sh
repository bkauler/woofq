#!/bin/sh

if [ "`pwd`" != "/" ];then
 echo '#!/bin/sh
exec gimp "$@"' > usr/local/bin/defaultpaint
 chmod 755 usr/local/bin/defaultpaint
fi
