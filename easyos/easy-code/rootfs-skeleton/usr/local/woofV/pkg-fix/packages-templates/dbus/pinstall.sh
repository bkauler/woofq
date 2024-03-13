#!/bin/sh
#20240313 have removed FIXHACK, replaced with this.

if [ -f usr/libexec/dbus-daemon-launch-helper ];then
 #sets the suid permission...
 #chmod u+s usr/libexec/dbus-daemon-launch-helper
 #do it this way...
 chmod 4755 usr/libexec/dbus-daemon-launch-helper
 #dbus pkg INSTALL set to root:22 fix...
 chown root:messagebus usr/libexec/dbus-daemon-launch-helper
fi
