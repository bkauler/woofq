
0bKernel boot parameters07
For boot options, type0d BOOTLABEL07 then a space, then each option. Some options:

0dacpi=off07     Default on for PCs >2001, may give boot/shutdown probs.
0dqfix=nox07     Commandline only, do not start X (graphical desktop),
0dqfix=fsck07    do filesystem check,
0dqfix=bak07     system rollback, see Quirky Snapshot Manager, Filesystem menu.

More help here: http://kernel.org/doc/Documentation/kernel-parameters.txt

Examples: 
0dBOOTLABEL acpi=off qfix=nox07  Ignore ACPI, do not start X.
0dBOOTLABEL qfix=fsck,nox07      Filesystem check, do not start X.

0cDESKTOP FAIL: Black-screen/hangs, press reset or hold power-button down 4 secs:
next bootup will force run of Video Wizard: choose alternate driver/settings.07
