#!/bin/sh
#BK 200924

PWD="`pwd`"

if [ "$PWD" != "/" ];then

  echo '#!/bin/sh' > ./usr/local/bin/defaultmediaplayer
  echo 'exec celluloidshell "$@"' >> ./usr/local/bin/defaultmediaplayer
  chmod 755 ./usr/local/bin/defaultmediaplayer

  echo '#!/bin/sh' > ./usr/local/bin/defaultvideoplayer
  echo 'exec celluloidshell "$@"' >> ./usr/local/bin/defaultvideoplayer
  chmod 755 ./usr/local/bin/defaultvideoplayer

 #20210611 ref: https://bkhome.org/news/202106/conf-files-for-mpv-and-celluloid.html
 mkdir -p root/.config/glib-2.0/settings
 touch root/.config/glib-2.0/settings/keyfile
 echo "
[io/github/celluloid-player/celluloid]
settings-migrated=true
mpv-config-file='/root/.config/celluloid/mpv.conf'
mpv-input-config-file='/root/.config/celluloid/input.conf'
" >> root/.config/glib-2.0/settings/keyfile
 mkdir -p root/.config/celluloid
 touch root/.config/celluloid/input.conf
 touch root/.config/celluloid/mpv.conf

fi
