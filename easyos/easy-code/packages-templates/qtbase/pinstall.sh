#!/bin/sh

echo "Post-install for qtbase..."

#qt5 built in oe, has /usr/bin/qt5. templates have fixed it, however, qmake may
# have it hardcoded...
if [ -d usr/bin/qt5 ];then
 cp -a -f usr/bin/qt5/* usr/bin/
 rm -rf usr/bin/qt5
fi
ln -snf ./ usr/bin/qt5

