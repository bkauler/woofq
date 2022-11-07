#!/bin/sh
#assume current directory is rootfs-complete, which has the final filesystem.
#20220116 now runs in systray only, cannot start it separately. comment out...

#if [ ! "`pwd`" = "/" ];then
# echo "Configuring Osmo..."
# echo '#!/bin/sh' > ./usr/local/bin/defaultcalendar
# echo 'exec osmo $@' >> ./usr/local/bin/defaultcalendar
# chmod 755 ./usr/local/bin/defaultcalendar
#fi
