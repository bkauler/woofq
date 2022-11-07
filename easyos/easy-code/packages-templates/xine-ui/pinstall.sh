#!/bin/sh
#(c) Copyright Barry Kauler feb 2015. Licence: GPL v3

PWD="`pwd`"
SETDEFAULT='no'

#151123 configure so finds mplayer codecs, if installed...
MPLAYER_CODECS=''
[ -d usr/lib${xARCHDIR}/codecs ] && MPLAYER_CODECS="/usr/lib${xARCHDIR}/codecs"
if [ "$MPLAYER_CODECS" ];then
 mkdir -p root/.xine
 echo ".version:2
decoder.external.real_codecs_path:${MPLAYER_CODECS}" > root/.xine/config
fi

if [ "$PWD" = "/" ];then #installing in a running quirky.

 export ASKDIALOG="
<window title=\"Ask\" decorated=\"false\" window_position=\"1\" skip_taskbar_hint=\"true\">
  <vbox>
  <frame>
    <text>
      <label>Hi, you have just installed Xine, a video and audio player. Click the 'Yes' button if you would like Xine to become the default media player, otherwise click 'No'. Note, you can also manually edit /usr/local/bin/defaultmediaplayer and /usr/local/bin/defaultvideoplayer at any time to change the default.</label>
    </text>
    <hbox>
     <button> <label>Yes</label>  <action type=\"exit\">SetDefault</action> </button>
     <button> <label>No</label>  <action type=\"exit\">NotDefault</action> </button>
    </hbox>
  </frame>
  </vbox>
</window>
"
 RETVAL="`gtkdialog --program=ASKDIALOG`"
 #echo "$RETVAL"
 [ "`echo "$RETVAL" | grep 'SetDefault'`" != "" ] && SETDEFAULT='yes'
fi

if [ "$PWD" != "/" -o "$SETDEFAULT" = "yes" ];then

  echo '#!/bin/sh' > ./usr/local/bin/defaultmediaplayer
  echo 'exec xinewrapper "$@"' >> ./usr/local/bin/defaultmediaplayer
  chmod 755 ./usr/local/bin/defaultmediaplayer

  echo '#!/bin/sh' > ./usr/local/bin/defaultvideoplayer
  echo 'exec xinewrapper "$@"' >> ./usr/local/bin/defaultvideoplayer
  chmod 755 ./usr/local/bin/defaultvideoplayer
  
  #150326
  XINEAUDIOFLAG=1
  [ -e usr/bin/audacious ] && XINEAUDIOFLAG=0 #181007
  [ -e usr/bin/aqualung ] && XINEAUDIOFLAG=0
  [ -e usr/bin/pmusic ] && XINEAUDIOFLAG=0
  [ -e usr/local/bin/pmusic ] && XINEAUDIOFLAG=0
  if [ $XINEAUDIOFLAG -eq 1 ];then
   echo '#!/bin/sh' > ./usr/local/bin/defaultaudioplayer
   echo 'exec xinewrapper "$@"' >> ./usr/local/bin/defaultaudioplayer
   chmod 755 ./usr/local/bin/defaultaudioplayer
  fi

fi

