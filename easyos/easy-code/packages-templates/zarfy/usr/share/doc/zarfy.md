# zarfy - a GUI front end for RandR >=1.2
[![License](http://img.shields.io/badge/license-GPLv3-blue.svg?colorB=9977bb&style=plastic)](https://github.com/rbtylee/zarfy/blob/master/LICENSE)
[![Build Status](https://travis-ci.com/rbtylee/zarfy.svg?branch=master)](https://travis-ci.com/rbtylee/zarfy)

This repository is a fork from Jim Allingham's [original](https://sourceforge.net/projects/zarfy/). Zarfy is Software Libre released under version 3 of the GPL.

The initial commit is based from version 0.1.0. Minor changes have been made since it would no longer build (ubuntu 18.04). Compiler warnings and run time errors were fixed.

## Features

A gui to libxrandr. It presents the user with visual representaion of active displays on an interactive map of
the screen memory. Features free postioning, configuration saving, scripting for R&R and an alternate gui for switching between monitors.

## Dependencies

*   The usual build tools, autopoint libtool intltool pkg-config  autotools-dev
*   gtk+-2.0
*   gdk-pixbuf
*   libglade
*   libxrandr
*   libxrender

For Debian & debian-based distros

```sudo apt install libgdk-pixbuf2.0-dev libglade2-dev libx11-dev libxrandr-dev libxrender-dev```

should do it.

## Installation
```ShellSession
./autogen.sh
make
sudo make install
```

## Usage

In  normal  mode (no command line options) a representation of the virtual screen area is displayed with each 
active output mapped  onto  it. To  position  an  output device, select it by clicking on it's thumb at the top of the
window, then click the map area where it should go. By default, the click is interpreted as "right-of", "beneath", 
etc., relative to the output nearest to the click. Alternately, free  positioning  can be done by clicking off the "snap-to" button.

Zarfy  saves  your  monitor configuration on apply/ok and automatically loads it on next run. For more information

```ShellSession
man zarfy
```

## Load & Exit Mode

Command: **zarfy -l**

Loads the last configuration and exits - no gui.
Can be used eg. to configure displays on startup:
system->preferences->sessions->startup programs->add zarfy -l

## Quick-Switch Mode

Command: **zarfy -s**

Lets you quickly switch between combinations of displays, simlar to
the Fn key function of a certain well-known propietary OS :)
Use the right & left arrow keys to step between combos, Enter to
select & exit. Or use the mouse - click to select, double click to
execute & exit.

The following sample script (Debian) may be tied to the appropriate
acpi Fn key. The first keystroke launches zarfy in switch mode,
successive keystrokes step thorough the possible combinations.

```Shell
#!/bin/bash
test -f /usr/share/acpi-support/power-funcs || exit 0
. /etc/default/acpi-support
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/key-constants

if pidof zarfy; then
	acpi_fakekey $KEY_RIGHT
else 
 for x in /tmp/.X11-unix/*; do
    displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
    getXuser;
    if [ x"$XAUTHORITY" != x"" ]; then
        export DISPLAY=":$displaynum.0"
	/usr/local/bin/zarfy -s &
    fi
 done
fi
```

## Scripting for Rotate//Reflect

Automate rotation/relection on your input device (eg. wacom).
Upon execution of rotate/reflect on a display, zarfy looks for
a script associated with that display and, if found, executes it
with one of the following arguments: "_rotate_none_", "_rotate_left_",
"_rotate_right_", "_rotate_180_", "_refect_x_", "_reflect_y_", "_unreflect_x_",
"_unreflect_y_". The script must be located in

> ~/$XDG_DATA_HOME/zarfy/<x_display_name>/ 
> or if XDG_DATA_HOME is undefined:
> ~/.local/share/zarfy/<x_display_name>/

and have the name <output_device>_RR.sh, where <output_device>
is the driver-specifc name of the device (eg Intel "LVDS", "VGA", etc).
Device names for your system are displayed under the thumbnails
at the top of the main zarfy window. The <x_display_name> for the
default display is created automatically the first time you run zarfy.

## Reporting bugs

Please use the GitHub issue tracker for any bugs or feature suggestions:

> <https://github.com/rbtylee/zarfy/issues>

## Contributing

Help is always Welcome, as with all Open Source Projects the more people that help the better it gets!
Adding support for translations and the translations themselves would be especially welcome and much needed.

Please submit patches to the code or documentation as GitHub pull requests!

Contributions must be licensed under this project's copyright (see LICENSE). 

## Credits

Full credit for the original code of this module go to:
*   _Jim Allingham supergring0@yahoo.com_

Additional modifications:
*   _Robert Wiley_
*   _[James Bond](http://chiselapp.com/user/jamesbond/repository/zarfy/home)_

## Links

For more information on RandR, what cards/drivers are supported,
how to set up your xorg.conf, etc.

*   <http://wiki.debian.org/XStrikeForce/HowToRandR12>
*   <http://www.thinkwiki.org/wiki/Xorg_RandR_1.2>
*   <http://www.x.org/wiki/Projects/XRandR>
*   [Where is the X.org config file?](https://askubuntu.com/questions/4662/where-is-the-x-org-config-file-how-do-i-configure-x-there)
