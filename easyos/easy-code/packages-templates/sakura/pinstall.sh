#!/bin/sh

if [ "`pwd`" != "/" ];then

#vte is a very simple terminal emulator, cli similar to rxvt
VTE=''
[ -e usr/bin/vte ] && VTE=vte #in vte pkg, which is a dep of sakura.
#...maybe do something with this?

#20201003 don't need to do this anymore...
if [ -f ./root/Choices/ROX-Filer/PuppyPin ];then
 sed -i -e 's%/urxvt%/sakura%' ./root/Choices/ROX-Filer/PuppyPin
 sed -i -e 's%/rxvt%/sakura%' ./root/Choices/ROX-Filer/PuppyPin
fi

#20201003 don't need to do this anymore, as now have defaultterminal...
if [ -f ./root/Choices/ROX-Filer/globicons ];then
 if ! grep 'sakura' ./root/Choices/ROX-Filer/globicons 2>/dev/null;then
  grep -v '^</special-files>' ./root/Choices/ROX-Filer/globicons > /tmp/globicons-woof-tmp
  echo '  <rule match="/usr/bin/sakura">
    <icon>/usr/local/lib/X11/pixmaps/console48.png</icon>
  </rule>
</special-files>' >> /tmp/globicons-woof-tmp
  mv -f /tmp/globicons-woof-tmp ./root/Choices/ROX-Filer/globicons
 fi
fi

if [ -f root/.config/rox.sourceforge.net/ROX-Filer/Options ];then
 sed -i -e 's%>xterm%>sakura%' root/.config/rox.sourceforge.net/ROX-Filer/Options
fi

#20201003
echo '#!/bin/sh
exec sakura $@' > usr/local/bin/defaultterminal
chmod 755 usr/local/bin/defaultterminal

fi
