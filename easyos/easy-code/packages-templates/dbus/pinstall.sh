#!/bin/sh
#BK may 2011
#20210612 replaced yaf-splash with gtkdialog-splash

if [ "`pwd`" = "/" ];then #installing in a running puppy (not in woof)
 gtkdialog-splash -bg pink -close box -placement center -text "You have installed Dbus, but it will not work until after Puppy is rebooted. Please do so before trying to run any application that depends on Dbus." &
fi
