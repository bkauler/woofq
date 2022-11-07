#! /bin/bash
# arj-wrap.sh - bash arj wrapper for xarchive frontend
# Copyright (C) 2005 Michael Shigorin <mike@altlinux.org> 
# based on zip-wrap.sh Copyright (C) 2005 Lee Bigelow <ligelowbee@yahoo.com>
# and uarj mcextfs by Viatcheslav Odintsov (2:5020/181)
#                  (C) 2002 ARJ Software Russia.
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

# Supported file extentions for arj
EXTS="arj"

# Programs to wrap
#ARJ_PROG="arj -+ -ja1 -r"
ARJ_PROG="arj" #110808 Exclude bogus options

# Awk program to use
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
# all the remaining args: "$@"
opt="$1"
shift 1
archive="$1"
shift 1

# Command line options for prog functions
NEW_OPTS="a"
ADD_OPTS="a"
REMOVE_OPTS="d"
OPEN_OPTS="v"
EXTRACT_OPTS="x -y"
PASS_EXTRACT_OPTS="x -y -g?"

# the option switches
case "$opt" in
    -i) # info: output supported extentions for progs that exist
        if [ ! "$AWK_PROG" ]; then
            echo none of the awk programs $AWK_PROGS found >> /dev/stderr
            echo extentions $EXTS ignored >> /dev/stderr
        elif [ "$(which $ARJ_PROG)" ]; then
            for ext in $EXTS; do
                printf "%s;" $ext
            done
        else
            echo command $ARJ_PROG not found >> /dev/stderr 
            echo extentions $EXTS ignored >> /dev/stderr
        fi
        printf "\n"
        exit
        ;;

    -o) # open: mangle output of arj cmd for xarchive 
        # format of arj output:
        # 001) ANKETA.FRG
        #   3 MS-DOS          356        121 0.340 92-04-12 11:39:46                  1  
        
	$ARJ_PROG $OPEN_OPTS "$archive" | $AWK_PROG -v uuid=${UID-0} '{ 
		if (($0 ~ /^[0-9]+\) .*/)||($0 ~ /^------------ ---------- ---------- -----/)){
			if (filestr ~ /^[0-9]+\) .*/) {
				printf "%s;%d;%s;%d;%d;%02d-%02d-%02d;%02d:%02d;%s\n", file, size, perm, uid, gid, date[1], date[3], date[2], time[1], time[2], symfile
				perm=""
				file=""
				symfile=""
				filestr=""
			}
		}

		if ($0 ~ /^[0-9]+\) .*/) {
			filestr=$0
			sub(/^[0-9]*\) /, "")
			file=$0
			uid=uuid
			gid=0
		}

		if ($0 ~ /^.* [0-9]+[\t ]+[0-9]+ [0-9]\.[0-9][0-9][0-9] [0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].*/) {
			size=$3
			split($6, date, "-")
			split($7, time, ":")
			if ($8 ~ /^[rwx-]/) {perm=$8;} else {perm="-rw-r--r--"}
		}

		if ($0 ~ /^[\t ]+SymLink -> .*/) {
			symfile = $3
			perm="l"substr(perm, 2)
		} else {symfile="-"}

		if ($0 ~ /^[\t ]+Owner: UID [0-9]+\, GID [0-9]+/) {
			uid=$3
			gid=$5
			owner=1
		}
	}'
	exit
	;;

    -a) # add:  to archive passed files
        # we only want to add the file's basename, not
        # the full path so...
        while [ "$1" ]; do
            cd "$(dirname "$1")"
            $ARJ_PROG $ADD_OPTS "$archive" "$(basename "$1")"
            wrapper_status=$?
            shift 1
        done
        exit
        ;;

    -n) # new: create new archive with passed files 
        # create will only be passed the first file, the
        # rest will be "added" to the new archive
        cd "$(dirname "$1")"
        $ARJ_PROG $NEW_OPTS "$archive" "$(basename "$1")"
        exit
        ;;

    -r) # remove: from archive passed files 
        $ARJ_PROG $REMOVE_OPTS "$archive" "$@"
        exit
        ;;

    -e) # extract: from archive passed files 
        # xarchive will put is the right extract dir
        # so we just have to extract.
        $ARJ_PROG $EXTRACT_OPTS "$archive" "$@"
        if [ "$?" -ne "0" ] && [ "$XTERM_PROG" ]; then
            echo Probably password protected,
            echo Opening an x-terminal...
            $XTERM_PROG -e $ARJ_PROG $PASS_EXTRACT_OPTS "$archive" "$@"
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
