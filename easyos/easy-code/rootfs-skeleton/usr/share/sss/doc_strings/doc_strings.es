[general]
#this is different from the other SSS domains, they have simple sed expressions to translate
#blocks of english text within a file -- XML, script, configuration, etc.
#however, we do have the situation, mostly documentation files, where we need to translate
#the entire file, and create a translated copy. For example, /usr/local/petget/help.htm is a
#English help file for the Puppy Package Manager. The scripts ui_Classic and ui_Ziggy will
#recognise a translated file if it exists, for example /usr/local/petget/help-de.htm.
#however, if translated filename is same as original en filename, then former replaces latter.
#Note, files with "-raw" are created by rootfs-skeleton/pinstall.sh in Woof.
#variables SSS_HANDLER_EDITOR, SSS_TRANSLATION_RULE, SSS_HANDLER_VIEWER must be specified, SSS_POST_EXEC is optional.
#THERE IS NOTHING TO EDIT IN THIS FILE -- MoManager reads this file and does all that is needed.
#I REPEAT, PLEASE DO NOT CHANGE THIS FILE, use MoManager.
#170823 indexgen.sh no longer used.

[_usr_local_petget_help.htm]
#the English help file is /usr/local/petget/help.htm.
#note, /usr/local/petget/ui_Classic and ui_Ziggy look for a translated file, if not exist fall back to help.htm.
#this identifies the name and location of the translated file, ex: the German translation would be file /usr/local/petget/help-de.htm...
SSS_TRANSLATION_RULE='/usr/local/petget/help-SSSLANG1MARKER.htm'
#this identifies the editor to be used...
SSS_HANDLER_EDITOR='defaulthtmleditor'
#for just viewing the file...
SSS_HANDLER_VIEWER='basichtmlviewer'

[#usr#share#doc#cups_shell.htm]
#the English help file for script /usr/sbin/cups_shell is /usr/share/doc/cups_shell.htm
SSS_TRANSLATION_RULE='/usr/share/doc/cups_shell-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_HOWTO-regexps.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/HOWTO-regexps-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_HOWTO-bash-parameter-expansion.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/HOWTO-bash-parameter-expansion-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_Pudd.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/Pudd-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_samba-printing.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/samba-printing-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_gtkdialog-splash.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/gtkdialog-splash-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_local_apps_Trash_Help_help.html]
SSS_TRANSLATION_RULE='/usr/local/apps/Trash/Help/help-SSSLANG1MARKER.html'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_root.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/root-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_legal_puppy.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/legal/puppy-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_legal_easyos.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/legal/easyos-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_share_doc_shfm.txt]
SSS_TRANSLATION_RULE='/usr/share/doc/shfm-SSSLANG1MARKER.txt'
SSS_HANDLER_EDITOR='defaulttexteditor'
SSS_HANDLER_VIEWER='defaulttextviewer'

[_usr_share_doc_limine-installer.htm]
SSS_TRANSLATION_RULE='/usr/share/doc/limine-installer-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_local_bluepup_bluepup.htm]
SSS_TRANSLATION_RULE='/usr/local/bluepup/bluepup-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_local_apps_XkbConfigurationManager_Help]
SSS_TRANSLATION_RULE='/usr/local/apps/XkbConfigurationManager/Help-SSSLANG1MARKER.txt'
SSS_HANDLER_EDITOR='defaulttexteditor'
SSS_HANDLER_VIEWER='defaulttextviewer'

[_usr_local_apps_Trash_Help_help.html]
SSS_TRANSLATION_RULE='/usr/local/apps/Trash/Help/help-SSSLANG1MARKER.html'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[#usr#local#pup_event#pup_event_ipc.htm]
SSS_TRANSLATION_RULE='/usr/local/pup_event/pup_event_ipc-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[#usr#local#pup_event#pup_event-service-management.htm]
SSS_TRANSLATION_RULE='/usr/local/pup_event/pup_event-service-management-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

[_usr_local_shellcms_readme.htm]
SSS_TRANSLATION_RULE='/usr/local/shellcms/readme-SSSLANG1MARKER.htm'
SSS_HANDLER_EDITOR='defaulthtmleditor'
SSS_HANDLER_VIEWER='basichtmlviewer'

