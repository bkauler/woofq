#!/bin/sh
#this is for hacks needed to fix a package, that might not have been done elsewhere.
#called from /usr/local/petget/installpkg.sh
#package that has just been installed is passed in on commandline.
#120924 DejaVu font no good for non-Latin languages. 120925 add korean.
#130122 xsane: remove warning about running as root.
#130221 pemasu: google-chrome run as root. 130224 pemasu: limit cache size.
#130326 pass in $DLPKG_NAME as $2. font size fix for 96 dpi.
#130507 kompozer needs MOZILLA_FIVE_HOME fix.
#140215 hacks for chromium browser. 140217
#150216 xsane: code is different for amd64.
#151123 xine-ui to find mplayer codecs.

. /etc/DISTRO_SPECS #150216 want DISTRO_TARGETARCH

INSTALLEDPKG="$1" #ex: vlc_2.0.3-0ubuntu0.12.04.1_i386, without .deb
INSTALLEDNAME="$2" #130326

#151123
xARCHDIR=""
if [ "$DISTRO_ARCHDIR_SYMLINKS" = "no" ];then
 if [ "$DISTRO_ARCHDIR" == "lib64" ];then
  xARCHDIR="64"
 else
  xARCHDIR="/${DISTRO_ARCHDIR}"
 fi
fi

case $INSTALLEDPKG in
 vlc-nox_*)
  #120907 vlc in debian/ubuntu configured to not run as root (it is a pre-compile configure option to enable running as root).
  #this hack will fix it...
  #note, this code is also in FIXUPHACK in 'vlc' template.
  if [ -f /usr/bin/bbe ];then #bbe is a sed-like utility for binary files.
   if [ -f /usr/bin/vlc  ];then
    bbe -e 's/geteuid/getppid/' /usr/bin/vlc > /tmp/vlc-temp1
    mv -f /tmp/vlc-temp1 /usr/bin/vlc
    chmod 755 /usr/bin/vlc
   fi
  fi
 ;;
 google-chrome-*) #130221 pemasu. 130224 pemasu: limit cache size...
  if [ -f /usr/bin/bbe ];then #bbe is a sed-like utility for binary files.
   if [ -f /opt/google/chrome/chrome  ];then
    bbe -e 's/geteuid/getppid/' /opt/google/chrome/chrome > /tmp/chrome-temp1
    mv -f /tmp/chrome-temp1 /opt/google/chrome/chrome
    chmod 755 /opt/google/chrome/chrome
    [ -e /usr/bin/google-chrome ] && rm -f /usr/bin/google-chrome
    echo '#!/bin/sh
exec /opt/google/chrome/google-chrome --user-data-dir=/root/.config/chrome --disk-cache-size=10000000 --media-cache-size=10000000 "$@"' > /usr/bin/google-chrome
    chmod 755 /usr/bin/google-chrome
    ln -s google-chrome /usr/bin/chrome
    ln -s /opt/google/chrome/product_logo_48.png /usr/share/pixmaps/google-chrome.png
    ln -s /opt/google/chrome/product_logo_48.png /usr/share/pixmaps/chrome.png
    CHROMEDESKTOP="`find /usr/share/applications -mindepth 1 -maxdepth 1 -iname '*chrome*.desktop'`"
    if [ "$CHROMEDESKTOP" = "" ];then #precaution.
     echo '[Desktop Entry]
