#!/bin/sh

if [ "`pwd`" != "/" ];then

  echo '#!/bin/sh' > ./usr/local/bin/defaultaudiomixer
  echo 'exec retrovol' >> ./usr/local/bin/defaultaudiomixer
  chmod 755 ./usr/local/bin/defaultaudiomixer

fi
