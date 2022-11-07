#!/bin/sh
# $Xorg: xinitrc.cpp,v 1.3 2000/08/17 19:54:30 cpqbld Exp $
#120718 redesign for startup on slow computers. see also /sbin/pup_event_frontend_d and delayedrun.
#130202 xrandr set vert freq. see also /usr/sbin/quicksetup.
#130212 removed glipper code, see latest glipper pet.
#130525 old pc celeron 2ghz cpu, 256mb ram, CPUSPEED=1999, 1st bootup rox failed to start. try experiment.
#140101 /usr/sbin/background_reshape code has been redesigned.
#160417 sometimes crash, PuppyPin is corrupted. keep a backup.
#170528 unexpected change of screen dimensions may cause desktop drive icons to be displaced.
#170927 change test "defaultpaint" to "defaultbrowser" in PuppyPin
#171206 just a wild punt, in case X not fully ready (wondering why sometimes get blank screen with mouse cursor).
#180220 start /usr/local/pup_event/frontend_timeout60
#180904 if running in container, truncated image will be already created (see setup-container).

. /etc/rc.d/PUPSTATE

if [ -f /root/.jwm/jwm_colors ];then #v3.96
. /root/.jwm/jwm_colors
fi

#171206
CNT=0
while [ ! -S /tmp/.X11-unix/X[0-9] ];do
 echo '/root/.xinitrc: waiting on /tmp/.X11-unix/X[0-9]'
 sleep 0.1
 CNT=$(($CNT+1))
 [ $CNT -gt 20 ] && exit 1
done

#160417 PuppyPin backup...
if [ -f /root/Choices/ROX-Filer/PuppyPinBACKUP ];then
 touch /root/Choices/ROX-Filer/PuppyPin
 if [ "$(grep 'defaultbrowser' /root/Choices/ROX-Filer/PuppyPin)" == "" ];then
  cp -a -f /root/Choices/ROX-Filer/PuppyPinBACKUP /root/Choices/ROX-Filer/PuppyPin
 fi
fi
cp -a -f /root/Choices/ROX-Filer/PuppyPin /root/Choices/ROX-Filer/PuppyPinBACKUP

#170528 unexpected change of screen dimensions may cause desktop drive icons to be displaced...
# /usr/local/pup_event/frontend_startup, called from pup_event_frontend_d (further down .xinitrc)
# reads screen dimensions -- move to here, so can detect a change, then redraw icons.
SCRNXY="`xwininfo -root | grep -o '\-geometry .*' | tr -s ' ' | cut -f 2 -d ' ' | cut -f 1 -d '+'`"
SCRN_X="`echo -n "$SCRNXY" | cut -f 1 -d 'x'`"
SCRN_Y="`echo -n "$SCRNXY" | cut -f 2 -d 'x'`"
echo -n "$SCRN_X" > /tmp/pup_event_frontend_scrn_x #read by frontend_change.
echo -n "$SCRN_Y" > /tmp/pup_event_frontend_scrn_y #read by frontend_change.
if [ -f /var/local/pup_event_frontend_scrn_x ];then
 oldSCRNX="$(cat /var/local/pup_event_frontend_scrn_x)"
 oldSCRNY="$(cat /var/local/pup_event_frontend_scrn_y)"
 [ "$SCRN_X" != "$oldSCRNX" ] && echo "ICONWIPE" > /var/local/pup_event_icon_change_flag
 [ "$SCRN_Y" != "$oldSCRNY" ] && echo "ICONWIPE" > /var/local/pup_event_icon_change_flag
 #.../var/local/pup_event_icon_change_flag is read by /sbin/clean_desk_icons (see below).
fi
echo -n "$SCRN_X" > /var/local/pup_event_frontend_scrn_x
echo -n "$SCRN_Y" > /var/local/pup_event_frontend_scrn_y

#v4.01 BK daemon to handle kernel uevents...
/sbin/clean_desk_icons #v4.02 tidy up drive icons first.
#/sbin/pup_event_frontend_d &
#130525 ...start this further down.

#140101 maybe need to truncate image for widescreen...
/usr/sbin/background_reshape
RET1=$?
if [ $RET1 -eq 11 ];then
 NEWIMAGE="`cat /tmp/qwallpaper_reshaped`"
 if [ -f $NEWIMAGE ];then #sanity check.
  #truncated image created, update rox...
  iPTN="s%>.*</backdrop>%>${NEWIMAGE}</backdrop>%"
  sed -i -e "$iPTN" /root/Choices/ROX-Filer/PuppyPin
 fi
