#create_savefile_func()
S001='Creando archivo guardado easysave.ext4...'

#salir_a_initrd()
S002='Línea'
S003='Nota 1: Escriba "exit", el guión de inicio intentará continuar.'
S004='Nota 2: En algunas PC, el teclado no funciona en esta etapa del arranque.'
S005='Nota 3: si "ctrl-alt-del" no funciona, mantenga presionado el botón de encendido para apagar.'
S006='Nota 4: el editor de texto de consola "mp" está disponible.'
S007='Nota 5: administrador de archivos de la consola "shfm": navegue con las teclas de flecha, "!" para generar'
S008=' un shell, "?" ayuda emergente, "q" para salir. El archivo de ayuda es "/shfm.txt"'
S009='Nota 6: Administrador de archivos de consola "nnn": Mismas teclas. Archivo de ayuda "/nnn.txt"'

#err_salir()
S010='ERROR:'
S011='Ha caído ahora en un caparazón en el initramfs.'
S012='Presione la combinación de teclas CTRL-ALT-SUPR para reiniciar,'
S013='o MANTENGA PRESIONADO EL BOTÓN DE ENCENDIDO PARA APAGAR'
S014='Las siguientes instrucciones son solo para desarrolladores:'

#preguntar_kb()
S015='Ingrese el número correspondiente a su distribución de teclado.'
S016='Elija la coincidencia más cercana, habrá una oportunidad de ajustar el diseño después de que se haya cargado el escritorio. Presione ENTER solo para EE. UU.'
S017='Nota: en algunas PC, el teclado no funciona en esta etapa de inicio. En ese caso, espere 5 minutos para que se inicie.'
S018='Diseño del teclado:'
S019='...bien, mapa de teclas elegido:'

#menu_func()
S020='No hacer nada, volver para ingresar la contraseña'
S021='Eliminar el bloqueo, restaurar el arranque normal'
S022='Iniciar solo desde la línea de comandos, sin X'
S023='Volver a la última sesión guardada'
S024='Volver al primer arranque prístino'
S025='Comprobación del sistema de archivos de la partición de trabajo'
S026='Presione la tecla ENTER o espere 10 segundos para el arranque normal'
S027='Escriba un número de la columna izquierda:'
S028='...ha elegido restaurar el arranque normal; sin embargo,'
S029='el arranque normal se restaurará en el SIGUIENTE arranque'
S030='...se iniciará en la línea de comandos, sin X'
S031='...volverá a la última sesión guardada'
S032='...revertirá al primer arranque prístino'
S033='...realizará una verificación del sistema de archivos'

#preguntar_pw()
S034='Ingrese una contraseña, cualquier carácter a-z, A-Z, 0-9, cualquier longitud. La contraseña cifrará partes de la partición de trabajo y debe recordarse, ya que deberá ingresarse en cada arranque.'
S035='O simplemente presione la tecla ENTER para no tener contraseña.'
S036='Por su seguridad, se recomienda enfáticamente una contraseña'
S037='Contraseña:'
S038='Lo siento, solo a-z, A-Z, 0-9 caracteres permitidos, inténtelo de nuevo'
S039='Ingrese la contraseña para descifrar la partición de trabajo'
S040='O simplemente presione ENTER para que aparezca un menú de opciones de arranque'
S041='Contraseña:'

#cp_verify_func()
S042='Esta copia falló:'
S043='Es posible que la unidad esté fallando.'
S044='Intentando copiar de nuevo...'
S045='Falló el segundo intento. Intento de recuperación restaurando'
S046='vmlinuz, initrd y easy.sfs de la versión anterior.'
S047='Falló el segundo intento de copiar el archivo. Tal vez la unidad esté fallando.'
S048='El segundo intento fue exitoso, pero la unidad de advertencia podría estar fallando'

###buscar unidades###
S100='Buscando unidades'
S101='las particiones tienen id en conflicto'
S102='AVISO: ¡NO! Todavía no tienes una sesión, haciendo un arranque normal'
S103='Salido temprano de la secuencia de comandos de inicio, aún no se montó nada'

###muy poca memoria RAM###
S110='AVISO: Bloqueo deshabilitado, RAM insuficiente'
S111='AVISO: EasyOS se ejecutará totalmente en RAM, sin almacenamiento persistente'
S112='AVISO: La sesión se copiará a la RAM y EasyOS se ejecutará en la RAM'
S113='Creando zram comprimido. RAM asignada:'
S114='Partición de trabajo:'
S115='Prueba de velocidad de lectura de la unidad en funcionamiento (más baja, mejor):'

