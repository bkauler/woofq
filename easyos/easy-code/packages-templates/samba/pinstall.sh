#!/bin/sh

#171213 180117
if [ "$WOOF_VARIANT" == "easy" ];then #exported from 3buildeasydistro and 3builddistro
 #sed -i -e 's%^</pinboard>%  <icon x="96" y="128" label="share">/usr/sbin/quicksamba</icon>\n</pinboard>%' root/Choices/ROX-Filer/PuppyPin

 #sed -i -e 's%^</special-files>%  <rule match="/usr/sbin/quicksamba">\n    <icon>/usr/local/lib/X11/pixmaps/network48.png</icon>\n  </rule>\n</special-files>%' root/Choices/ROX-Filer/globicons

 #sed -i -e 's%path = /file%path = /files%' etc/samba/smb.conf
 sed -i -e 's%path = /home%path = /files%' etc/samba/smb.conf
fi
