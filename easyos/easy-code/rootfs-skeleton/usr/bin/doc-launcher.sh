#!/bin/sh
#called from surfer hyperlink exec:/usr/share/doc/easy/*/help.htm

#note, refer to original /usr/sbin/indexgen.sh, see how dropdown lists are created.

export TEXTDOMAIN=doclauncher
export OUTPUT_CHARSET=UTF-8


#search .desktop files...
MENUAPPSITEMS="$(ls -1 /usr/share/applications | sed -e 's%^%/usr/share/applications/%' | xargs cat - | grep '^Name=' | cut -f 2 -d '=' | sort | sed -e 's%^%<item>%' -e 's%$%</item>%')"
#...normal format of each entry is 'name description', ex: 'Geany text editor'.

#all packages...
ALLPKGSITEMS_A2K="$(cut -f 1 -d ' ' /root/.packages/PKGS_HOMEPAGES | sort | grep '^[a-eA-E]' | sed -e 's%^%<item>%' -e 's%$%</item>%')"
grep -i -o '^a[^ ]*' /root/.packages/PKGS_HOMEPAGES > /tmp/doc-launcher-alpha


export DOCLAUNCHER_DLG="<window title=\"$(gettext 'Easy Doc Launcher')\" icon-name=\"gtk-about\" window_position=\"1\">
 <vbox>
   <text><label>$(gettext 'The pulldown menus provide easy access to local and online documentation of applications and utilities')</label></text>
   
   <frame $(gettext 'Menu apps')>
     <text><label>$(gettext 'Applications available in the desktop menu:')</label></text>
     <hbox>
     <comboboxtext>
       <variable>COMBOMENUAPP</variable>
       ${MENUAPPSITEMS}
     </comboboxtext>
     <button>
       <label>$(gettext 'OK')</label>
       <action>pman \${COMBOMENUAPP/ */} & </action>
     </button>
     </hbox>
   </frame>
   
   <frame $(gettext 'All packages')>
     <text><label>$(gettext 'Complete list of packages (in Easy or not):')</label></text>
     <hbox>
     <comboboxtext>
       <variable>COMBOALPHA</variable>
       <item>a</item>
       <item>b</item>
       <item>c</item>
       <item>d</item>
       <item>e</item>
       <item>f</item>
       <item>g</item>
       <item>h</item>
       <item>i</item>
       <item>j</item>
       <item>k</item>
       <item>l</item>
       <item>m</item>
       <item>n</item>
       <item>o</item>
       <item>p</item>
       <item>q</item>
       <item>r</item>
       <item>s</item>
       <item>t</item>
       <item>u</item>
       <item>v</item>
       <item>w</item>
       <item>x</item>
       <item>y</item>
       <item>z</item>
       <action>grep -i -o ^\${COMBOALPHA}'[^ ]*' /root/.packages/PKGS_HOMEPAGES > /tmp/doc-launcher-alpha</action>
       <action type=\"refresh\">COMBOPKG</action>
     </comboboxtext>
     
     <comboboxtext>
       <variable>COMBOPKG</variable>
       <input file>/tmp/doc-launcher-alpha</input>
     </comboboxtext>
     <button>
       <label>$(gettext 'OK')</label>
       <action>grep ^\${COMBOPKG}' ' /root/.packages/PKGS_HOMEPAGES > /tmp/doc-pkg-from-all-list</action>
       <action>defaultbrowser \$(cat /tmp/doc-pkg-from-all-list | cut -f 2 -d ' ') & </action>
     </button>
     </hbox>
   </frame>
   
   <frame $(gettext 'Executables')>
     <text><label>$(gettext 'Type the name of any executable:')</label></text>
     <hbox>
       <entry>
         <variable>EXENAME</variable>
       </entry>
       <button>
         <label>$(gettext 'OK')</label>
         <action>pman \${EXENAME} & </action>
       </button>
     </hbox>
   </frame>

   <hbox>
     <button>
       <input file stock=\"gtk-quit\"></input>
       <label>$(gettext 'Exit')</label>
     </button>
   </hbox>
 </vbox>
 </window>"

RETVARS="$(gtkdialog --program=DOCLAUNCHER_DLG)"
