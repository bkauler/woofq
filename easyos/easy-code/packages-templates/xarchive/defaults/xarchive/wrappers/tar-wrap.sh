#! /bin/bash
# tar-wrap.sh - bash tar wrapper for xarchive frontend
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

# modified by technosaurus for puppy 4.4a
# added lzma and xz and changed --use-compress-program={progs} -{ajJzZ}

#110808 rerwin: Change all redirections to stderr to be appends, to protect error log.
#200711 peebee: support zstd. ref: http://www.murga-linux.com/puppy/viewtopic.php?t=56651
#20220126 fix .tar.zst extraction.
#20230902 support void .xbps pkgs.

# set up exit status variables
E_UNSUPPORTED=65

# Supported file extentions for tar
TAR_EXTS="tar"
GZIP_EXTS="tar.gz tgz"
BZIP2_EXTS="tar.bz tbz tar.bz2 tbz2"
COMPRESS_EXTS="tar.z"
XZ_EXTS="tar.xz txz"
LZMA_EXTS="tar.lzma tar.lz tlz"
ZST_EXTS="tar.zstd tar.zst xbps" #200711 20230902

# Setup awk program
AWK_PROGS="mawk gawk awk"
AWK_PROG=""
for awkprog in $AWK_PROGS; do
    if [ "$(which $awkprog)" ]; then
        AWK_PROG="$awkprog"
        break
    fi
done

# Program to wrap
TAR_PROG="tar"

# setup variables opt and archive.
# the shifting will leave the files passed as
# all the remaining args "$@"
opt="$1"
shift 1
archive="$1"
shift 1

# set up compression variables for our compression functions. 
# translate archive name to lower case for pattern matching.
# use compressor -c option to output to stdout and direct it where we want
lc_archive="$(echo $archive|tr [:upper:] [:lower:])"
for ext in $GZIP_EXTS; do
    if [ $(expr "$lc_archive" : ".*\."$ext"$") -gt 0 ]; then
        DECOMPRESS="gzip -dc"
        COMPRESS="gzip -c"
        TAR_COMPRESS_OPT="-z"
    fi
done
for ext in $BZIP2_EXTS; do
    if [ $(expr "$lc_archive" : ".*\."$ext"$") -gt 0 ]; then
        DECOMPRESS="bzip2 -dc" 
        COMPRESS="bzip2 -c"
        TAR_COMPRESS_OPT="-j"
    fi
done
for ext in $COMPRESS_EXTS; do
    if [ $(expr "$lc_archive" : ".*\."$ext"$") -gt 0 ]; then
        DECOMPRESS="uncompress -dc" 
        COMPRESS="compress -c"
        TAR_COMPRESS_OPT="-Z"
    fi
done
for ext in $XZ_EXTS; do
    if [ $(expr "$lc_archive" : ".*\."$ext"$") -gt 0 ]; then
        DECOMPRESS="xz -dc"
        COMPRESS="xz -ze9c"
        TAR_COMPRESS_OPT="-J"
    fi
done
for ext in $LZMA_EXTS; do
    if [ $(expr "$lc_archive" : ".*\."$ext"$") -gt 0 ]; then
        DECOMPRESS="lzma -dc"
        COMPRESS="lzma -ze9c"
        TAR_COMPRESS_OPT="-a"
    fi
done
for ext in $ZST_EXTS; do #200711
    if [ $(expr "$lc_archive" : ".*\."$ext"$") -gt 0 ]; then
        DECOMPRESS="zstd -dc" #20220126 fix
        COMPRESS="zstd -vcf"
        TAR_COMPRESS_OPT="--zstd"
    fi
done

# Command line options for prog functions
# open and extract can use tar's cmd line option
# add, new, and remove need to decompress the tar first
# do their thing, than recompress the tar.
OPEN_OPTS="$TAR_COMPRESS_OPT -tvf"
EXTRACT_OPTS="$TAR_COMPRESS_OPT -xf"
ADD_OPTS="-rf"
NEW_OPTS="-cf"
REMOVE_OPTS="--delete -f"