Encoding=UTF-8
Version=1.0
Name=Google Chrome web browser
GenericName=Google Chrome
Comment=Google Chrome web browser
Exec=google-chrome
Terminal=false
Type=Application
Icon=google-chrome.png
Categories=WebBrowser;' > /usr/share/applications/google-chrome.desktop
    fi
   fi
  fi
 ;;
 chromium-browser_*) #ubuntu 140215 140217
  [ -e /usr/bin/chromium ] && CBEXE='chromium'
  [ -e /usr/bin/chromium-browser ] && CBEXE='chromium-browser'
  [ ! -e /usr/bin/chromium ] && ln -s chromium-browser /usr/bin/chromium
  CBPARAM=''
  if [ "`file /usr/bin/${CBEXE} | grep 'shell'`" != "" ];then
   cbPTN='s%exec \$LIBDIR/\$APPNAME \$CHROMIUM_FLAGS%exec $LIBDIR/$APPNAME $CHROMIUM_FLAGS --user-data-dir=/file/portable/chromium/profile%'
   sed -i -e "$cbPTN" /usr/bin/${CBEXE}
  else
   CBPARAM=" --user-data-dir=/file/portable/chromium/profile"
  fi
  CBDSK=''
  [ -f usr/share/applications/chromium.desktop ] && CBDSK='chromium.desktop'
  [ -f usr/share/applications/chromium-browser.desktop ] && CBDSK='chromium-browser.desktop'
  if [ -f /usr/share/applications/${CBDSK} ];then
   echo "[Desktop Entry]
