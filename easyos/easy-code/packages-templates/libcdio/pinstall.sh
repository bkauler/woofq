#!/bin/sh

#20151114
#werewolf: package 'libcdio' replaces 'cdparanoia', however executable is named differently:
[ ! -e usr/bin/cdparanoia ] && ln -s cd-paranoia usr/bin/cdparanoia
