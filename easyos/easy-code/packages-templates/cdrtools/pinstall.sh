#!/bin/sh

#151203 werewolf, growisofs wants genisoimage.
[ ! -e usr/bin/genisoimage ] && ln -s mkisofs usr/bin/genisoimage
[ ! -e usr/bin/wodim ] && ln -s cdrecord usr/bin/wodim
