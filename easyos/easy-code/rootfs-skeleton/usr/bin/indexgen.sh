#!/bin/bash
#(c) Copyright Barry Kauler 2009, puppylinux.com.
#2009 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html)
#generates index.html master help page. called from petget, rc.update,
#  /usr/local/petget/installpreview.sh, 3builddistro (in Woof).
#w012 commented-out drop-down for all installed pkgs as too big in Ubuntu-Puppy.
#w016 support/find_homepages (in Woof) used to manually update HOMEPAGEDB variable.
#w019 now have /root/.packages/PKGS_HOMEPAGES
#w464 reintroduce dropdown help for all builtin packages.
#v423 file PKGS_HOMEPAGES is now a db of all known pkgs, not just in puppy.
#120225 copy from raw doc files.
#131209 Packages-puppy- files renamed to Packages-pet-
#131214 fix for substitutions in index.html.bottom
#140204 fix substitutions in index.html.top. see also rootfs-skeleton/pinstall.sh
#170807 no longer have /usr/share/doc/index.html
#170823 no longer need to edit home.htm

export LANG=C
. /etc/DISTRO_SPECS #has DISTRO_BINARY_COMPAT, DISTRO_COMPAT_VERSION, DISTRO_PUPPYDATE
. /root/.packages/DISTRO_PKGS_SPECS

WKGDIR="`pwd`"

#170823
#170807 no longer have index.html
##120225 this is done in Woof by rootfs-skeleton/pinstall.sh, but do need to do it
##here to support language translations (see /usr/share/sss/doc_strings)...
# cp -f /usr/share/doc/home-raw.htm /usr/share/doc/home.htm
#
# cutDISTRONAME="`echo -n "$DISTRO_NAME" | cut -f 1 -d ' '`"
# cPATTERN="s/cutDISTRONAME/${cutDISTRONAME}/g"
# RIGHTVER="$DISTRO_VERSION"
# dPATTERN="s/PUPPYDATE/${DISTRO_PUPPYDATE}/g"
# PATTERN1="s/RIGHTVER/${RIGHTVER}/g"
# PATTERN2="s/DISTRO_VERSION/${DISTRO_VERSION}/g"
# nPATTERN="s/DISTRO_NAME/${DISTRO_NAME}/g"
# PATTERN9="s/DISTRO_FILE_PREFIX/${DISTRO_FILE_PREFIX}/g" #140204
# 
# sed -i -e "$nPATTERN" /usr/share/doc/home.htm


###END###