fi
#180904 don't need to do this, .xinitrc not run in desk0 container. ref '/usr/bin/desk0' script in container.
##180904 if running in container, truncated image will be already created (see setup-container)...
#if [ $RET1 -eq 10 ];then #image already exists.
# NEWIMAGE="`cat /tmp/qwallpaper_reshaped`"
# grep "$NEWIMAGE" /root/Choices/ROX-Filer/PuppyPin >/dev/null
# if [ $? -ne 0 ];then
#  iPTN="s%>.*</backdrop>%>${NEWIMAGE}</backdrop>%"
#  sed -i -e "$iPTN" /root/Choices/ROX-Filer/PuppyPin
# fi
#fi

#180409 easyos, check containerized-apps still on desktop...
#note, created in /usr/local/easy_containers/easy-containers, but session-wipe may remove desktop icons.
[ -x /usr/local/easy_containers/ec-fix-desktop ] && /usr/local/easy_containers/ec-fix-desktop

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/usr/lib/X11/xinit/Xresources
sysmodmap=/usr/lib/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge -nocpp $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f $userresources ]; then
    xrdb -merge -nocpp $userresources
fi

if [ -f $usermodmap ]; then
    xmodmap $usermodmap
fi

/usr/local/pup_event/frontend_timeout60 & #180220

CURRENTWM="`cat /etc/windowmanager`"
if [ "$CURRENTWM" = "startkde" ];then
 /usr/local/pup_event/pup_event_frontend_d & #130525
 exec startkde
fi

#100501 if full nvidia pkg installed, it has a gui config app...
[ -f /root/.nvidia-settings-rc ] && nvidia-settings --load-config-only

[ -f $HOME/.xgamma-gamma ] && /bin/sh $HOME/.xgamma-gamma #100215 see /usr/sbin/xgamma-gui.

#0.9.8 sync selection-buffer and clipboard. only useful for older apps
#such as rxvt that use the selection-buffer...
[ -f /usr/bin/autocutsel ] && /usr/bin/autocutsel &
#...disadvantage of this is it creates a little square bottom-right of screen.

if [ -e /tmp/videomode ];then #xvesa only: testing a video mode
 video-wizard &
fi

[ -f /usr/local/bin/agenda_chk ] && agenda_chk &

#v1.0.7 set by xrandrshell, part of xorg wizard... v3.99... 180102 note, no longer doing this in quicksetup.
if [ -f /etc/xrandrindex ];then
  #v3.99 workround for dual monitors, 'head -n 1'....
  XRANDRDEFAULT="$(xrandr -q | grep '\*' | tr -s ' ' | grep '^ [0-9]' | cut -f 2,3 -d ' ' | cut -f 1 -d '*' | tr ' ' '@' | head -n 1)" #130202 return 1024x768@60.0
  XRANDRINDEX="`cat /etc/xrandrindex`" #v3.99 XRANDRINDEX now is XxY resolution. #130202 now vertxhoriz@freq (refer quicksetup).
  #but do not switch if default is already this resolution....
  if [ "$XRANDRINDEX" = "$XRANDRDEFAULT" ];then
   rm -f /etc/xrandrindex
  else
   NEW_XY="$(echo -n "$XRANDRINDEX" | cut -f 1 -d '@')" #130202
   NEW_VFREQ="$(echo -n "$XRANDRINDEX" | cut -f 2 -d '@')" #130202
   xrandr -s $NEW_XY -r $NEW_VFREQ #130202
  fi
fi
#180102 ref: /usr/sbin/quicksetup
if [ -f /root/.xrandroverscan ];then
 eval "`cat /root/.xrandroverscan`"
fi

if [ -f /root/.xset.sh ];then
 #this is created by /usr/bin/pupx...
 eval "/root/.xset.sh"
else
 ##Xorg has it's own fontpath settings in /etc/X11/xorg.conf...
 #if [ "`readlink /usr/bin/X`" != "Xorg" ];then
 # #xset fp+ /usr/lib/X11/fonts/Type1/
 # #xset fp+ /usr/lib/X11/fonts/TTF/
 # xset fp+ /usr/share/fonts/default/Type1/
 # xset fp+ /usr/share/fonts/default/TTF/
 #fi
 xset s 600 600 s blank
fi

