
woofQ
-----

woofQ is a build system for creating EasyOS.

The build systems for Puppy Linux started back in the early 2000's, with the name "Puppy Unleashed", then became "Woof", then "Woof2". Circa 2013, Barry Kauler stepped down from leading the Puppy project and handed it over to the Puppy-community. Woof2 was forked to "Woof-CE", where the "CE" means "Community Edition".

Barry continued to work on an experimental distribution named "Quirky Linux", and created the woofQ build system for that, derived from Woof2.

In 2017, Barry started another experimental distribution, named "EasyOS", also built with woofQ.

Note that woofQ no longer has the ability to build a Puppy Linux or Quirky Linux. That backwards capability was removed on 2023-09-04.

woofQ, as per the other woof* build systems, is able to import binary packages from anywhere. For example, the binary packages of Void, Debian, Ubuntu, or Slackware, can be used.

Also, binary packages compiled from source by T2sde or OpenEmbedded/Yocto (OE) can be imported.

The current Scarthgap-series of EasyOS is built from packages compiled in OE, see the project here:

https://github.com/bkauler/oe-qky-scarthgap

The website for EasyOS:

https://easyos.org/

Prior to November 7, 2022, woofQ was only available as tarballs, not in a git repository:

https://distro.ibiblio.org/easyos/project/woofq/

Barry Kauler's news pages for woofQ and EasyOS:

https://bkhome.org/news/tag_easy.html


NOTES
-----

After downloading woofQ, you run 'merge2out' to setup the build environment.
The script requires path /mnt/build, and there is a script 'bind-mount-on-mnt-build' that binds /mnt/build to a mounted partition. The partition should have at least 30GB free space (and if you ever plan to build oe-qky-scarthgap, require 500GB free).
woofQ could probably be made to work with any host Linux distribution; however, currently only tested with EasyOS Scarthgap-series.
Further instruction is found at /mnt/build/builds/woof/*/README.txt


