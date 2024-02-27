#!/bin/sh
#post-install script for rox.
#Woof: current directory is in rootfs, which has the final filesystem.

echo "Configuring ROX Filer..."

#130725 some opera stuff removed.

#120521 better way to create OpenWith entries (will have icons in menu)...
#120601 filter out mtPaint-snapshot-screen-capture.desktop ... 141230... 150127...
#151218 added XINE, VLC, Evince
for ONEOPEN in Abiword BaconGUI Bcrypt ePDFView Evince FFConvert Firefox Geany gedit Ghasher Ghostview Gnumeric Gxine HomeBank InkLite Inkscape ISOMaster Leafpad LibreOffice-Calc LibreOffice-Draw LibreOffice-Impress LibreOffice-Writer mhWaveEdit Mplayer mtPaint Notecase Opera Planner Pmusic PupZip SeaMonkey-Composer SeaMonkey-web-browser Viewnior VLC XArchive XINE
do
 FNDOPEN="`find usr/share/applications -mindepth 1 -maxdepth 1 -type f -iname "${ONEOPEN}*.desktop" | grep -v 'mtPaint-snapshot' | head -n 1`"
 [ "$FNDOPEN" ] && ln -snf /${FNDOPEN} root/.config/rox.sourceforge.net/OpenWith/${ONEOPEN}
done

