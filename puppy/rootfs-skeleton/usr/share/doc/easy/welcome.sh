#!/bin/sh
#called from /usr/sbin/quicksetup
#170812 generate welcome.htm, , only view if passed param = "run"
#180409 images/desktop1.jpg now desktop1.png
#181028 rename 'repository' folder to 'releases'.
#181219 updated images, links.
#190110 also called from 3buildeasydistro. prefix call with LANG=$NEWLANG
#190221 url fix.
#190408 thud: so weird, surfer crashes with new-line at end of file (after </html>).
#200131 rewritten for EasyPup. in EasyPup, this script will be in /usr/share/doc/easy
#200508 TEXTDOMAIN "pup_" prepended.

export TEXTDOMAIN=pup_easyhelp
export OUTPUT_CHARSET=UTF-8

PARAM1="$1"

#190110
##LANG might not be correct at first bootup, after having changed language in QuickSetup
##and not yet restarted X. so get it like this:
#NEWLANG="`grep '^LANG=' /etc/profile | tr -d "'" | tr -d '"' | cut -f 2 -d '='`"
#xNEWLANG=${NEWLANG:0:2} #ex: de
NEWLANG="$LANG"
xNEWLANG="${NEWLANG%_*}"

if [ ! -f /usr/share/locale/${xNEWLANG}/LC_MESSAGES/puppyhelp.mo ];then
 xNEWLANG=en
fi
export LANGUAGE="$xNEWLANG"

MSGh1="$(gettext 'Welcome,')"
MSGh2="$(gettext 'you are using EasyPup for the first time!')"
MSGb1="$(gettext 'EasyPup is a blend of "classical Puppy" with EasyOS. EasyOS originally derived from Puppy, but is a complete redesign, based on use of containers. EasyPup may be considered as a traditional Puppy, but with many enhancements of EasyOS, sans container support.')"
MSGm1="$(gettext 'Regarding the "Puppy part" of EasyPup, EasyPup is built with WoofQ, not with WoofCE. The latter is the build system used to create the latest official releases of Puppy. They both forked from Woof2 in 2013, and the Puppy-components of WoofQ have pretty much stayed as they were in 2013. So the Puppy-related infrastructure is a "classical Puppy".')"
MSGm2="$(gettext 'Having said that, the "EasyOS part" of WoofQ has brought considerable enhancements to the infrastructure, quite different from WoofCE. For example, audit-tracking of installed packages, and hardware profiling for video and sound. Read a summary of EasyOS features here, just ignore the references to "containers", "deprecated ISO", "boot with disabled drives" and "no full install":')"
MSGm3="$(gettext 'How and why EasyOS is different')"
MSGb2="$(gettext 'From the user point of view, usage looks pretty much like any other Puppy circa 2012-2015. If you have no prior experience with Puppy, here are some brief notes, and further links...')"
MSGd1="$(gettext 'The desktop')"
MSGd2="$(gettext 'Firstly, the desktop. It looks pretty much like any desktop, a bit retro, but we consider that to be a good thing. Rather than lengthy explanations, the best way to discover what the desktop can offer you, is just to explore. Have fun, poke around in the menu, click the icons in the tray, mouse-over will also pop-up useful information.')"
MSGd3="$(gettext 'Here is a snapshot of the desktop:')"
MSGd4="$(gettext '...the menu pops up via the button at bottom-left of screen, or right-click on the desktop. Also, explore the tray applets:')"
MSGd5="$(gettext 'Mouse-over each one, left-click and right-click on them to discover more.')"
MSGd6="$(gettext 'Discover the drive partitions:')"
MSGd7="$(gettext 'Click to mount, click "close-box" to unmount.')"
MSGd8a="$(gettext '...in this example picture, EasyPup is installed on a USB Flash drive, that identifies itself as sdb. There are two partitions, sdb1 is the <i>boot</i> partition, and sdb2 is the <i>working</i> partition. Note the orange rectangle -- this means sdb2 is mounted and cannot be unmounted.')"
MSGd8b="$(gettext 'Drive sda is an internal drive, and sda2 is mounted, and can be unmounted by clicking on the "x".')"
MSGd8c="$(gettext 'Try for yourself: click any partition, and it will mount and the file manager will open.')"
MSGd9="$(gettext 'Using EasyPup is easy, however, to discover the hidden power, it is necessary to have some appreciation of what is going on underneath...')"
MSGw1="$(gettext 'How EasyPup works')"
MSGw2="$(gettext 'This web page is a work-in-progress. For now, here is a link to an explanation of how the classical-Puppy works:')"
MSGm4="$(gettext 'How Puppy works')"

