#!/bin/sh
#called from /usr/sbin/quicksetup, generate home.htm
#170812 only view result if passed param = "run"
#181219 new url easyos.org
#190110 also called from 3buildeasydistro. prefix call with LANG=$NEWLANG
#190221 url fix.
#190301 fix home.htm redirection.
#190408 thud: so weird, surfer crashes with new-line at end of file (after </html>).
#200219 file:///usr/share/doc/easy/welcome.htm open in defaultbrowser, as surfer crashes.
#200221 libgtkhtml updated to 2.12, fixes the 200219 crash.
#200223 changed forum link to murga. 200714 change to easyos.org/forum
#20210525 changed forum link.

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

MSGb1="$(gettext 'EasyOS jumping off page')"
MSGb2="$(gettext 'This page has links to discover more about Easy, and join the user community.')"
MSGb3="$(gettext 'Have fun!')"
MSGs1="$(gettext 'Getting started')"
MSGs2="$(gettext 'Local')"
MSGs3="$(gettext 'Welcome')"
MSGs4="$(gettext 'First-time users, simple introduction')"
MSGs5="$(gettext 'Online')"
MSGu1="$(gettext 'User')"
MSGu2="$(gettext 'Online')"
MSGt1="$(gettext 'Technical')"
MSGt2="$(gettext 'Local')"
MSGt3="$(gettext 'Regular expressions')"
MSGt4="$(gettext 'How to use regular expressions in code')"
MSGt5="$(gettext 'Parameter expansion')"
MSGt6="$(gettext 'Parameter expansion in Bash, Ash and sh')"
MSGt7="$(gettext 'Online')"
MSGt8="$(gettext 'How Easy Works (technical)')"
MSGc1="$(gettext 'News, community')"
MSGc2="$(gettext 'Online')"

MSGx1="$(gettext 'How Easy works (user)')"
MSGx2="$(gettext 'How to install Easy OS on your hard drive')"
MSGy1="$(gettext 'Developer Blog')"
MSGy2="$(gettext 'Forum Discussion')"

NEWFILE="/usr/share/doc/easy/home_${xNEWLANG}.htm"
[ -f ${NEWFILE} ] && rm -f ${NEWFILE}

cat >> ${NEWFILE} <<_EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
 <meta http-equiv="content-type" content="text/html; charset=UTF-8">
 <title>EasyOS</title>
 <meta name="author" content="Barry Kauler">
 <meta name="description" content="easyos easy linux help puppy quirky distribution">
</head>
<body>
 <table cellspacing="2" cellpadding="2" border="0" width="640" align="center">
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
     ${MSGb3} <br>
     <h2>${MSGs1}</h2>
     <table cellspacing="0" cellpadding="2" border="1">
      <tbody>
       <tr>
        <td valign="top"><b>${MSGs2}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top"><b><a href="/usr/share/doc/easy/welcome.htm">${MSGs3}</a></b>
            </td>
            <td valign="top">${MSGs4}
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
       <tr>
        <td valign="top"><b>${MSGs5}</b>
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
             <b><a href="https://easyos.org/tech/how-easy-works.html">${MSGt8}</a></b>
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
      </tbody>
     </table>
     <h2>${MSGc1}</h2>
     <table cellspacing="0" cellpadding="2" border="1">
      <tbody>
       <tr>
        <td valign="top"><b>${MSGc2}</b>
        </td>
        <td valign="top">
         <table cellspacing="2" cellpadding="2" border="0" width="100%">
          <tbody>
           <tr>
            <td valign="top">
             <b><a href="http://bkhome.org/news/tag_easy.html">${MSGy1}</a></b>
            </td>
           </tr>
           <tr>
            <td valign="top">
             <b><a href="https://forum.puppylinux.com/viewforum.php?f=63">${MSGy2}</a></b>
            </td>
           </tr>
          </tbody>
         </table>
        </td>
       </tr>
      </tbody>
     </table>
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

ln -snf home_${xNEWLANG}.htm /usr/share/doc/easy/home.htm

#190302 previously, /usr/share/doc/home.htm had redirection to /usr/share/doc/easy/home.htm,
#which is a symlink. This sometimes broken, so put direct redirection...
PTNr="s%easy/home.*htm%easy/home_${xNEWLANG}.htm%"
sed -i -e "$PTNr" /usr/share/doc/home.htm

[ "$PARAM1" == "run" ] && exec defaultlocalbrowser /usr/share/doc/easy/home.htm

###END###
