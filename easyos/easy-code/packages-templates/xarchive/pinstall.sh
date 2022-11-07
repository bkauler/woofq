#!/bin/sh
#120516 note, xarchive has been internationalised by rodin.s
# -- xarchive.pot is in Woof, in rootfs-skeleton/usr/share/doc/nls.
# -- MoManager is used to create translations.

echo "Xarchive post-install script"

if [ ! -f ./usr/local/bin/TkZip ];then
 ln -s pupzip ./usr/local/bin/TkZip
fi

if [ ! -f ./usr/local/bin/guitar ];then
 ln -s pupzip ./usr/local/bin/guitar
fi
