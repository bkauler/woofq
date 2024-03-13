#!/bin/sh

#we are using the kirkstone libcap, in kirkstone-libs pet pkg...
if [ -f usr/lib/libcap.so.2.66 ];then
 ln -snf libcap.so.2.66 usr/lib/libcap.so.2
 ln -snf libcap.so.2.66 usr/lib/libcap.so.1
fi
if [ -f usr/lib/libpsx.so.2.66 ];then
 ln -snf libpsx.so.2.66 usr/lib/libpsx.so.2
 ln -snf libpsx.so.2.66 usr/lib/libpsx.so.1
fi
