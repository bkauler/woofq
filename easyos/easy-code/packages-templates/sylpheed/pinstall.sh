#!/bin/sh

if [ ! "`pwd`" = "/" ];then

 echo '#!/bin/sh' > ./usr/local/bin/defaultemail
 echo 'exec sylpheed "$@"' >> ./usr/local/bin/defaultemail
 chmod 755 ./usr/local/bin/defaultemail

fi

echo '[Desktop Entry]
Encoding=UTF-8
Name=Sylpheed mail and news client
Comment=Sylpheed mail and news client
Exec=sylpheed
Icon=sylpheed.png
MimeType=message/rfc822;x-scheme-handler/mailto;
Terminal=false
Type=Application
Categories=X-Internet-mailnews' > usr/share/applications/sylpheed.desktop
