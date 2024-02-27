#!/bin/sh
#post-install script.
#Puppy Linux
#assume current directory is in rootfs, which has the final filesystem.
#this script is similar to the post-install scripts of the window managers.
#Keywords are located in the Help page and the lines uncommented.
#DISTRO_VERSION, DISTRO_NAME are global variables visible here.
#110422 DISTRO_VERSION variable now has dotted format. note, also now using full dotted version# in puppy filenames.
#120225 create symlink release-notes.htm to actual release-notes file. NO.
#120225 backup doc files, refer /usr/sbin/indexgen.sh.
#120818 now have /etc/xdg in Woof, taken out of xdg_puppy PET, relocated pinstall.sh to here.
#140128 3builddistro has export DISTRO_FILE_PREFIX, so visible here. 140202 split.
#150928 no longer have /usr/X11R7 (now a symlink to /usr).
#160914 have new /etc/X11/xorg.conf.d/10-evdev-puppy.conf, delete any other 10-evdev.conf
#161015 have SimpleVLC in rootfs-skeleton. 161103 now SimpleVP.
#170731 WOOF_TARGETARCH exported in 3builddistro, need in index.html
#170807 edited for easy os. 170823 180904

WKGDIR="`pwd`"

echo "Configuring Puppy skeleton..."

#cleanup...
rm -f /tmp/fbvideomode.txt

echo "Configuring Puppy Help page..."

##refer /usr/sbin/indexgen.sh...
#cp -f usr/share/doc/home.htm usr/share/doc/home-raw.htm #120225

cutDISTRONAME="`echo -n "$DISTRO_NAME" | cut -f 1 -d ' '`"
#cPATTERN="s/cutDISTRONAME/${cutDISTRONAME}/g"
RIGHTVER="$DISTRO_VERSION"
PUPPYDATE="`date | tr -s " " | cut -f 2,6 -d " "`"
dPATTERN="s/PUPPYDATE/${PUPPYDATE}/g"

#170823
##140204 NOTE: builddistro calls rootfs-complete/usr/sbin/indexgen.sh, which re-does this...
#echo "Writing version number and distro name and date to Help page..."
#PATTERN9="s/DISTRO_FILE_PREFIX/${DISTRO_FILE_PREFIX}/g" #140128
#PATTERN1="s/RIGHTVER/${RIGHTVER}/g"
#PATTERN2="s/DISTRO_VERSION/${DISTRO_VERSION}/g"
#nPATTERN="s/DISTRO_NAME/${DISTRO_NAME}/g"
#echo "Writing distro name to jumping-off page..."
#sed -i -e "$nPATTERN" usr/share/doc/home.htm

#140127 now doing this in 3builddistro...
#echo "Creating base release notes..."
#if [ ! -e usr/share/doc/release-${cutDISTRONAME}-${DISTRO_VERSION}.htm ];then
# mv -f usr/share/doc/release-skeleton.htm usr/share/doc/release-${cutDISTRONAME}-${DISTRO_VERSION}.htm
# sed -i -e "$PATTERN1" -e "$PATTERN2" -e "$nPATTERN" -e "$dPATTERN" usr/share/doc/release-${cutDISTRONAME}-${DISTRO_VERSION}.htm
#fi
#if [ ! -e usr/share/doc/release-${cutDISTRONAME}-${RIGHTVER}.htm ];then
# ln -s release-${cutDISTRONAME}-${DISTRO_VERSION}.htm usr/share/doc/release-${cutDISTRONAME}-${RIGHTVER}.htm
#fi

#120818 now have /etc/xdg in Woof, taken out of xdg_puppy PET, relocated pinstall.sh to here...
#this code is to fix the icewm menu...
if [ "`find ./usr/local/bin ./usr/bin ./usr/sbin -maxdepth 1 -type f -name evilwm`" = "" ];then
 grep -v ' evilwm$' ./etc/xdg/templates/_root_.icewm_menu > /tmp/_root_.icewm_menu
 mv -f /tmp/_root_.icewm_menu ./etc/xdg/templates/
