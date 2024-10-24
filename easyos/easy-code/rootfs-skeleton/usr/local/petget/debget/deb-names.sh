#!/bin/bash
#create a file that has generic name followed by debian split pkgs.
#running this in easy daedalus. but also have scarthgap oe pkg db in /root/.packages
#generate lines:
# oe-pkg-name|deb-generic-name|,split-pkg,...

echo -n '' > deb-gen-split-names
for aP in $(cut -f 2,7 -d '|' /root/.packages/Packages-devuan-daedalus-*)
do
 [ -z "$aP" ] && continue
 #ex: libperl4caml-ocaml-doc|pool/DEBIAN/main/p/perl4caml
 echo -n '.'
 Fp="${aP/|*/}"
 Fg="${aP/*|/}"
 Fg="${Fg##*/}"
 case "$Fp" in
  *-cross) continue ;;
  #*-dev) continue ;;  
 esac
 grep -q -F ",${Fp}," deb-gen-split-names
 if [ $? -ne 0 ];then
  grep -q -F "|${Fg}|" deb-gen-split-names
  if [ $? -eq 0 ];then
   #append split name...
   xFg="$(echo -n "${Fg}" | sed -e 's%\.%\\.%g')"
   sed -i -e "s%\(.*|${xFg}|.*\)%\1,${Fp},%" deb-gen-split-names
  else
   #find equiv pkg name in oe scarthgap...
   Foe=''
   OEfnd="$(grep -i -F "|${Fg}|" /root/.packages/Packages-oe-scarthgap-official | cut -f 2 -d '|')"
   if [ -n "$OEfnd" ];then
    Foe="${OEfnd}"
   else
    #ex: deb pkg is 'automake' and generic is 'automate1.16'
    OEfnd="$(grep -i -F "|${Fp}|" /root/.packages/Packages-oe-scarthgap-official | cut -f 2 -d '|')"
    if [ -n "$OEfnd" ];then
     Foe="${OEfnd}"
    else
     #getting more weird...
     zFg="|${Fg}|"
     yFg="${zFg/|lib/|}"
     echo "${yFg}" > temp1
     echo "${zFg/[0-9]*/|}" >> temp1
     echo "${yFg/[0-9]*/|}" >> temp1
     echo "${zFg/-[0-9]*/|}" >> temp1
     echo "${yFg/-[0-9]*/|}" >> temp1
     xFg="|${Fg}"'[0-9].*|'
     echo "${xFg}" >> temp1
     echo "${xFg/|lib/|}" >> temp1
     wFg="|${Fg}"'-[0-9].*|'
     echo "${wFg}" >> temp1
     zFp="|${Fp}|"
     yFp="${zFp/|lib/|}"
     echo "${yFp}" >> temp1
     echo "${zFp/[0-9]*/|}" >> temp1
     echo "${yFp/[0-9]*/|}" >> temp1
     xFp="|${Fp}"'[0-9].*|'
     echo "${xFp}" >> temp1
     echo "${xFp/|lib/|}" >> temp1
     sort -u temp1 > temp2
     OEfnd="$(grep -i -f temp2 /root/.packages/Packages-oe-scarthgap-official | cut -f 2 -d '|' | head -n 1)"
     if [ -n "$OEfnd" ];then
      Foe="${OEfnd}"
     fi
    fi
   fi
   echo "${Foe}|${Fg}|,${Fp}," >> deb-gen-split-names
  fi
 fi
done
echo
#cleanup...
sed -i -e 's%,,%,%g' deb-gen-split-names
sort -k 1,1 -t '|' deb-gen-split-names > temp1
mv -f temp1 deb-gen-split-names
sync

#find oe pkgs no deb match...
echo 'Looking no oe deb match...'
echo -n '' > oe-no-deb
for aP in $(cut -f 2 -d '|' /root/.packages/Packages-oe-scarthgap-official)
do
 [ -z "$aP" ] && continue
 xaP="$(echo -n "${aP}" | sed -e 's%\.%\\.%g')"
 grep -q "^${xaP}|" deb-gen-split-names
 if [ $? -ne 0 ];then
  echo "${aP}" >> oe-no-deb
 fi
done

#note: /usr/local/petget/debget/oe-deb-names is extracted from deb-gen-split-names
###end###