Version=1.0
Name=Chromium web browser
GenericName=Chromium
Comment=Chromium web browser
Exec=chromium${CBPARAM}
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=chromium-browser.png
Categories=X-Internet-browser
MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Chromium-browser
StartupNotify=true
Actions=NewWindow;Incognito;TempProfile;
X-AppInstall-Package=chromium-browser" > /usr/share/applications/${CBDSK}
  fi
  mkdir -p /file/portable/chromium/profile/Default
  #this 0-byte file is needed so chromium will start at our quirky home page on 1st startup...
  touch "file/portable/chromium/profile/First Run"
  #preset some preferences...
  echo '{
   "download": {
      "default_directory": "/file/downloads",
      "directory_upgrade": true,
      "extensions_to_open": "",
      "prompt_for_download": true
   },
   "savefile": {
      "default_directory": "/file/downloads"
   },
   "homepage": "file:///usr/share/doc/home.htm",
   "homepage_is_newtabpage": false
}' > /file/portable/chromium/profile/Default/Preferences
  
 ;;
 jwm_theme_*)
  #120924 DejaVu font no good for non-Latin languages...
  #see also langpack_* pinstall.sh (template is in /usr/share/doc/langpack-template/pinstall.sh, read by momanager).
  LANGUSER="`grep '^LANG=' /etc/profile | cut -f 2 -d '=' | cut -f 1 -d ' '`"
  case $LANGUSER in
   zh*|ja*|ko*) #chinese, japanese, korean
    sed -i -e 's%DejaVu Sans%Sans%' /etc/xdg/templates/_root_*
    sed -i -e 's%DejaVu Sans%Sans%' /root/.jwm/themes/*-jwmrc
    sed -i -e 's%DejaVu Sans%Sans%' /root/.jwm/jwmrc-theme
   ;;
  esac
  #130326 font size fix for 96 dpi...
  if [ "$INSTALLEDNAME" ];then
   JWMTHEMEFILE="$(grep '^/root/\.jwm/themes/.*-jwmrc$' /root/.packages/${INSTALLEDNAME}.files | head -n 1)"
   [ "$JWMTHEMEFILE" ] && hackfontsize "JWMTHEMES='${JWMTHEMEFILE}'"
  fi
 ;;
 openbox*)
  #120924 DejaVu font no good for non-Latin languages...
  #see also langpack_* pinstall.sh (template is in /usr/share/doc/langpack-template/pinstall.sh, read by momanager).
  LANGUSER="`grep '^LANG=' /etc/profile | cut -f 2 -d '=' | cut -f 1 -d ' '`"
  case $LANGUSER in
   zh*|ja*|ko*) #chinese, japanese, korean
    sed -i -e 's%DejaVu Sans%Sans%' /etc/xdg/openbox/*.xml
    sed -i -e 's%DejaVu Sans%Sans%' /root/.config/openbox/*.xml
   ;;
  esac
 ;;
 gtk_theme_*)
  #120924 DejaVu font no good for non-Latin languages...
  #see also langpack_* pinstall.sh (template is in /usr/share/doc/langpack-template/pinstall.sh, read by momanager).
  LANGUSER="`grep '^LANG=' /etc/profile | cut -f 2 -d '=' | cut -f 1 -d ' '`"
  case $LANGUSER in
   zh*|ja*|ko*) #chinese, japanese, korean
    GTKRCFILE="$(find /usr/share/themes -type f -name gtkrc | tr '\n' ' ')"
    for ONEGTKRC in $GTKRCFILE
    do
     sed -i -e 's%DejaVu Sans%Sans%' $ONEGTKRC
    done
   ;;
  esac
  #130326 font size fix for 96 dpi...
  if [ "$INSTALLEDNAME" ];then
   GTKTHEMEFILE="$(grep '^/usr/share/themes/.*/gtk-2\.0/gtkrc$' /root/.packages/${INSTALLEDNAME}.files | head -n 1)"
   [ "$GTKTHEMEFILE" ] && hackfontsize "GTKRCS='${GTKTHEMEFILE}'"
  fi
 ;;
 seamonkey*|firefox*)
  #120924 DejaVu font no good for non-Latin languages...
  #see also langpack_* pinstall.sh (template is in /usr/share/doc/langpack-template/pinstall.sh, read by momanager).
  LANGUSER="`grep '^LANG=' /etc/profile | cut -f 2 -d '=' | cut -f 1 -d ' '`"
  case $LANGUSER in
   zh*|ja*|ko*) #chinese, japanese, korean
    MOZFILE="$(find /root/.mozilla -type f -name prefs.js -o -name '*.css' | tr '\n' ' ')"
    for ONEMOZ in $MOZFILE
    do
     sed -i -e 's%DejaVu Sans%Sans%' $ONEMOZ
    done
   ;;
  esac
 ;;
 mc_*) #121206 midnight commander
  #in ubuntu, won't run from the menu. this fixes it...
  [ -f /usr/share/applications/mc.desktop ] && sed -i -e 's%^Exec=.*%Exec=TERM=xterm mc%' /usr/share/applications/mc.desktop
 ;;
 xsane*) #130122
  #xsane puts up a warning msg at startup if running as root, remove it...
  #this code is also in file FIXUPHACK in xsane template (in Woof).
  #WARNING: this may only work for x86 binary.
  if [ -f /usr/bin/bbe ];then #bbe is a sed-like utility for binary files.
   if [ -f /usr/bin/xsane  ];then
    case "$DISTRO_TARGETARCH" in
     x86)
      bbe -e 's/\x6b\x00getuid/\x6b\x00getpid/' usr/bin/${ARCHDIR}/xsane > /tmp/xsane-temp1
     ;;
     *) #amd64
      bbe -e 's/\x65\x00getuid/\x65\x00getpid/' usr/bin/${ARCHDIR}/xsane > /tmp/xsane-temp1
     ;;
    esac
    mv -f /tmp/xsane-temp1 /usr/bin/xsane
    chmod 755 /usr/bin/xsane
   fi
  fi
 ;;
 kompozer*) #130507
  [ -f /usr/bin/kompozer ] && [ -d /usr/lib/kompozer ] && sed -i -e 's%^moz_libdir=%export MOZILLA_FIVE_HOME="/usr/lib/kompozer" #BK\nmoz_libdir=%' /usr/bin/kompozer
 ;;
 xine-ui*) #151123
  #configure so finds mplayer codecs, if installed...
  MPLAYER_CODECS=''
  [ -d /usr/lib${xARCHDIR}/codecs ] && MPLAYER_CODECS="/usr/lib${xARCHDIR}/codecs"
  if [ "$MPLAYER_CODECS" ];then
   mkdir -p /root/.xine
   echo ".version:2
decoder.external.real_codecs_path:${MPLAYER_CODECS}" > /root/.xine/config
  fi
 ;;
esac

