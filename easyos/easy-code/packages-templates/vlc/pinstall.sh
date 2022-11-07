#!/bin/sh
#BK jan 2014

PWD="`pwd`"
SETDEFAULT='no'
EXTRAMSG=''

if [ "$PWD" = "/" ];then #installing in a running quirky.

# if [ "`cat /root/.packages/woof-installed-packages /root/.packages/user-installed-packages | grep 'browser\-plugin\-vlc'`" = "" ];then
#  EXTRAMSG="<text>
#      <label>Note: It is highly recommended that you also install browser-plugin-vlc, a web browser plugin. These two applications are designed to work together.</label>
#    </text>"
# fi
 
 export ASKDIALOG="
<window title=\"Ask\" decorated=\"false\" window_position=\"1\" skip_taskbar_hint=\"true\">
  <vbox>
  <frame>
    <text>
      <label>Hi, you have just installed VLC, a video and audio player. Click the 'Yes' button if you would like VLC to become the default media player, otherwise click 'No'. Note, you can also manually edit /usr/local/bin/defaultmediaplayer and /usr/local/bin/defaultvideoplayer at any time to change the default.</label>
    </text>
    ${EXTRAMSG}
    <hbox>
     <button> <label>Yes</label>  <action type=\"exit\">SetDefault</action> </button>
     <button> <label>No</label>  <action type=\"exit\">NotDefault</action> </button>
    </hbox>
  </frame>
  </vbox>
</window>
"
 RETVAL="`gtkdialog --program=ASKDIALOG`"
 echo "$RETVAL"
 [ "`echo "$RETVAL" | grep 'SetDefault'`" != "" ] && SETDEFAULT='yes'
fi

if [ "$PWD" != "/" -o "$SETDEFAULT" = "yes" ];then

  echo '#!/bin/sh' > ./usr/local/bin/defaultmediaplayer
  echo 'exec vlc "$@"' >> ./usr/local/bin/defaultmediaplayer
  chmod 755 ./usr/local/bin/defaultmediaplayer

  echo '#!/bin/sh' > ./usr/local/bin/defaultvideoplayer
  echo 'exec vlc "$@"' >> ./usr/local/bin/defaultvideoplayer
  chmod 755 ./usr/local/bin/defaultvideoplayer

fi

#150120 vlc built in t2, wants this font:
if [ ! -e usr/share/fonts/truetype/freefont/FreeSerifBold.ttf ];then
 if [ -e /usr/share/fonts/default/TTF/DejaVuSans-Bold.ttf ];then
  mkdir -p usr/share/fonts/truetype/freefont
  ln -s ../../default/TTF/DejaVuSans-Bold.ttf usr/share/fonts/truetype/freefont/FreeSerifBold.ttf
 fi
fi

#170320 easy and quirky home different... 190829
if [ -d file/media/video ];then
 sed -i -e 's%^filedialog-path=/files/media$%filedialog-path=/file/media%' root/.config/vlc/vlc-qt-interface.conf
fi
