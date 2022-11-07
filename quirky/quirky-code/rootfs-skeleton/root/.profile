#120221 moved this code here from /etc/profile, also take 'exec' prefix off call to xwin.
#140209 /var/local/quicksetup-test-success written in quicksetup, for forced run xorgwizard-cli.
#161009 now have "Reboot to commandline" in Shutdown menu. ref: /etc/xdg/templates/_root_.jwmrc and /usr/bin/wmreboot

if [ ! -f /usr/bin/X ];then
 #v2.00r1 now support a text-mode-only puppy...
 if [ -f /usr/local/bin/elinks ];then
  if [ ! -f /tmp/bootcnt.txt ];then
   touch /tmp/bootcnt.txt
   #exec /usr/local/bin/elinks file:///usr/share/doc/index.html
   #/usr/local/bin/elinks file:///usr/share/doc/index.html & #110804 110807
   /usr/local/bin/elinks file:///usr/share/doc/index.html
  fi
 else
  echo
  echo "\\033[1;31mSorry, cannot start X. Link /usr/bin/X missing."
  echo -n "(suggestion: type 'xorgwizard' to run the Xorg Video Wizard)"
  echo -e "\\033[0;39m"
 fi
else
 if [ -s /var/local/quicksetup-test-success ];then #140209 /usr/sbin/quicksetup writes to this file.
  rm -f /root/.XLOADED #140209 avoid clash with this mechanism, see /usr/bin/xwin
  xorgwizard-cli
 fi
 if [ -f /root/bootcnt.txt ];then #161009 created by /usr/bin/wmreboot
  mv -f /root/bootcnt.txt /tmp/bootcnt.txt
  echo 'Type "xwin" to start X server'
 fi
 #want to go straight into X on bootup only...
 if [ ! -f /tmp/bootcnt.txt ];then
  touch /tmp/bootcnt.txt
  # aplay -N /usr/share/audio/bark.au
  dmesg > /tmp/bootkernel.log
  #exec xwin
  #xwin & #110804 110807
  xwin
 fi
fi
