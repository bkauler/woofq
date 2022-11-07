#!/bin/sh
#post-install script.

if [ "`pwd`" != "/" ];then

  echo '#!/bin/sh' > ./usr/local/bin/defaultwordprocessor
  echo 'exec swriter "$@"' >> ./usr/local/bin/defaultwordprocessor
  chmod 755 ./usr/local/bin/defaultwordprocessor

fi

#20200808 debian buster  20220529 remove
##remove lib that has libstaroffice dep:
#STARLIB="$(find usr/lib -type f -name 'libwpft*lo.so' | head -n 1)"
#[ "$STARLIB" ] && rm -f ./${STARLIB}
