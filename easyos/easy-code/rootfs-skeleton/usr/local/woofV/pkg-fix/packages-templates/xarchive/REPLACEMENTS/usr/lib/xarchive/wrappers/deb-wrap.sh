#! /bin/bash
# deb-wrap.sh - bash deb wrapper for xarchive frontend
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
#20210911 extract DEBIAN control files from deb.

# set up exit status variables
E_UNSUPPORTED=65

# Supported file extentions for tar 
EXTS="deb"

# Setup awk program
AWK_PROGS="mawk gawk awk"
AWK_PROG=""
for awkprog in $AWK_PROGS; do
    if [ "$(which $awkprog)" ]; then
        AWK_PROG="$awkprog"
        break
    fi
done

# Programs to wrap
DEB_PROG="dpkg-deb"
TAR_PROG="tar"

# setup variables opt and archive.
# the shifting will leave the files passed as
# all the remaining args "$@"
opt="$1"
shift 1
archive="$1"
shift 1


# Command line options for prog functions
# open and extract can use tar's cmd line option
# add, new, and remove need to decompress the tar first
# do their thing, than recompress the tar.
OPEN_OPTS="-c"
CONVERT_OPTS="--fsys-tarfile"
TAR_EXTRACT_OPTS="-xf"

# the option switches
case "$opt" in
    -i) # info: output supported extentions for progs that exist
        if [ ! "$AWK_PROG" ]; then
            echo none of the awk programs $AWK_PROGS found >> /dev/stderr
            echo extentions $EXTS ignored >> /dev/stderr
        elif [ ! "$(which $TAR_PROG)" ]; then
            echo $TAR_PROG required by $0, but not found >> /dev/stderr
            echo extentions $EXTS ignored >> /dev/stderr
        elif [ "$(which $DEB_PROG)" ]; then
            for ext in $EXTS; do
                printf "%s;" $ext
            done
        else
            echo program $DEB_PROG not found >> /dev/stderr 
            echo extentions $EXTS ignored >> /dev/stderr
        fi
        printf "\n"
        exit
        ;;

    -o) # open: mangle output of dpkg-deb cmd for xarchive 
        # format of output:
# lrwxrwxrwx USR/GRP       0 2005-05-12 00:32:03 file -> /path/to/link
# -rw-r--r-- USR/GRP    6622 2005-04-22 12:29:14 file 
# 1          2          3    4          5        6
        $DEB_PROG $OPEN_OPTS "$archive" | $AWK_PROG '
        {
          attr=$1
          split($2,ids,"/") #split up the 2nd field to get uid/gid
          uid=ids[1]
          gid=ids[2]
          size=$3
          date=$4
          time=$5
          
          #this method works with filenames that start with a space (evil!)
          #split line a time and a space
          split($0,linesplit, $5 " ")
          #then split the second item (name&link) at the space arrow space
          split(linesplit[2], nlsplit, " -> ")

          name=nlsplit[1]
          link=nlsplit[2]

          if (! link) {link="-"} #if there was no link set it to a dash

          printf "%s;%s;%s;%s;%s;%s;%s;%s\n",name,size,attr,uid,gid,date,time,link
        }'
        exit
        ;;

    -a) # adding to archive unsupported
        # use appropriate dpkg tools to build debs
        exit $E_UNSUPPORTED
        ;;

    -n) # create new archive unsupported 
        # use appropriate dpkg tools to build debs
        exit $E_UNSUPPORTED
        ;;

    -r) # removing from archive unsupported 
        # use appropriate dpkg tools to modify debs
        exit $E_UNSUPPORTED
        ;;

    -e) # extract: from archive passed files 
        # convert deb to a temporary tar file
        tmptar="$(mktemp -t tartmp.XXXXXX)"
        $DEB_PROG $CONVERT_OPTS "$archive" > "$tmptar"
        # extract files from the temporary tar
        $TAR_PROG $TAR_EXTRACT_OPTS "$tmptar" "$@"
        wrapper_status=$?
        #20210911 BK include control info in extraction...
        $DEB_PROG -e $archive DEBIAN
        # remove temporary tar
        rm "$tmptar"
        exit $wrapper_status
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
