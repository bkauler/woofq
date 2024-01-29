#! /bin/bash
# ace-wrap.sh - bash unace wrapper for xarchive 
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

# Supported file extentions for ace 
EXTS="ace"

# Program to wrap
ACE_PROG="unace"

# Setup awk program
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
ADD_OPTS=""
NEW_OPTS=""
REMOVE_OPTS=""
EXTRACT_OPTS="x -o -y"

# the option switches
case "$opt" in
    -i) # info: output supported extentions for progs that exist
        if [ "$(which $ACE_PROG)" ]; then
            for ext in $EXTS; do
                printf "%s;" $ext
            done
        else
            echo command $ACE_PROG not found >> /dev/stderr 
            echo extentions $EXTS ignored >> /dev/stderr 
        fi
        printf "\n"
        exit
        ;;

    -o) # open: mangle output of ace cmd for xarchive 
        # format of ace output:
        # Date    ³Time ³Packed     ³Size     ³Ratio³File
        # 17.09.02³00:32³     394116³   414817³  95%³ OggDS0993.exe 
	# 1                   2         3        4    5
	$ACE_PROG $OPEN_OPTS "$archive" | $AWK_PROG -v uuid=${UID} '
        #only process lines starting with two numbers and a dot
        /^[0-9][0-9]\./ {
          date=substr($1,1,8)
          time=substr($1,10,5)
          #need to strip the funky little 3 off the end of size
          size=substr($3,1,(length($3)-1))
          
          #split line at ratio and a space, second item is our name
          split($0, linesplit, ($4 " "))
          name=linesplit[2]
          
          uid=uuid; gid=uuid; link="-"; attr="-"
          printf "%s;%s;%s;%s;%s;%s;%s;%s\n",name,size,attr,uid,gid,date,time,link
        }'
	exit
        ;;

    -a) # add:  to archive passed files
        # we only want to add the file's basename, not
        # the full path so...
        # ONY HAVE UNACE, no adding...
        # while [ "$1" ]; do
        #     cd "$(dirname "$1")"
        #     $ACE_PROG $ADD_OPTS "$archive" "$(basename "$1")"
        #     shift 1
        # done
        exit $E_UNSUPPORTED 
        ;;

    -n) # new: create new archive with passed files 
        # create will only be passed the first file, the
        # rest will be "added" to the new archive
        # ONY HAVE UNACE, no creating...
        # cd "$(dirname "$1")"
        # $ACE_PROG $NEW_OPTS "$archive" "$(basename "$1")"
        exit $E_UNSUPPORTED 
        ;;

    -r) # remove: from archive passed files 
        # ONY HAVE UNACE, no removing...
        # $ACE_PROG $REMOVE_OPTS "$archive" "$@"
        exit $E_UNSUPPORTED 
        ;;

    -e) # extract: from archive passed files 
        # xarchive will put is the right extract dir
        # so we just have to extract.
        $XTERM_PROG -e $ACE_PROG $EXTRACT_OPTS "$archive"
        exit
        ;;

    -v) # view: from archive passed files 
        exit $E_UNSUPPORTED
        ;;

     *) echo "error, option $opt not supported"
        echo "use one of these:" 
        echo "-i                #info" 
        echo "-o archive        #open" 
        echo "-a archive files  #add" 
        echo "-n archive file   #new" 
        echo "-r archive files  #remove" 
        echo "-e archive files  #extract" 
        echo "-v archive file   #view"  
        exit
esac
