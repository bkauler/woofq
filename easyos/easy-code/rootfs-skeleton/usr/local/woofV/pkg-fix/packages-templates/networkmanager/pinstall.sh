#!/bin/sh
#20231001

#if install in a running easyos...
if [ "`pwd`" == "/" ];then
 if [ $DISPLAY ];then
  case "${LANG:0:2}" in
   fr)
    M1="Vous avez installé <b>networkmanager</b>. Veuillez également installer <b>network-manager-applet</b>, puis vous devez redémarrer pour prendre effet."
    M2="Vous avez installé <b>networkmanager</b>. Vous devez redémarrer pour prendre effet."
   ;;
   de)
    M1="Sie haben <b>Netzwerkmanager</b> installiert. Bitte installieren Sie auch <b>Network-Manager-Applet</b>. Anschließend müssen Sie einen Neustart durchführen, damit es wirksam wird."
    M2="Sie haben <b>Netzwerkmanager</b> installiert. Sie müssen neu starten, damit es wirksam wird."
   ;;
   tr)
    M1="<b>networkmanager</b>'ı yüklediniz. Lütfen <b>network-manager-applet</b>'i de yükleyin, ardından etkili olması için yeniden başlatmanız gerekir."
    M2="<b>networkmanager</b>'ı yüklediniz. Etkili olması için yeniden başlatmanız gerekir."
   ;;
   ru)
    M1="Вы установили <b>сетевой менеджер</b>. Также установите <b>network-manager-applet</b>, после чего вам потребуется перезагрузить компьютер, чтобы изменения вступили в силу."
    M2="Вы установили <b>сетевой менеджер</b>. Вам необходимо перезагрузиться, чтобы изменения вступили в силу."
   ;;
   *)
    M1="You have installed <b>networkmanager</b>. Please also install <b>network-manager-applet</b>, then you must reboot to take effect."
    M2="You have installed <b>networkmanager</b>. You must reboot to take effect."
   ;;
  esac
  if [ -s /root/.packages/user-installed-packages ];then
   grep -qi '^network-manager-applet' /root/.packages/user-installed-packages /root/.packages/woof-installed-packages
   if [ $? -ne 0 ];then
    popup "background=#ffa050 terminate=ok level=top|<big>${M1}</big>"
   else
    popup "background=#ffa050 terminate=ok level=top|<big>${M2}</big>"
   fi
  fi
 fi
fi
