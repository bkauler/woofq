#!/bin/sh

if [ "$(pwd)" == "/" ];then
 popup 'level=top terminate=8 timecount=dn name=gimageread1 background=#ffdb80|<big>Install tesseract languages via PKGget. Packages are named tessdata-*</big>'
fi
