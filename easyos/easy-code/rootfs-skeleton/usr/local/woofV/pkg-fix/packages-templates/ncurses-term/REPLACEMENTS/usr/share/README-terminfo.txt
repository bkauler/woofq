This cutdown 'terminfo' folder is from Puppy 2.17, an earlier ncurses
package.

I tried the same cutdown selection -- or similar -- in ncurses v5.6 used
in RawPup but color was missing when ran 'mp' and 'dialog' in rxvt
terminal (but not when run before X started -- got color then). Probably
cold have fixed it, maybe just missing a file, but took easy way out.
(that is, sticking with these old files)

----------------------
dec 7, 2014

have added rxvt-unicode-256color, symlink to rxvt.
got a fail with 'firewallinstall' script, with error that terminal type is
missing, but when tried script later, it worked.
adding this symlink anyway.
