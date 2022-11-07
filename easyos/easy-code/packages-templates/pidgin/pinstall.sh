#!/bin/sh
#post-install script.

if [ "`pwd`" != "/" ];then

  echo '#!/bin/sh' > ./usr/local/bin/defaultchat
  echo 'exec pidginshell $@' >> ./usr/local/bin/defaultchat
  chmod 755 ./usr/local/bin/defaultchat

fi
