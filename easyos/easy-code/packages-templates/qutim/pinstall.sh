#!/bin/sh
#post-install script.
#140128

if [ "`pwd`" != "/" ];then

 echo '#!/bin/sh' > ./usr/local/bin/defaultchat
 echo 'exec qutim "$@"' >> ./usr/local/bin/defaultchat
 chmod 755 ./usr/local/bin/defaultchat
 
fi

echo '[Desktop Entry]
Encoding=UTF-8
Name=qutIM multiprotocol chat client
GenericName=qutIM
Comment=qutIM multiprotocol chat client
Exec=qutim
Icon=qutim.xpm
StartupNotify=true
Terminal=false
Type=Application
Categories=X-Internet-chat
X-DBUS-ServiceName=org.qutim' > usr/share/applications/qutim.desktop
