#!/bin/ash
#window in center of screen, with button to flip out of container.

export TEXTDOMAIN=easy-containers
export OUTPUT_CHARSET=UTF-8

#check if already moved to tray...
pidof jwm >/dev/null
if [ $? -eq 0 ];then
 if [ -e /root/.jwmrc-tray ];then
  grep -q -F 'flip-tray.sh' /root/.jwmrc-tray
  if [ $? -eq 0 ];then
   exit
  fi
 fi
fi

CR='
'
HELPICON="gtk-index"
#easyos has this:
DEFAULT_THEME_BASE_COLOR='blue'
if [ -f /root/.packages/default-theme ];then
 . /root/.packages/default-theme
fi
#the colors are blue green grey orange purple but maybe make lighter...
#ref: /usr/share/X11/rgb.txt
BG="${DEFAULT_THEME_BASE_COLOR}"
case "${BG}" in
 blue) BG="#4080FF" ;;
 green) BG="#80FF80" ;;
esac

gtkrc="style \"windowstuff\"
{
 bg[NORMAL]		= \"${BG}\"
}
class \"*\" style \"windowstuff\"
"
echo "$gtkrc" > /tmp/flip_gtkrc${$}
export GTK2_RC_FILES=/tmp/flip_gtkrc${$}:/root/.gtkrc-2.0

H_flip="$(gettext 'Click button to flip back to main desktop.')${CR}$(gettext 'Or, flip with the key combination ALT+F6')${CR}$(gettext 'Note: some keyboards require FN+ALT+F6')${CR}${CR}$(gettext 'If the button is used, the clipboard content will also be copied to the main desktop clipboard.')${CR}${CR}$(gettext 'Click the small button at bottom-right to move flip-button from center of screen to right-side of the tray.')${CR}${CR}$(gettext 'Back on the main desktop, you may flip back into the container by clicking on the desktop icon or entry in the tray. In the former case, the clipboard will be copied in.')${CR}$(gettext 'The container may be killed by right-click on the tray entry and choose <b>Kill</b>')"

M_close="$(gettext 'Close')"
export DLG_HELP_flip="<window resizable=\"false\" title=\"$(gettext 'Help: Flip out of container')\" icon-name=\"gtk-index\" window_position=\"1\">
 <vbox>
  <text use-markup=\"true\"><label>\"${H_flip}\"</label><variable>DLG_HELP_flip</variable></text>
  <hbox>
   <button><label>${M_close}</label>
    <action type=\"closewindow\">DLG_HELP_flip</action>
   </button>
  </hbox>
 </vbox></window>"

MOVEBUTTON=''
if [ -e /root/.jwmrc-tray ];then
 pidof jwm >/dev/null
 if [ $? -eq 0 ];then
  grep -q 'STARTEXTRA' /root/.jwmrc-tray
  if [ $? -eq 0 ];then
   MOVEBUTTON="<button>
  <input file>/usr/local/lib/X11/mini-icons/go-jump.png</input>
  <action>/usr/local/easy_containers/flip-move-2-tray</action>
  <action>exit:gotout</action>
 </button>"
  fi
 fi
fi

export FLIP_DLG="<window decorated=\"false\" skip_taskbar_hint=\"true\">
<hbox>
 <button>
  <input file>/usr/local/easy_containers/images/flip64.png</input>
  <action>echo 1 > /.flip-out-flg</action>
 </button>
 <vbox>
  <button>
   <input file>/usr/local/lib/X11/mini-icons/mini-question.xpm</input>
   <action type=\"launch\">DLG_HELP_flip</action>
  </button>
  ${MOVEBUTTON}
 </vbox>
</hbox>
</window>"

RETVALS="$(gtkdialog --program=FLIP_DLG --center)"

echo "${RETVALS}" | grep -q 'gotout'
if [ $? -eq 0 ];then
 jwm -restart
fi

###end###
