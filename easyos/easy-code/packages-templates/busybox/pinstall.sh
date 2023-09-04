#!/bin/sh

if [ "`pwd`" != "/" ];then
 #as busybox got installed second, it's 'sh' overwrote...
 ln -snf bash ./usr/bin/sh
fi