fi
if [ "`find ./usr/local/bin ./usr/bin ./usr/sbin -maxdepth 1 -type f -name fluxbox`" = "" ];then
 grep -v ' fluxbox$' ./etc/xdg/templates/_root_.icewm_menu > /tmp/_root_.icewm_menu
 mv -f /tmp/_root_.icewm_menu ./etc/xdg/templates/
fi
if [ "`find ./usr/local/bin ./usr/bin ./usr/sbin -maxdepth 1 -type f -name fvwm95`" = "" ];then
 grep -v ' fvwm95$' ./etc/xdg/templates/_root_.icewm_menu > /tmp/_root_.icewm_menu
 mv -f /tmp/_root_.icewm_menu ./etc/xdg/templates/
fi
if [ "`find ./usr/local/bin ./usr/bin ./usr/sbin -maxdepth 1 -type f -name jwm`" = "" ];then
 grep -v ' jwm$' ./etc/xdg/templates/_root_.icewm_menu > /tmp/_root_.icewm_menu
 mv -f /tmp/_root_.icewm_menu ./etc/xdg/templates/
fi
if [ "`find ./usr/local/bin ./usr/bin ./usr/sbin -maxdepth 1 -type f -name pwm`" = "" ];then
 grep -v ' pwm$' ./etc/xdg/templates/_root_.icewm_menu > /tmp/_root_.icewm_menu
 mv -f /tmp/_root_.icewm_menu ./etc/xdg/templates/
fi
if [ "`find ./usr/local/bin ./usr/bin ./usr/sbin -maxdepth 1 -type f -name xfce4-session`" = "" ];then
 grep -v ' xfce4-session$' ./etc/xdg/templates/_root_.icewm_menu > /tmp/_root_.icewm_menu
 mv -f /tmp/_root_.icewm_menu ./etc/xdg/templates/
fi

#160914
[ -e etc/X11/xorg.conf.d/10-evdev.conf ] && rm -f etc/X11/xorg.conf.d/10-evdev.conf
[ -e usr/share/X11/xorg.conf.d/10-evdev.conf ] && rm -f usr/share/X11/xorg.conf.d/10-evdev.conf

#161015 161103
if [ -e usr/bin/vlc ];then
 echo '#!/bin/sh' > ./usr/local/bin/defaultmediaplayer
 echo 'exec simplevp "$@"' >> ./usr/local/bin/defaultmediaplayer
 chmod 755 ./usr/local/bin/defaultmediaplayer
 echo '#!/bin/sh' > ./usr/local/bin/defaultvideoplayer
 echo 'exec simplevp "$@"' >> ./usr/local/bin/defaultvideoplayer
 chmod 755 ./usr/local/bin/defaultvideoplayer
 if [ ! -e usr/share/fonts/truetype/freefont/FreeSerifBold.ttf ];then
  if [ -e /usr/share/fonts/default/TTF/DejaVuSans-Bold.ttf ];then
   mkdir -p usr/share/fonts/truetype/freefont
   ln -s ../../default/TTF/DejaVuSans-Bold.ttf usr/share/fonts/truetype/freefont/FreeSerifBold.ttf
  fi
 fi
else
 rm -f usr/share/applications/simplevp.desktop
fi

#161022 BOOT_BOARD has been exported in 3builddistro...
case "$BOOT_BOARD" in
 raspi|odroidx)
  #for the arm boards, do not want these menu entries...
  rm -f usr/share/applications/quirky-installer.desktop
  rm -f usr/share/applications/WakePup2.desktop
  rm -f usr/share/applications/video-upgrade-wizard.desktop
 ;;
esac
[ ! -f usr/bin/bcrypt ] && rm -f usr/share/applications/Bcrypt-file-encryption.desktop

#end#
