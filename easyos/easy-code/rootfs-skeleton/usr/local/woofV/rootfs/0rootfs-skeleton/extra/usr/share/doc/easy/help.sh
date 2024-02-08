#!/bin/sh
#called from /usr/sbin/quicksetup, generate help.htm
#170812 only view result if passed param = "run"
#181219 new url easyos.org
#190110 also called from 3buildeasydistro. prefix call with LANG=$NEWLANG
#190221 url fix.
#190408 thud: so weird, surfer crashes with new-line at end of file (after </html>).
#200219 file:///usr/share/doc/easy/welcome.htm open in defaultbrowser, as surfer crashes.
#200221 libgtkhtml updated to 2.12, fixes the 200219 crash.

export TEXTDOMAIN=easyhelp
export OUTPUT_CHARSET=UTF-8

PARAM1="$1"

#190110
##LANG might not be correct at first bootup, after having changed language in QuickSetup
##and not yet restarted X. so get it like this:
#NEWLANG="`grep '^LANG=' /etc/profile | tr -d "'" | tr -d '"' | cut -f 2 -d '='`"
#xNEWLANG=${NEWLANG:0:2} #ex: de
NEWLANG="$LANG"
xNEWLANG="${NEWLANG%_*}"

if [ ! -f /usr/share/locale/${xNEWLANG}/LC_MESSAGES/easyhelp.mo ];then
 xNEWLANG=en
fi
export LANGUAGE="$xNEWLANG"

MSGh1="$(gettext 'EasyOS Help')"
MSGb1="$(gettext 'Easy help')"
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
MSGa4="$(gettext 'Barry Kauler established "EasyOS" in June 2016, first website and product release 07-July-2016, and has trademark claim to the name and typed drawing of "Easy Linux", "Easy OS", "EasyOS" and "Easy" as it relates to "computer operating system software to facilitate computer use and operation", under Federal and International Common Law and Trademark Laws as appropriate.')"
MSGa5="$(gettext 'Programs in Easy are open source (except where specifically noted), and licenses of individual products are duly acknowledged. If not stated or implied, the license defaults to GPLv3. GPL licenses are defined here:')"
MSGa6="$(gettext 'The name "EasyOS", also known as "Easy OS", "Easy Linux" and the shortened form "Easy", and all artistic creations thereof, including logo, if not explicitly otherwise copyrighted, are copyright (c) 2016 Barry Kauler.')"
MSGd1="$(gettext 'Disclaimer')"
MSGd2="$(gettext 'Very simple, use entirely at your own risk. Barry Kauler, and other EasyOS developers have acted in good faith, however accept no liability or responsibility whatsoever, and you use EasyOS with this understanding.')"

MSGx1="$(gettext 'How Easy works (user)')"
MSGx2="$(gettext 'How to install EasyOS on your hard drive')"

MSGy1="$(gettext 'How Easy Works (technical)')"

NEWFILE="/usr/share/doc/easy/help_${xNEWLANG}.htm"
[ -f ${NEWFILE} ] && rm -f ${NEWFILE}

cat >> ${NEWFILE} <<_EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
 <meta http-equiv="content-type" content="text/html; charset=UTF-8">
 <title>${MSGh1}</title>
 <meta name="author" content="Barry Kauler">
 <meta name="description" content="easy linux help puppy quirky distribution">
</head>
<body>
 <table cellspacing="2" cellpadding="2" border="0" width="600" align="center">
  <tbody>
   <tr>
    <td valign="top">
     <table cellspacing="2" cellpadding="2" border="0">
      <tbody>
       <tr>
        <td valign="top"><img src="images/easy96.png" alt="logo" width="96" height="96">
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
             <b><a href="https://easyos.org/">https://easyos.org/</a></b>
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
            <td valign="top">&nbsp;<b><a href="https://easyos.org/tech/how-easy-works-part-2.html">${MSGx1}</a></b></td>
           </tr>
           <tr>
            <td valign="top">&nbsp;<b><a href="https://easyos.org/install/how-to-install-easyos-on-your-hard-drive.html">${MSGx2}</a></b></td>
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
             <b><a href="https://easyos.org/tech/how-easy-works.html">${MSGy1}</a></b>
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