#v1.0.7 also see /etc/rc.d/rc.local0
if [ -f /root/.fonts/fonts.dir ];then
 xset fp+ /root/.fonts/
fi

[ -f /usr/bin/xsetroot ] && xsetroot -cursor_name top_left_arrow

#v555 w003
#[ -f /usr/bin/xfce-mcs-manager ] && xfce-mcs-manager
#[ "$CURRENTWM" = "xfwm4" ] && xfce-mcs-manager
#...no need to start it here, fvwm4 below will start it automatically.

#relocates right-side icons to actual right-side of screen...
/usr/sbin/fixPuppyPin /root/Choices/ROX-Filer/PuppyPin #v1.0.7

#w468 on old PCs rox sometimes does not start, see further down...
#120718 raspi sometimes need extra delay otherwise rox fails to start.
CPUSPEED=`grep -m 1 -i '^cpu MHz' /proc/cpuinfo | tr -d ' ' | cut -f 2 -d ':' | cut -f 1 -d '.'` #my laptop: 933.000
[ ! $CPUSPEED ] && CPUSPEED=`grep -m 1 -i '^bogomips' /proc/cpuinfo | tr -d ' ' | cut -f 2 -d ':' | cut -f 1 -d '.'` #120718 raspi: 697.95  my laptop: 4789.47
[ ! $CPUSPEED ] && CPUSPEED=250
[ $CPUSPEED -lt 700 ] && sleep 0.5
[ $CPUSPEED -lt 400 ] && sleep 0.5
if [ -f /root/Choices/ROX-Filer/PuppyPan1 ];then
 rox -p /root/Choices/ROX-Filer/PuppyPin -r /root/Choices/ROX-Filer/PuppyPan1
else
 rox -p /root/Choices/ROX-Filer/PuppyPin
fi

/usr/local/pup_event/pup_event_frontend_d & #130525 moved down.

#v2.0.0
/usr/sbin/delayedrun &

#v2.01 hide cursor when not moving... (setup in /usr/sbin/input-wizard)
if [ -f /etc/mousehide ];then
 IDLETIME="`cat /etc/mousehide | cut -f 1 -d ','`"
 [ ! "$IDLETIME" = "0" ] && unclutter -idle $IDLETIME &
fi

##v2.14 rarsa: update xdg menu for w.m. that do not allow includes...
#which ${CURRENTWM}_menu_refresh && ${CURRENTWM}_menu_refresh
#...no, now doing it differently, see /usr/sbin/fixmenus

if [ "$CURRENTWM" = "xfwm4" ];then
 if [ "`which xfce4-panel`" != "" ];then
  xfwm4 --daemon #note, starts xfce-mcs-manager daemon also.
  exec xfce4-panel
 fi
fi

#v3.91 volume tray applet, thanks to hairywill... v3.96 MENU_BG variable...
if [ -f /usr/bin/absvolume ];then
 if [ "$MENU_BG" = "" ];then
  absvolume &
 else
  absvolume -bg $MENU_BG &
 fi
fi

#v3.95 support fbpanel tray/taskbar...
#only launch tray for w.m. without inbuilt tray...
if [ "$CURRENTWM" != "jwm" -a "$CURRENTWM" != "icewm" ];then
 if [ -f /usr/bin/fbpanel ];then
  #a bit of a hack: when 3builddistro runs fixmenus, which calls variconlinks,
  #which populates /var/local/icons with symlinks, /usr/local/lib/X11/pixmaps
  #is not yet populated (happens at first boot, from default icon theme)...
  [ ! -e /var/local/icons/home48.png ] && ln -fs /usr/local/lib/X11/pixmaps/* /var/local/icons/
  fbpanel &
 fi
 [ -f /usr/bin/lxpanel ] && lxpanel &
fi

##w468 rox may not start old hardware, try again... 120517 bring this back...
##PS="`ps`"
##if [ "`echo "$PS" | grep 'ROX\-Filer'`" = "" ];then
#if ! busybox pidof ROX-Filer;then
# touch /tmp/roxfilerstartupproblem #see /sbin/pup_event_frontend_d
# sleep 0.5
# if ! busybox pidof ROX-Filer;then #check again.
#  rox -p /root/Choices/ROX-Filer/PuppyPin
# fi
#fi

#exec $CURRENTWM
#v2.11 GuestToo suggested this improvement...
which $CURRENTWM && exec $CURRENTWM
[ -x $CURRENTWM ] && exec $CURRENTWM
exec jwm

###END###
