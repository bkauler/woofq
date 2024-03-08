#!/bin/sh

#aliases set in /etc/profile.d/xbps-aliases are not inherited in a bash script.
#so modify the vpm script...
echo "vpm post-install script"
sed -i -e 's% xbps-install % xbps-install.sh %' usr/bin/vpm
sed -i -e 's% xbps-remove % xbps-remove.sh %' usr/bin/vpm
