#!/bin/sh
#enable export.so plugin

echo 'executing geany pinstall.sh'

#modify geany config so plugin activated by default...
FNDMDLIB="$(find usr/lib/*/geany/export.so | head -n 1)" #ex:usr/lib/x86_64-linux-gnu/geany/export.so
[ ! "$FNDMDLIB" ] && FNDMDLIB="$(find usr/lib*/geany/export.so | head -n 1)"
[ ! "$FNDMDLIB" ] && FNDMDLIB="$(find usr/lib/geany/export.so | head -n 1)"

if [ "$FNDMDLIB" ];then
 if [ -f root/.config/geany/geany.conf ];then
  if [ "$(grep '^active_plugins=' root/.config/geany/geany.conf)" == "" ];then
   echo "
[plugins]
load_plugins=true
custom_plugin_path=
active_plugins=/${FNDMDLIB};" >> root/.config/geany/geany.conf
  else
   ACTIVEPLUGINS="$(grep '^active_plugins=' root/.config/geany/geany.conf)"
   if [ "${ACTIVEPLUGINS/*export*/export}" != "export" ];then
    apPTN="s%^${ACTIVEPLUGINS}%${ACTIVEPLUGINS}/${FNDMDLIB};%"
    sed -i -e "$apPTN" root/.config/geany/geany.conf
   fi
  fi
  #180208 remove...
  #sed -i -e 's%^sidebar_visible=.*%sidebar_visible=true%' root/.config/geany/geany.conf
 fi
fi
