#!/bin/ash
#20230623
#sudo does not work. something to do with busybox mkpasswd now using sha512?
#script that wants to run as root has code that runs sudo-sh (suid binary)
# hence here. ex: /usr/sbin/bootmanager
#20230630 type-hint="6", ref: https://oldforum.puppylinux.com/viewtopic.php?t=115554
#20231218 added cancel button.

export TEXTDOMAIN=sudo-sh
export OUTPUT_CHARSET=UTF-8

PPPID="${1}"
if [ -e /proc/${PPPID} ];then #precaution
 EXE="$(cat /proc/${PPPID}/comm)"
else
 EXE='unknown'
fi
RP="$(realpath -e "$2" 2>/dev/null)"
if [ ! -x "${RP}" ];then
 RP="$(which "$2")"
 if [ ! "$RP" ];then
  exit 1
 fi
fi

shift #need this coz first argument is pid of caller-of-caller-of-caller
shift #coz have $RP

if [ -s /root/.sudo-sh-allow ];then
 grep -q -F "${EXE}:${RP}" /root/.sudo-sh-allow
 if [ $? -eq 0 ];then
  #no password required.
  exec ${RP} ${*}
 fi
fi

#rootPW="$(askpass)"
CR='
'
HELPICON="gtk-index"
M_close="$(gettext 'Close')"
H1="$(gettext 'The caller application is running as a client (non-root), and the administrator (root) password is required to run the requested application.')"
H2="$(gettext 'If you enter the correct root password, there is a checkbox to optionally not require a password in the future. Only tick this if you trust the caller application.')"
H3="$(gettext 'Technical notes')"
H4="$(gettext 'Approval to bypass password entry in the future is stored in file /root/.sudo-sh-allow. You may manually remove the line in that file to restore requirement to enter a password.')"
export DLG_HELP_SUDOSH="<window resizable=\"false\" title=\"$(gettext 'Help: AskPass')\" icon-name=\"${HELPICON}\" window_position=\"1\"><vbox><text use-markup=\"true\"><label>\"${H1}${CR}${H2}${CR}${CR}<b>${H3}</b>${CR}${H4}\"</label><variable>DLG_HELP_SUDOSH</variable></text><hbox><button><label>${M_close}</label><action type=\"closewindow\">DLG_HELP_SUDOSH</action></button></hbox></vbox></window>"

M1="<text><label>$(gettext 'This application wants to run:')</label></text>
    <text><label>${RP}</label></text>
    <text><label>$(gettext 'The administrator password is required:')</label></text>"
M2="<text><label>$(gettext 'This is the caller application:')</label></text>
    <text><label>${EXE}</label></text>"
rootPW=''
if [ $DISPLAY ];then
 export SUDOSH_DLG="
<window title=\"AskPass\" decorated=\"false\" window_position=\"1\" skip_taskbar_hint=\"true\" type-hint=\"6\">
  <vbox>
  <frame>
    ${M1}
    <entry visible_char=\"x\" visibility=\"false\"  width_chars=\"25\">
      <variable>rootPW</variable>
    </entry>
    ${M2}
    <checkbox>
     <label>$(gettext 'Tick if no password required in the future')</label>
     <variable>ALLOW_CHK</variable>
    </checkbox>
    <hbox>
     <button space-expand=\"false\" space-fill=\"false\"><label>$(gettext 'Cancel')</label><action>exit:CANCEL</action></button>
     <text space-expand=\"true\" space-fill=\"true\"><label>\"  \"</label></text>
     <button ok></button>
     <button><input file>/usr/local/lib/X11/mini-icons/mini-question.xpm</input><action type=\"launch\">DLG_HELP_SUDOSH</action></button>
    </hbox>
  </frame>
  </vbox>
</window>
"
 RETVAL="$(gtkdialog --program=SUDOSH_DLG 2>/dev/null)"
 xRETVAL="$(echo "$RETVAL" | grep -E 'rootPW|ALLOW_CHK|^EXIT')"
 eval "$xRETVAL"
 if [ "$EXIT" == "CANCEL" ];then #20231218
  exit 1
 fi
else
 echo >/dev/console
 echo -n "$(gettext 'Type admin password required to run this app:') " >/dev/console
 read -t 30 rootPW
fi

rootSALT="$(grep '^root:' /etc/shadow | cut -f 3 -d '$')"
rootHASH="$(busybox cryptpw -m SHA512 -S ${rootSALT} ${rootPW})"

grep -q -F "root:${rootHASH}" /etc/shadow
if [ $? -eq 0 ];then
 if [ "$ALLOW_CHK" == "true" ];then
  echo "${EXE}:${RP}" >> /root/.sudo-sh-allow
  chmod 0600 /root/.sudo-sh-allow
 fi
 exec ${RP} ${*}
fi
