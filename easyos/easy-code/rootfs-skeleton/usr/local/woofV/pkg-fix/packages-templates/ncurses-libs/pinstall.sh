#!/bin/sh

if [ -e usr/lib/libncursesw.so.6 ];then
 ln -s libncurses.so.6 usr/lib/libncurses.so.5 2>/dev/null
 ln -s libncursesw.so.6 usr/lib/libncursesw.so.5 2>/dev/null
 ln -s libtinfo.so.6 usr/lib/libtinfo.so.5 2>/dev/null
fi
