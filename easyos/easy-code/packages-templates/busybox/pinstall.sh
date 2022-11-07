#!/bin/sh

if [ "`pwd`" != "/" ];then
 if [ ! -f ./bin/bash ];then
  echo '#!/bin/ash
exec /bin/ash $@' > ./bin/bash
  ln -snf ../../bin/bash ./usr/bin/bash
 else
  #as busybox got installed second, it's 'sh' overwrote...
  ln -snf bash ./bin/sh
 fi
fi
