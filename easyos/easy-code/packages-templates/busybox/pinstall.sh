#!/bin/sh

if [ "`pwd`" != "/" ];then
 if [ ! -f ./usr/bin/bash ];then
  echo '#!/usr/bin/ash
exec /usr/bin/ash $@' > ./usr/bin/bash
  chmod 755 ./usr/bin/bash
 else
  #as busybox got installed second, it's 'sh' overwrote...
  ln -snf bash ./usr/bin/sh
 fi
fi
