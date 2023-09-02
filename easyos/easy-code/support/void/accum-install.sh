#!/bin/sh
#20230902 called from 3buildeasydistro

. /etc/DISTRO_SPECS
case "$DISTRO_TARGETARCH" in
 amd64) ARCH='x86_64' ;;
 *)     ARCH="$DISTRO_TARGETARCH" ;;
esac

I="$(find / -mindepth 1 -maxdepth 1 -type f -name 'INSTALL:*' | tr '\n' ' ')"

for aI in $I
do
 aNAME="$(echo -n "$aI" | cut -f 2 -d ':')"
 aVER="$(echo -n "$aI" | cut -f 3 -d ':')"
 LANG=C sh ${aI} post ${aNAME} ${aVER} no "" ${ARCH}
 rm -f /INSTALL:${aNAME}:${aVER}
done