MSGi1="$(gettext 'How to install EasyPup')"
MSGi2="$(gettext 'This page is a work-in-progress. For now, here is a link to classical-Puppy documentation:')"
MSGm5="$(gettext 'How to install Puppy')"
MSGx1="$(gettext 'More help')"
MSGx2="$(gettext 'Puppy has more local help documents like this one. There are also more online help documents. Also a forum. Take your pick:')"
MSGx3a="$(gettext 'Local help:')"
MSGx3b="$(gettext 'Online help:')"
MSGx3c="$(gettext 'Online forum:')"
MSGx4="$(gettext 'Regards,')"

NEWFILE="/usr/share/doc/easy/welcome_${xNEWLANG}.htm"
[ -f ${NEWFILE} ] && rm -f ${NEWFILE}

cat >> ${NEWFILE} <<_EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
 <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
 <meta content="Barry Kauler" name="author">
 <meta content="easypup puppy quirky easyos linux aufs overlay containers operating system pc" name="description">
 <!-- BK makes table width scale to fit device screen width... -->
 <!-- <meta name="viewport" content="width=device-width"> -->
 <meta name="viewport" content="width=655px">
 <title>Easy Operating System</title>
</head>
<body>
 <table cellspacing="2" cellpadding="2" border="0" width="655" align="center">
  <tbody>
   <tr>
    <td valign="top">
     <table cellspacing="2" cellpadding="2" border="0" width="100%">
      <tbody>
       <tr>
        <td valign="top"><img src="../puppylogo96.png" alt="easypup logo" width="96" height="96"><br>
        </td>
        <td valign="top">&nbsp;&nbsp; <br>
         <b><font size="+3">${MSGh1}</font></b><br>
         <font size="+3">${MSGh2}</font>
        </td>
       </tr>
      </tbody>
     </table>
     <br>
     ${MSGb1} <br>
     <br>
     ${MSGm1} <br>
     <br>
     ${MSGm2} <br>
     <br>
     <font size="+1"><a href="https://easyos.org/about/how-and-why-easyos-is-different.html">${MSGm3}</a>
     </font><br>
     <br>
     ${MSGb2} <br>
     <h2>${MSGd1}</h2>
     ${MSGd2} <br>
     <br>
     ${MSGd3} <br>
     <img src="images/easypup.jpg" alt="desktop1" width="640" height="360"><br>
     <br>
     
     ${MSGd4}
     <br><br>
     <table cellspacing="2" cellpadding="2" border="0" width="100%">
      <tbody>
       <tr>
        <td valign="top">${MSGd5}
        </td>
        <td valign="top"><img src="images/tray-applets.png" alt="applets" width="214" height="28">
        </td>
       </tr>
      </tbody>
     </table>
     <br>
     ${MSGd6} <br>
     <table cellspacing="2" cellpadding="2" border="0" width="100%">
      <tbody>
       <tr>
        <td valign="top">${MSGd7}
        </td>
        <td valign="top"><img src="images/drive-icons.png" alt="drive-icons" width="512" height="80"><br>
        </td>
       </tr>
      </tbody>
     </table>
     <br>
     ${MSGd8a} <br>
     ${MSGd8b} <br>
     ${MSGd8c} <br>
     <br>
     ${MSGd9} <br>
     <h2>${MSGw1}</h2>
     ${MSGw2}<br>
     <br>
     <br>
     <font size="+1"><a href="https://bkhome.org/archive/puppylinux/development/howpuppyworks.html">${MSGm4}</a>
     </font><br>
     <br>

     <h2>${MSGi1}</h2>
     ${MSGi2} <br>
     <br>
     <font size="+1">
      <a href="https://bkhome.org/archive/puppylinux/install.htm">${MSGm5}</a>
     </font> <br>
     <br>

     <h2>${MSGx1}</h2>
     ${MSGx2} <br>
     <br>
     <table cellspacing="2" cellpadding="2" border="0">
      <tbody>
       <tr>
        <td valign="top"><b>${MSGx3a}</b>
        </td>
        <td valign="top"><font size="+1"><a href="help.htm">help.htm</a></font>
        </td>
       </tr>
       <tr>
        <td valign="top"><b>${MSGx3b}</b><br>
        </td>
        <td valign="top"><font size="+1"><a href="http://puppylinux.org/">http://puppylinux.org/</a></font></td>
       </tr>
       <tr>
        <td valign="top"><b>${MSGx3c}</b><br>
        </td>
        <td valign="top"><font size="+1"><a href="http://murga-linux.com/puppy">http://murga-linux.com/puppy</a></font></td>
       </tr>
      </tbody>
     </table>
     <br>
     ${MSGx4}<br>
     Barry Kauler<br>
    </td>
   </tr>
  </tbody>
 </table>
 <br>
</body>
</html>
_EOF


#190408 thud: so weird, surfer crashes with new-line at end of file...
busybox truncate -s $(($(stat -c %s ${NEWFILE})-1)) ${NEWFILE}

ln -snf welcome_${xNEWLANG}.htm /usr/share/doc/easy/welcome.htm
[ "$PARAM1" == "run" ] && exec defaultlocalbrowser /usr/share/doc/easy/welcome.htm

###END###
