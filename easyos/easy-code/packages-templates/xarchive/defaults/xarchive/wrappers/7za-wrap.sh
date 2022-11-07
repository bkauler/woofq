#! /bin/bash
# 7za-wrap.sh - bash 7za wrapper for xarchive frontend
# Copyright (C) 2005 Michael Shigorin <mike@altlinux.org> 
# based on zip-wrap.sh (C) 2005 Lee Bigelow <ligelowbee@yahoo.com>
# and p7zip mcextfs (C) 2004 Sergiy Niskorodov (sgh ukrpost net)
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
#140219 SFR: don't attempt to process 7z archives with encrypted headers, to prevent _total_ crash!

# set up exit status variables
E_UNSUPPORTED=65

# Supported file extentions for 7za
EXTS="7z"

# Programs to wrap
P7Z_PROG="7za"

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
# all the remaining args: "$@"
opt="$1"
shift 1
archive="$1"
shift 1

# Command line options for prog functions
NEW_OPTS="a -ms=off"
ADD_OPTS="a -ms=off"
REMOVE_OPTS="d"
OPEN_OPTS="l"
EXTRACT_OPTS="x -y -p-"
PASS_EXTRACT_OPTS="x -y"

# the option switches
case "$opt" in
    -i) # info: output supported extentions for progs that exist
        if [ ! "$AWK_PROG" ]; then
            echo none of the awk programs $AWK_PROGS found >> /dev/stderr
            echo extentions $EXTS ignored >> /dev/stderr
        elif [ "$(which $P7Z_PROG)" ]; then
            for ext in $EXTS; do
                printf "%s;" $ext
            done
        else
            echo command $P7Z_PROG not found >> /dev/stderr 
            echo extentions $EXTS ignored >> /dev/stderr
        fi
        printf "\n"
        exit
        ;;

    -o) # open: mangle output of 7za cmd for xarchive 
        # format of 7za output:
	# ------------------- ----- ------------ ------------  ------------
	# 1992-04-12 11:39:46 ....A          356               ANKETA.FRG
    
    # SFR: exit if header is encrypted
    $P7Z_PROG l -p- "$archive" >/dev/null
    if [ $? -ne 0 ]; then
      xmessage -center -title "Xarchive" "The archive seems to be corrupted or its header is encrypted.
7z and rar archives with encrypted headers are not supported."
      kill `ps | grep "xarchive $archive" | grep -v grep | awk '{print $1}'`
      exit 1
    fi
    
	$P7Z_PROG $OPEN_OPTS "$archive" | $AWK_PROG -v uuid=${UID-0} '
	BEGIN { flag=0; }
	/^-------/ { flag++; if (flag > 1) exit 0; next }
	{
		if (flag == 0) next

		year=substr($1, 1, 4)
		month=substr($1, 6, 2)
		day=substr($1, 9, 2)
		time=substr($2, 1, 5)

		if (index($3, "D") != 0) {attr="drwxr-xr-x"}
		else if (index($3, ".") != 0) {attr="-rw-r--r--"}

		size=$4

		$0=substr($0, 54)
		if (NF > 1) {name=$0}
		else {name=$1}
		gsub(/\\/, "/", name)

		printf "%s;%d;%s;%d;%d;%d-%02d-%02d;%s;-\n", name, size, attr, uid, 0, year, month, day, time
	}'
	exit
	;;

    -a) # add:  to archive passed files
        # we only want to add the file's basename, not
        # the full path so...
        while [ "$1" ]; do
            cd "$(dirname "$1")"
            $P7Z_PROG $ADD_OPTS "$archive" "$(basename "$1")"
            wrapper_status=$?
            shift 1
        done
        exit $wrapper_status
        ;;

    -n) # new: create new archive with passed files 
        # create will only be passed the first file, the
        # rest will be "added" to the new archive
        cd "$(dirname "$1")"
        $P7Z_PROG $NEW_OPTS "$archive" "$(basename "$1")"
        exit
        ;;

    -r) # remove: from archive passed files 
    	wrapper_status=0
    	while [ "$1" ]; do
		$P7Z_PROG $OPEN_OPTS "$archive" 2>/dev/null \
		| grep -q "[.][/]" >&/dev/null && EXFNAME=*./"$1" || EXFNAME="$1"
		$P7Z_PROG $REMOVE_OPTS "$archive" "$EXFNAME" 2>&1 \
		| grep -q E_NOTIMPL &> /dev/null && {
			echo -e "Function not implemented: 7z cannot delete files from solid archive." >&2
			wrapper_status=$E_UNSUPPORTED
		}
		shift 1;
	done
        exit $wrapper_status
        ;;

    -e) # extract: from archive passed files 
        # xarchive will put is the right extract dir
        # so we just have to extract.
        $P7Z_PROG $EXTRACT_OPTS "$archive" "$@"
        if [ "$?" -ne "0" ] && [ "$XTERM_PROG" ]; then
            echo Probably password protected,
            echo Opening an x-terminal...
            $XTERM_PROG -e $P7Z_PROG $PASS_EXTRACT_OPTS "$archive" "$@"
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
