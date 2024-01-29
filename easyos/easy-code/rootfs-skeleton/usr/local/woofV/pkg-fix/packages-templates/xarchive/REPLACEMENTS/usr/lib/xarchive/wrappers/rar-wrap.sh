#! /bin/bash
# rar-wrap.sh - bash rar wrapper for xarchive
# Copyright (C) 2005 Lee Bigelow <ligelowbee@yahoo.com> 
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#110808 rerwin: Change all redirections to stderr to be appends, to protect error log.

# set up exit status variables
E_UNSUPPORTED=65

# Supported file extentions for rar 
EXTS="rar cbr"

# Program to wrap
if [ "$(which rar)" ]; then
    RAR_PROG="rar"
else
    RAR_PROG="unrar"
fi

# Setup awk program to use
AWK_PROGS="mawk gawk awk"
AWK_PROG=""
for awkprog in $AWK_PROGS; do
    if [ "$(which $awkprog)" ]; then
        AWK_PROG="$awkprog"
        break
    fi
done

# Setup xterm program to use
XTERM_PROGS="xterm rxvt xvt wterm aterm Eterm"
XTERM_PROG=""
for xtermprog in $XTERM_PROGS; do
    if [ "$(which $xtermprog)" ]; then
        XTERM_PROG="$xtermprog"
        break
    fi
done

# setup variables opt and archive.
# the shifting will leave the files passed as
# all the remaining args "$@"
opt="$1"
shift 1
archive="$1"
shift 1

# Command line options for prog functions
# disable comments when opening
OPEN_OPTS="v -c-"
ADD_OPTS="a"
NEW_OPTS="a"
REMOVE_OPTS="d"
EXTRACT_OPTS="x -o- -p-"
PASS_EXTRACT_OPTS="x -o-"

# the option switches
case "$opt" in
    -i) # info: output supported extentions for progs that exist
        if [ ! "$AWK_PROG" ]; then
            echo none of the awk programs $AWK_PROGS found >> /dev/stderr
            echo extentions $EXTS ignored >> /dev/stderr
        elif [ "$(which $RAR_PROG)" ]; then
            for ext in $EXTS; do
                printf "%s;" $ext
            done
        else
            echo command $RAR_PROG not found >> /dev/stderr 
            echo extentions $EXTS ignored >> /dev/stderr 
        fi
        printf "\n"
        exit
        ;;

    -o) # open: mangle output of rar cmd for xarchive 
        # format of rar output:
#-------------------------------------
# bookmarks/mozilla_bookmarks.html
#            11512     5231  45% 28-02-05 16:19 -rw-r--r-- F3F3477F m3b 2.9
#       (or  11512     5231  45% 28-02-05 16:19 .D....     00000000 m3b 2.9)
#       (or  11512     5231  45% 28-02-05 16:19 .....S     F3F3477F m3b 2.9)
#            1         2     3   4        5     6          7        8   9
#-------------------------------------
        
        $RAR_PROG $OPEN_OPTS "$archive" | $AWK_PROG -v uuid=${UID} '
        # The body of info we wish to process starts with a dashed line 
        # so set a flag to signal when to start and stop processing.
        # The name is on one line with the info on the next so toggle
        # a line flag letting us know what kinda info to get.  
        BEGIN { flag=0; line=0 }
        /^------/ { flag++; if (flag > 1) exit 0; next} #line starts with dashs
        {
          if (flag == 0) next #not in the body yet so grab the next line
          if (line == 0) #this line contains the name
          { 
            name=substr($0,2) #strip the single space from start of name
            line++  #next line will contain the info so increase the flag
            next
          }
          else #we got here so this line contains the info
          {
            size=$1
            date=$4
            time=$5
            
            #modify attributes to read more unix like if they are not
            if (index($6, "D") != 0) {attr="drwxr-xr-x"}
            else if (index($6, ".") != 0) {attr="-rw-r--r--"}
            else {attr=$6}

            uid=uuid
            gid=uuid
            link="-"

            printf "%s;%s;%s;%s;%s;%s;%s;%s\n",name,size,attr,uid,gid,date,time,link
            line=0 #next line will be a name so reset the flag
          }
        }'
        exit
        ;;

    -a) # add:  to archive passed files
        # we only want to add the file's basename, not
        # the full path so...
        if [ "$RAR_PROG" = "unrar" ]; then
            exit $E_UNSUPPORTED
        fi
        while [ "$1" ]; do
            cd "$(dirname "$1")"
            $RAR_PROG $ADD_OPTS "$archive" "$(basename "$1")"
            wrapper_status=$?
            shift 1
        done
        exit $wrapper_status
        ;;

    -n) # new: create new archive with passed files 
        # create will only be passed the first file, the
        # rest will be "added" to the new archive
        if [ "$RAR_PROG" = "unrar" ]; then
            exit $E_UNSUPPORTED
        fi
        cd "$(dirname "$1")"
        $RAR_PROG $NEW_OPTS "$archive" "$(basename "$1")"
        exit
        ;;

    -r) # remove: from archive passed files 
        if [ "$RAR_PROG" = "unrar" ]; then
            exit $E_UNSUPPORTED
        fi
        $RAR_PROG $REMOVE_OPTS "$archive" "$@"
        exit
        ;;

    -e) # extract: from archive passed files 
        # xarchive will put is the right extract dir
        # so we just have to extract.
        $RAR_PROG $EXTRACT_OPTS "$archive" "$@"
        if [ "$?" -ne "0" ] && [ "$XTERM_PROG" ]; then
            echo Probably password protected,
            echo Opening an x-terminal...
            $XTERM_PROG -e $RAR_PROG $PASS_EXTRACT_OPTS "$archive" "$@"
        fi
        exit
        ;;

     *) echo "error, option $opt not supported"
        echo "use one of these:" 
        echo "-i                #info" 
        echo "-o archive        #open" 
        echo "-a archive files  #add" 
        echo "-n archive file   #new" 
        echo "-r archive files  #remove" 
        echo "-e archive files  #extract" 
        exit
esac
