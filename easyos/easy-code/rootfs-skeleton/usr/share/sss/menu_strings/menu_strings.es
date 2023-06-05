[general]
#These are menu strings that get replaced in Window Manager and tray applications.
#if a non-English locale, say 'de', /usr/sbin/fixmenus reads /usr/share/sss/menu_strings/menu_strings.de and translates the files.
#Each code-block below has an identifier, ex [_root_.jwmrc], which identifies the file to be translated -- fixmenus understands this identifier.
#Note: /usr/sbin/fixmenus works differently from the other SSS domains (fixdesk and fixscripts). fixmenus reads raw English
#template files and generates final target files, then translates them in-place. On the otherhand, fixdesk and fixscripts
#translate target files immediately in-place, that is, replaces the original english target files with translated files.
#Please type translation only between the last two % characters. For example: s%"Help"%"Hilfe"%
#Keep all formatting exactly the same, that is retain all " ' < > / \ characters.
# -- do not replace the " and ' with left-side or right-side quote characters.
#Keep all variables as-is, exs: ${DROPOUT} $DROPOUT -- do not translate!

[_root_.jwmrc]
#translations for /root/.jwmrc, operation performed by /usr/sbin/fixmenus
s%"Menu"%"Menu"%
s%"Help"%"Ayuda"%
s%"Shutdown"%"Apagar"%
s%"Exit to prompt"%"Salir a línea de comandos"%
s%"Power-off computer"%"Apagar el sistema"%
s%"Reboot computer"%"Reiniciar el sistema"%
s%"Run..."%"Ejecutar..."%
s%"Special"%"Especial"%
s%"Reboot, with rollback"%"Reiniciar, con rollback"%
s%"Reboot, lockdown in RAM"%"Reiniciar, lockdown en RAM"%
s%"Rectify"%"Rectificar"%
s%"Restart X server"%"Reiniciar X"%
s%"Restart JWM"%"Reiniciar JWM"%
s%"Exit to commandline"%"Salir a línea de comandos"%
s%"Reboot to commandline"%"Reiniciar a línea de comandos"%
s%"Reboot, with filesystem check"%"Reiniciar, con chequeo del sistema de archivos"%
s%"Reboot to initrd (developers only)"%"Reiniciar a initrd (desarrolladores)"%
s%"Utility"%"Herramientas"%
s%"Filesystem"%"Sistema de archivos"%
s%"Graphics"%"Gráficos"%
s%"Document"%"Documentos"%
s%"Business"%"Negocios"%
s%"Personal"%"Personal"%
s%"Network"%"Redes"%
s%"Calculate"%"Calcular"%
s%"Desktop"%"Escritorio"%
s%"System"%"Sistema"%
s%"Setup"%"Configuración"%
s%"Graphic"%"Gráfica"%
s%"Multimedia"%"Multimedia"%
s%"Fun"%"Diversión"%
s%"Desktop Settings"%"Ajustes del escritorio"%
s%"Document/Publishing"%"Documentos/Edición"%
s%"File Managers"%"Exploradores de archivos"%
s%"General Utilities"%"Herramientas generales"%
s%"Graphics/Processing"%"Gráficos/Procesamiento"%
s%"Personal Information"%"Información personal"%
s%"System Status and Config"%"Sistema y configuración"%
s%"Refresh Menu"%"Refrescar menú"%
s%"Help Links"%"Enlaces de ayuda"%
s%"Doc Launcher"%"Lanzador de documentos"%

