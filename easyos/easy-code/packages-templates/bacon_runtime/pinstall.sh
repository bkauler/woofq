#!/bin/sh

#note to developers: the runtime HUG library is /usr/lib/hug.so
#make sure that the DEV package, file hug_imports.bac specifies: CONST HUG_lib$ = "/usr/lib/hug.so"

#the gtksourceview template in Woof has (or should have) latest bacon.lang,
#however bacon is getting upgraded often. To ensure latest bacon.lang is in
#appropriate place, do this:

if [ -d usr/share/gtksourceview-2.0/language-specs ];then
 cp -f -a usr/share/BaCon/bacon.lang usr/share/gtksourceview-2.0/language-specs/
 #110707 this is needed by bacongui... 130120 don't think need anymore... 130204 yes do...
 mkdir -p root/.local/share/gtksourceview-2.0/language-specs
 ln -s /usr/share/gtksourceview-2.0/language-specs/bacon.lang root/.local/share/gtksourceview-2.0/language-specs/bacon.lang
fi

#do same for vim...
if [ -d root/.vim ];then
 mkdir -p root/.vim/syntax
 cp -f -a usr/share/BaCon/bacon.vim root/.vim/syntax/
 if [ ! -e root/.vim/ftdetect/bacon.vim ];then
  mkdir -p root/.vim/ftdetect
  echo 'au BufRead,BufNewFile *.bac     set filetype=bacon' > root/.vim/ftdetect/bacon.vim
 fi
fi
