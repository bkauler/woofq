#!/bin/sh
#BK 20151025

#20220208 append "$" to src string...
sed -i -e 's%showdesktop</TrayButton>$%showdesktop</TrayButton>\n\t\t<TrayButton popup="Virtual Keyboard" icon="mini-keyboard.xpm">exec:xvkbd-wrapper</TrayButton>%' root/.jwmrc-tray

#170826 this file is in jwmconfig2, but now using PupDesk...
if [ -f root/.jwm/jwmrc-personal ];then
 sed -i -e 's%</JWM>%<Group>\n<Name>xvkbd</Name>\n<Option>icon:mini-keyboard.xpm</Option>\n<Option>noborder</Option>\n<Option>nofocus</Option>\n</Group>\n</JWM>%' root/.jwm/jwmrc-personal
fi
