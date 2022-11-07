#!/bin/sh
#called from /usr/sbin/quicksetup, generate help.htm
#170812 only view result if passed param = "run"
#181219 new url easyos.org
#190110 also called from 3buildeasydistro. prefix call with LANG=$NEWLANG
#190221 url fix.
#190408 thud: so weird, surfer crashes with new-line at end of file (after </html>).
#200131 rewritten for EasyPup. in EasyPup, this script will be in /usr/share/doc/easy
#200219 file:///usr/share/doc/easy/welcome.htm open in defaultbrowser, as surfer crashes.
#200221 libgtkhtml updated to 2.12, fixes the 200219 crash.
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

MSGh1="$(gettext 'EasyPup Help')"
MSGb1="$(gettext 'Puppy help')"
MSGb2="$(gettext 'This page has links to local and online help.')"
MSGg1="$(gettext 'Getting started')"
MSGg2="$(gettext 'Local')"
MSGg3="$(gettext 'Welcome')"
MSGg4="$(gettext 'First-time users, simple introduction')"
MSGg5="$(gettext 'Online')"
MSGu1="$(gettext 'User')"
MSGu2="$(gettext 'Online')"
MSGt1="$(gettext 'Technical')"
MSGt2="$(gettext 'Local')"
MSGt3="$(gettext 'Regular expressions')"
MSGt4="$(gettext 'How to use regular expressions in code')"
MSGt5="$(gettext 'Parameter expansion')"
MSGt6="$(gettext 'Parameter expansion in Bash, Ash and sh')"
MSGt7="$(gettext 'Online')"
MSGa1="$(gettext 'App docs')"
MSGa2="$(gettext 'Click on "Menu" at bottom-left of screen and choose "Help -&gt; Doc Launcher". This will enable you to display local and online help for any package, application or utility used in Easy.')"
MSGa3="$(gettext 'Legal notices')"
MSGa4="$(gettext 'Barry Kauler established the "Puppy Linux Project" in January 2003, first website and product release 18-June-2003, and has trademark claim to the name and typed drawing of "Puppy Linux", "PuppyOS", "Puppy" and "EasyPup" as it relates to "computer operating system software to facilitate computer use and operation", under Federal and International Common Law and Trademark Laws as appropriate.')"
MSGa5="$(gettext 'Programs in Puppy are open source (except where specifically noted), and licenses of individual products are duly acknowledged. If not stated or implied, the license defaults to GPLv3. GPL licenses are defined here:')"
MSGa6="$(gettext 'The name "Puppy Linux", also known as "PuppyOS" and the shortened form "Puppy", and all artistic creations thereof, including logo, if not explicitly otherwise copyrighted, are copyright (c) 2003 Barry Kauler.') $(gettext 'The name "EasyPup", and all artistic creations thereof, including logo, if not explicitly otherwise copyrighted, are copyright (c) 2019 Barry Kauler.')"
MSGd1="$(gettext 'Disclaimer')"
MSGd2="$(gettext 'Very simple, use entirely at your own risk. Barry Kauler, and other Puppy Linux developers have acted in good faith, however accept no liability or responsibility whatsoever, and you use Puppy with this understanding.')"

MSGx1="$(gettext 'How Puppy works (user)')"
MSGx2="$(gettext 'How to install Puppy on your hard drive')"

MSGy1="$(gettext 'How Puppy Works (technical)')"

NEWFILE="/usr/share/doc/easy/help_${xNEWLANG}.htm"
[ -f ${NEWFILE} ] && rm -f ${NEWFILE}

cat >> ${NEWFILE} <<_EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
 <meta http-equiv="content-type" content="text/html; charset=UTF-8">
 <title>${MSGh1}</title>
 <meta name="author" content="Barry Kauler">
 <meta name="description" content="easypup linux help puppy quirky easyos distribution">
</head>
<body>
 <table cellspacing="2" cellpadding="2" border="0" width="600" align="center">
  <tbody>
   <tr>
    <td valign="top">
     <table cellspacing="2" cellpadding="2" border="0">
      <tbody>
       <tr>
        <td valign="top"><img src="../puppylogo96.png" alt="logo" width="96" height="96">
        </td>
        <td valign="top"><br>
         <h1>${MSGb1}</h1>
        </td>
       </tr>
      </tbody>
     </table>
     <br>
     ${MSGb2} <br>
     <h2>${MSGg1}</h2>
     <table cellspacing="0" cellpadding="2" border="1">
      <tbody>
       <tr>
        <td valign="top"><b>${MSGg2}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top"><b><a href="/usr/share/doc/easy/welcome.htm">${MSGg3}</a></b>
            </td>
            <td valign="top">${MSGg4}
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
       <tr>
        <td valign="top"><b>${MSGg5}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top">
             <b><a href="http://puppylinux.com/">http://puppylinux.com</a></b>
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
      </tbody>
     </table>
     <h2>${MSGu1}</h2>
     <table cellspacing="0" cellpadding="2" border="1">
      <tbody>
       <tr>
        <td valign="top"><b>${MSGu2}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top">&nbsp;<b><a href="https://bkhome.org/archive/puppylinux/development/howpuppyworks.html">${MSGx1}</a></b></td>
           </tr>
           <tr>
            <td valign="top">&nbsp;<b><a href="https://bkhome.org/archive/puppylinux/install.htm">${MSGx2}</a></b></td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
      </tbody>
     </table>
     <h2>${MSGt1}</h2>
     <table cellspacing="0" cellpadding="2" border="1">
      <tbody>
       <tr>
        <td valign="top"><b>${MSGt2}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top"><b><a href="/usr/share/doc/HOWTO-regexps.htm">${MSGt3}</a></b>
            </td>
            <td valign="top">${MSGt4}
            </td>
           </tr>
           <tr>
            <td valign="top"><b><a href="/usr/share/doc/HOWTO-bash-parameter-expansion.htm">${MSGt5}</a></b>
            </td>
            <td valign="top">${MSGt6}
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
       <tr>
        <td valign="top"><b>${MSGt7}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top">
             <b><a href="https://bkhome.org/archive/puppylinux/tech.htm">${MSGy1}</a></b>
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
      </tbody>
     </table>
     <br>
     <h2>${MSGa1}</h2>
     ${MSGa2}<br>
     <h2>${MSGa3}</h2>
     ${MSGa4} <br>
     <br>
     ${MSGa5} <a href="../legal/gpl-2.0.txt">GPL2.0</a>, <a href="../legal/lgpl-2.1.txt">LGPL2.1</a>, <a href="../legal/gpl-3.0.htm">GPL3.0</a>, <a href="../legal/lgpl-3.0.htm">LGPL3.0</a> <br>
     <br>
     ${MSGa6} <br>
     <br>
     <b>${MSGd1}</b><br>
     ${MSGd2} <br>
     <br>
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

ln -snf help_${xNEWLANG}.htm /usr/share/doc/easy/help.htm
[ "$PARAM1" == "run" ] && exec defaultlocalbrowser /usr/share/doc/easy/help.htm

###END###
