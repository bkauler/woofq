[general]
#this is the "desk_strings" SSS Domain, for any text data-files that have text that displays on-screen.
#the SSS technique translates files "in place", meaning that the original file gets replaced by the
#translated file (menu_strings domain is slightly different, in that it first generates English files from
#templates, then translates them). Thus the files are translated *before* execution, whereas the gettext
#and t12s methods are run-time translations. "desk_strings" is really only suited to static target files.
#the translations in this SSS-domain, that is, this file desk_strings*, are performed by /usr/sbin/fixdesk,
#which in turn is called from quicksetup (chooselocale) whenever locale is changed, also by rc.update whenever a version upgrade.
#the section-ids are a full path, for example _root_Choices_ROX-Filer_PuppyPin means /root/Choices/ROX-Filer/PuppyPin.
# ...fixdesk will accept any substitution for the '/' char, ex ZrootZChoicesZROX-FilerZPuppyPin
#Please type translation only between the last two % characters. For example: s%"trash"%"Müll"%
#Keep all formatting exactly the same, that is retain all " ' < > / \ characters.
# -- do not replace the " and ' with left-side or right-side quote characters.
#Keep all variables as-is, exs: ${DROPOUT} $DROPOUT -- do not translate!

[_root_Choices_ROX-Filer_PuppyPin]
#translations for ROX-Filer, the file manager used in most puppies.
#these are the labels that appear under the desktop icons.
s%"zip"%"zip"%
s%"trash"%"recicl"%
s%"lock"%"bloq"%
s%"paint"%"pintar"%
s%"chat"%"chat"%
s%"setup"%"config"%
s%"draw"%"dibujar"%
s%"edit"%"notas"%
s%"console"%"term"%
s%"write"%"escrib"%
s%"browse"%"naveg"%
s%"mount"%"montar"%
s%"help"%"ayuda"%
s%"files"%"archiv"%
s%"plan"%"agenda"%
s%"connect"%"conect"%
s%"calc"%"calc"%
s%"email"%"correo"%
s%"install"%"instal"%
s%"play"%"reprod"%
s%"save"%"guardar"%
s%"home"%"home"%
s%"term"%"term"%
s%"net"%"red"%
s%"update"%"act"%
s%"www"%"www"%
s%"apps"%"apps"%
s%"pkg"%"paq"%
s%"sfs"%"sfs"%
s%"share"%"comp"%
s%"kirkstone"%"kirkstone"%

[_root_.jwmrc-tray]
#translations for /root/.jwmrc-tray, operation performed by /usr/sbin/fixdesk
s%"Exit"%"Salir"%
s%"night mode switch"%"modo oscuro"%
s%"Menu"%"Menú"%
s%"showdesktop"%"mostrar escritorio%
s%"defaultbrowser"%"Navegador predeterminado"%
s%"File Manager"%"Explorador de archivos"%
s%"Find"%"Buscar"%
s%"File Find"%"Buscar archivo"%
s%"File finder"%"Buscador de archivos"%
s%"Calculator"%"Calculadora"%
s%"Virtual Keyboard"%"Teclado virtual"%
s%"Show processes"%"Mostrar procesos"%
s%"Shutdown"%"Apagar"%
s%"Configuration and Settings"%"Configuración y ajustes"%
s%"Exit to commandline"%"Salir a terminal"%
s%"Reboot to commandline"%"Reiniciar a terminal"%
s%"files"%"archivos"%
s%"www"%"www"%
s%"apps"%"apps"%
s%"pkgget"%"pkgget"%
s%"sfsget"%"sfsget"%
s%"setup"%"configuración"%
s%"edit"%"editar"%
s%"connect"%"conectar"%
s%"share"%"compartir"%
s%"update"%"actualizar"%
s%"save"%"guardar"%
s%"net"%"red"%
s%"term"%"Term"%
s%"pkg"%"paq"%
s%"Drives"%"Unidades"%
s%"Containers"%"Contenedores"%
s%"Lock the screen"%"Bloquear la pantalla"%


