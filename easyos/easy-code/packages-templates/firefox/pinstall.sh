#!/bin/sh
#post-install script.

#if [ ! "`pwd`" = "/" ];then

 echo "Configuring Firefox browser..."
 
  echo '#!/bin/sh' > ./usr/local/bin/defaultbrowser
  echo 'exec firefox "$@"' >> ./usr/local/bin/defaultbrowser
  chmod 755 ./usr/local/bin/defaultbrowser

  if [ ! -e usr/local/bin/gtkmoz ];then
   ln -s ../../bin/firefox usr/local/bin/gtkmoz
  fi

 echo "...ok, setup for Mozilla (Seamonkey)."
 echo -n "firefox" > /tmp/rightbrwsr.txt
 
 #100407 sm 2.0.4 has svg support builtin...
 [ -f ./usr/lib/mozilla/plugins/libmozsvgdec.so ] && rm -f ./usr/lib/mozilla/plugins/libmozsvgdec.so

#fi