###instalar y montar una partición de trabajo###
S120='Cambiando el tamaño de la partición de trabajo para llenar la unidad'
S121='ERROR: no se puede cambiar el tamaño de la partición de trabajo'
S122='Cambiando el tamaño del sistema de archivos ext4 para llenar la partición de trabajo, tamaño:'
S123='ERROR: no se puede cambiar el tamaño del sistema de archivos ext4 para llenar la partición de trabajo, tamaño:'
S124='No se puede cambiar el tamaño de la partición de trabajo. No es seguro continuar'
S125='No se puede montar la partición de trabajo:'
S126='Salido del guión de inicio, partición wkg montada.'

###crear $WKG_DIR y carpetas###
S130='ya existe'
S131='La partición de trabajo no tiene habilitada la función de cifrado ext4.'
S132='Esta función es necesaria para cifrar carpetas. Recomendada por su seguridad.'
S133='Si rechaza, los arranques futuros no le pedirán una contraseña'
S134='ADVERTENCIA: gestores de arranque antiguos como GRUB v1, GRUB4DOS y GRUB v2 anteriores a '
S135='versión 2.0.4 (lanzada en 2019), no reconoce las características modernas de ext4'
S136='como el cifrado de carpetas, y ya no funcionará con la partición'
S137='si habilita el cifrado (ya no se reconocerá la partición)'
S138='Presione la tecla ENTER para habilitar el cifrado, cualquier otra tecla no para:'
S139='Habilitando el cifrado de carpetas ext4...'
S140='Lo siento, no se pudo habilitar el cifrado de carpetas'
S141='...cifrado habilitado.'
S142='Nota, si por alguna razón desea desactivarlo, elimine la instalación de EasyOS. Luego, hay instrucciones en Internet para desactivar el cifrado.'
S143='El montaje de la partición de trabajo ha fallado.'
S144='La compatibilidad con el cifrado de carpetas no está habilitada.'
S145='Lo siento, las carpetas en la partición de trabajo no se pueden cifrar. La contraseña solo se establecerá para el inicio de sesión raíz'
S146='Contraseña incorrecta. Vuelva a intentarlo'
S147='Última sesión guardada en diferido, espere...'

###PODAR###
S150='Ejecutando fstrim en la partición de trabajo SSD...'
S151='Salido del guión de inicio, antes de las operaciones de recuperación y mantenimiento.'

###recuperación, mantenimiento###
S160='Error fatal al comprobar el sistema de archivos'
S161='Salido del guión de inicio, antes del control de versiones.'

###control de versiones###
S170='Operación única, creación de una instantánea de EasyOS'
S171='Esto permitirá una reversión futura con Easy Version Control Manager'
S172='Rellenando:'
S173='Advertencia, eliminando la versión anterior:'
S174='No se puede encontrar easy.sfs'

S180='¿Por qué existe este archivo? Eliminandolo.'
S181='Salió del guión de inicio, antes de configurar las capas SFS.'

###configurar la capa ro inferior, con easy.sfs###
S190='Montando capa de solo lectura de sistema de archivos en capas'
S191='Montando archivo squashfs easy.sfs'
S192='Copiando easy.sfs a RAM, luego montando'
S193='Error al montar easy.sfs'
S194='ADVERTENCIA, las versiones no coinciden.'
S195='El archivo squashfs adicional no existe, se eliminó de la lista de carga'
S196='Copiando a RAM y montando archivo squashfs extra:'
S197='Montando archivo squashfs extra:'
S198='ERROR: /usr/lib64 ruta incorrecta en SFS:'
S199='ESTE SFS NO SE CARGARÁ'
S200='ERROR: /usr/lib/x86_64-linux-gnu ruta incorrecta en SFS:'
S201='Configuración de seguridad de primer arranque...'
S202='Configurando la misma contraseña para los usuarios zeus y root'

###tal vez copiar la sesión a zram###
S210='Copiando última sesión de trabajo a RAM'

###el gran momento, crea f.s. en capas###
S220='Creando sistema de archivos en capas, escriba:'
S221='Error al crear un sistema de archivos en capas'
S222='Se salió del guión de inicio, antes de mover los puntos de montaje a wkg f.s.'

###reubicar los puntos de montaje antes de switch_root###
S230='Realizando un switch_root en el sistema de archivos en capas'
S231='Apagando la unidad:'
S232='Salido del guión de inicio, justo antes de switch_root.'
