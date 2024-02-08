#!/bin/ash
#most xbps pkgs will install directly, however if 2nd field in DISTRO_PKGS_SPECS
#is a match with a directory in packagaes-templates, then apply the fixes.

#expand the .xbps pkg to a folder, apply fixes, then recreate the .xbps
# with dir2xbps?
#or maybe not, can we register the .xbps as installed, and manually install the
# fixed folder?

#even better, is it possible to apply the fixes after having installed the .xbps pkg?
# no need for intermediate expansion.

#suggest do it this way...
#come here before install .xbps pkg
#expand or list contents of pkg, find any matches already in target; backup
#install the pkg.
#if any file/folder deleted, do so, and if in backup, copy back in.

#or, find all files/folders already in rootfs, remove to backup
#install pkg.
#any files/folders deleted, copy from backup.