# Compression functions
decompress_func()
{
    if [ "$DECOMPRESS" ]; then 
        tmpname="$(mktemp -t tartmp.XXXXXX)"
        if [ -f "$archive" ]; then 
            $DECOMPRESS "$archive" > "$tmpname" 
        fi
        # store old name for when we recompress
        oldarch="$archive"
        # change working file to decompressed tmp 
        archive="$tmpname"
    fi
}

compress_func()
{
    if [ "$COMPRESS" ] && [ "$oldarch" ]; then
        [ -f "$oldarch" ] && rm "$oldarch"
        if $COMPRESS "$archive" > "$oldarch"; then
            rm "$archive"
        fi
    fi
}

# the option switches
case "$opt" in
    -i) # info: output supported extentions for progs that exist
        if [ ! "$AWK_PROG" ]; then
            echo none of the awk programs $AWK_PROGS found >> /dev/stderr
            echo extentions $EXTS ignored >> /dev/stderr
        elif [ "$(which $TAR_PROG)" ]; then
            for ext in $TAR_EXTS; do
                printf "%s;" $ext
            done
            for ext in $GZIP_EXTS; do
                if [ "$(which gzip)" ]; then
                    printf "%s;" $ext
                else
                    echo gzip not found >> /dev/stderr 
                    echo extention $ext ignored >> /dev/stderr 
                fi
            done
            for ext in $XZ_EXTS; do
                if [ "$(which xz)" ]; then
                    printf "%s;" $ext
                else
                    echo xz not found >> /dev/stderr 
                    echo extention $ext ignored >> /dev/stderr 
                fi
            done
            for ext in $LZMA_EXTS; do
                if [ "$(which lzma)" ]; then
                    printf "%s;" $ext
                else
                    echo lzma not found >> /dev/stderr 
                    echo extention $ext ignored >> /dev/stderr 
                fi
            done            
            for ext in $BZIP2_EXTS; do
                if [ "$(which bzip2)" ]; then
                    printf "%s;" $ext
                else
                    echo bzip2 not found >> /dev/stderr 
                    echo extention $ext ignored >> /dev/stderr
                fi
            done
            for ext in $COMPRESS_EXTS; do
                if [ "$(which compress)" ] && [ "$(which uncompress)" ]; then
                    printf "%s;" $ext
                else
                    echo compress and uncompress not found >> /dev/stderr 
                    echo extention $ext ignored >> /dev/stderr
                fi
            done
            for ext in $ZST_EXTS; do
                if [ "$(which zstd)" ]; then
                    printf "%s;" $ext
                else
                    echo zstd not found >> /dev/stderr 
                    echo extention $ext ignored >> /dev/stderr
                fi
            done
        else
            echo command $TAR_PROG not found >> /dev/stderr 
            echo extentions $TAR_EXTS ignored >> /dev/stderr
        fi
        printf "\n"
        exit
        ;;

    -o) # open: mangle output of tar cmd for xarchive 
        # format of tar output:
# lrwxrwxrwx USR/GRP       0 2005-05-12 00:32:03 file -> /path/to/link
# -rw-r--r-- USR/GRP    6622 2005-04-22 12:29:14 file 
# 1          2          3    4          5        6
        $TAR_PROG $OPEN_OPTS "$archive" | $AWK_PROG '
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

    -a) # add to archive passed files
        # we only want to add the file's basename, not
        # the full path so...
        decompress_func
        while [ "$1" ]; do
            cd "$(dirname "$1")"
            $TAR_PROG $ADD_OPTS "$archive" "$(basename "$1")"
            wrapper_status=$?
            shift 1
        done
        compress_func
        exit $wrapper_status
        ;;

    -n) # new: create new archive with passed files 
        # create will only be passed the first file, the
        # rest will be "added" to the new archive
        decompress_func
        cd "$(dirname "$1")"
        $TAR_PROG $NEW_OPTS "$archive" "$(basename "$1")"
        wrapper_status=$?
        compress_func
        exit $wrapper_status
        ;;

    -r) # remove: from archive passed files 
        decompress_func
        $TAR_PROG $REMOVE_OPTS "$archive" "$@"
        wrapper_status=$?
        compress_func
        exit $wrapper_status
        ;;

    -e) # extract: from archive passed files 
        # xarchive will put is the right extract dir
        # so we just have to extract.
        $TAR_PROG $EXTRACT_OPTS "$archive" "$@" 
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
