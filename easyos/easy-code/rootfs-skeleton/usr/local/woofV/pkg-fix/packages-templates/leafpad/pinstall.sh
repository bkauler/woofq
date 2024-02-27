#!/bin/sh
#post-install script.

#creatuppy: current directory is in rootfs, which has the final filesystem.
#pupget: current directory is /.

 if [ ! -f ./usr/bin/geany ];then
  if [ ! -f ./usr/bin/gedit  ];then
   echo '#!/bin/sh' > ./usr/local/bin/defaulttexteditor
   echo 'exec leafpad "$@"' >> ./usr/local/bin/defaulttexteditor
   chmod 755 ./usr/local/bin/defaulttexteditor
  fi
 fi

 echo '#!/bin/sh' > ./usr/local/bin/defaulttextviewer
 echo 'exec leafpad "$@"' >> ./usr/local/bin/defaulttextviewer
 chmod 755 ./usr/local/bin/defaulttextviewer
