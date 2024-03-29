��    ?        Y         p  
   q     |     �     �     �     �  2   �     �     �               +     2  X   9  @   �  9   �                    .     @     N  9   [  0   �  :   �  0     A   2  B   t  -   �     �     �     �     �     �     	     	     '	     0	     9	  	   B	  Y   L	     �	     �	     �	     �	     �	  <   �	     
  E   ,
     r
     �
     �
  
   �
     �
     �
     �
     �
  �  �
  /   �     �  	   �     �  \  �     1     >     O     _     t     �  J   �     �     �     �  )   �     $      ,   q   5   P   �   S   �      L!     S!     [!     t!     �!     �!  S   �!  -   
"  J   8"  =   �"  M   �"  a   #  B   q#     �#     �#  
   �#     �#     �#  	   �#     �#  
   $  
   $     $     )$  x   5$     �$     �$  	   �$  
   �$     �$  J   �$     ;%  U   L%     �%     �%     �%     �%     �%  	   �%     �%     &    &  @    =     a=     s=     �=           <   6   .      '   ?             ;   %           	            >           ,          #   -         4       $   )          5       8   2                        1       7   *   (   +                     :                  !          "          3                &               9   =   0          
         /                Digits:    Increment:   At Offset   Base Chars  Characters  With   %d items in list, %d selected, %d ready to commit. -Digit Sequential Append  Bookmark Bookmark the current directory Cancel Case:  Change the permissions of files that you want to rename, then press [Re-Read Directory]. Change the renaming options for the files that caused the error. Change to a writable directory or change the permissions. Close Commit Commit the changes? Confirm On Commit Delete First  Delete Last  Encountered %d errors.  Check log file or console output. Error: Duplicate names in the 'New Name' column. Error: Number of characters to delete exceeds name length. Error: Offset for insertion exceeds name length. Error: One or more files in the 'New Name' column already exists. Error: One or more files in the 'Old Name' column is not writable. Error: The current directory is not writable. Exit First   Insert  Last Log In ~/gfnrename.log Lower   New Name Offset:  Old Name Prefix:  Prepend   Press the [Commit] button to commit the changes to disk, or select other files to rename. Re-Read Directory Rename Replace Replace  Select All / None Select the files to rename, or choose a different directory. Seq.Offset:  Set the desired renaming options, and then press the [Rename] button. Show HelpLine Show Hidden Starting Dot:  StatusLine Up Upper file gFnRename Help... gFnRename v0.6
(C)2010 Paul Schuurmans

Introduction
gFnRename is a simple utility to rename multiple files.  The listbox on the left side of the main window can be used for both choosing a directory and for selecting items to rename.  Items prefixed with "[D]" are directories; "[f]" denotes a file.

Global Options
Just below the renaming options, there are a few global options.  If "Confirm On Commit" is set, the program will ask for confirmation before actually committing any changes to disk.  "Log" specifies whether or not to keep track of actions in a file in your home directory.  "Show HelpLine" toggles a help (or hint) line at the top of the main window.  "StatusLine" toggles a line at the bottom of the main window where error messages or status info is shown.

Choosing A Directory
The path dropdown listbox shows the current directory, and can also be used to switch to any upper-level directory.  To switch to a lower-level directory, either double-click a directory, or select a directory and press [Enter].
There are also three navigation buttons at the top right of the main window's left pane.  You can switch to your Home directory by pressing the [~] button, or go up one level by pressing the [..] button.  The [>] button is used to switch to a user-defined bookmark.  The [B] button toggles the Bookmark Bar where you can bookmark the current directory by pressing the [+] button.

Selecting Items To Rename
To select consecutive items, select the first desired item and then hold the [Shift] key while selecting the last desired item.  To select non-consecutive items, hold the [Ctrl] key while selecting items.
After selecting the items that you want to rename, you can set various renaming options and then press the [Rename] button.

The Renaming Process
The renaming options are handled in the following order:
1. If DeleteLast is set, the specified amount of characters are removed from the end of the item's original base name.  The extension at this point is kept intact.
2. If DeleteFirst is set, the specified amount of characters are removed from the beginning of the item's original name.
3. If Insert is set, the character string specified in Insert is added at the 0-based offset specified in Offset.
4. If Replace is set, the character string specified in Replace is replaced with the character string specified in With.
5. If Base is set, the original base name is replaced with whatever is specified in Base and a sequential number is appended to this base name.  Seq.Offset specifies the starting number, and Digits specifies how many digits to use.  As an example: if Base is "file", Offset is "1", and Digits is "3", then the selected items will be renamed file001, file002, file003, and so on.
6. If Prepend is set, a number with the specified number of Digits starting at Offset with increments of Increment is added to the beginning of the item's new name.  As an example: if Digits is "3", Offset is "10", and Increment is "5", then the selected items will be renamed 010file.ext, 015file.ext, 020file.ext, 025file.ext and so on.
7. If Prefix is set, the specified text is added to the beginning of the item's new name.
8. If Append is set, the specified text is added to the end of the item's new base name.  The extension at this point is kept intact.
9. If Extension is set, the specified text is used as the item's extension.  If Replace is set, the item's original extension is removed before adding the new extension.    For filenames with multiple dots, you can specify where the extension starts by setting one of the Starting Dot radio buttons.
10. If Case is set, the item's new name at this point is converted to either lowercase or uppercase (depending on which one is specified).

The Final Step
At this point, there should be one or more items in the New Name column of the file list.  Note that no changes are made to the physical disk at this point.  You now have the following choices:
- If the new names are not what you expected: select those same items in the file list, set the renaming options, and then press the [Rename] button.
- If you want to rename other items in the same directory: select those items in the file list, set the renamimg options, and then press [Rename].
- If you change your mind and decide not to rename an item: select that item in the file list, unset (clear) all renaming options, and then press [Rename].
- If you're satisfied with all the changes in the New Name column: press the [Commit] button to commit the changes to the physical disk.

Bug Reports
Although some effort has been made to make this program as robust as possible, there may be bugs that I don't yet know about.  If you find any bugs, please let me know.  For information on how to contact me, see the README file on my website.

 gFnRename v0.6 - A Simple File Renaming Utility label_bottom label_top pre- Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2018-07-14 20:36+0800
PO-Revision-Date: 2019-01-27 16:14+0100
Last-Translator: root <jj@moulinier.net>
Language-Team: French
Language: fr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
   Chiffres:    Incrémenter :   Au décalage   Caractères de base  Caractères  Par   %d éléments dans la liste, %d sélectionnés, %d prêt à être validé. -Séquence numérique Joindre  Marquer Ajouter le répertoire actuel aux favoris Annuler Casse :  Modifier les autorisations des fichiers que vous souhaitez renommer, puis appuyez sur [Répertoire de relecture]. Modifiez les options de changement de nom des fichiers à l'origine de l'erreur. Basculer vers un répertoire accessible en écriture ou modifier les autorisations. Fermer Valider Valider les changements? Confirmer la validation Supprimer le premier Supprimer le dernier %d d'erreurs rencontrées. Vérifier le fichier journal ou la sortie de la console. Noms en double dans la colonne 'Nouveau nom'. Erreur: le nombre de caractères à supprimer dépasse la longueur du nom. Erreur: le décalage d'insertion dépasse la longueur du nom. Erreur: un ou plusieurs fichiers de la colonne 'Nouveau nom' existent déjà. Erreur: un ou plusieurs fichiers de la colonne 'Ancien nom' ne sont pas accessibles en écriture. Erreur: le répertoire en cours n'est pas accessible en écriture. Quitter Premier Insérer : Dernier Connexion ~/gfnrename.log Minuscule Nouveau nom Décalage: Ancien nom Préfixe :  Préposer   Pressez le bouton [Valider] pour valider les modifications sur le disque ou sélectionnez d'autres fichiers à renommer. Relire le dossier Renommer Remplacer Remplacer  Choisir Tout/Rien Sélectionnez les fichiers à renommer ou choisissez un autre répertoire. Seq. Décalage:  Définir les options de renommage souhaitées, puis appuyez sur le bouton [Renommer]. Afficher la ligne d'aide Fichiers cachés Point de départ :  Ligne d'état Haut Majuscule fichier Aide de gFnRename ... gFnRename v0.6
(C)2010 Paul Schuurmans

Introduction
gFnRename est un simple utilitaire pour renommer plusieurs fichiers. Le menu déroulant sur le côté gauche de la fenêtre principale peut être utilisé pour à la fois choisir un répertoire et pour sélectionner des éléments à renommer. Les éléments avec le préfixe '[D]' sont des répertoires; '[f]' désigne un fichier.

Options globales
Juste en dessous des options pour renommer, vous avez quelques options globales. Si 'Confirmer la procédure' est coché, le programme vous demandera confirmation avant d'effectivement lancer les modifications sur le disque. 'Connecter à' signifie si oui ou non vous voulez garder une trace des actions dans un fichier dans votre répertoire home. 'Afficher la ligne d'aide' bascule vers une ligne aide (ou trace) en haut de la fenêtre principale. 'Ligne d'état' basculer vers une ligne au bas de la fenêtre principale où les messages d'erreur ou d'état sont affichés.

Choisir un répertoire
La zone du menu déroulant affiche le chemin du répertoire courant, et peut également être utilisé pour passer à n'importe quel répertoire de niveau supérieur. Pour passer à un répertoire de niveau inférieur, soit double-cliquez sur un répertoire, ou sélectionnez un répertoire et appuyez sur [Entrée].
Il y a aussi trois boutons de navigation en haut à droite du panneau de gauche de la fenêtre principale. Vous pouvez passer à votre répertoire d'accueil en appuyant sur la touche [~], ou remonter d'un niveau en appuyant sur le bouton [..]. Le bouton [>] est utilisé pour passer à un signet défini par l'utilisateur. Le bouton [B] bascule vers la barre des signets où vous pouvez ajouter le répertoire courant en appuyant sur les bouton [+]. 

Sélectionner les élément à renommer
Pour sélectionner des éléments consécutifs, sélectionnez le premier élément désiré, puis maintenez la touche [Maj] tout en sélectionnant le dernier élément désiré. Pour sélectionner des éléments non consécutifs, maintenez la touche [Ctrl] enfoncée tout en sélectionnant les articles.
Après avoir sélectionné les éléments que vous souhaitez renommer, vous pouvez définir les diverses options pour renommer, puis appuyez sur le bouton [Renommer].

Le processus pour renommer
Les options pour renommer sont traitées dans l'ordre suivant:
1. Si Supprimer fin est coché, la quantité indiquée, des caractères, est supprimé à partir de la fin du nom de base de l'élément d'origine. L'extension à ce point est gardé intacte.
2. Si Supprimer début est coché, la quantité indiquée, des caractères, est supprimée à partir du début du nom de l'élément d'origine.
3. Si Insérer est coché, la chaîne de caractères spécifiée dans Insérer est ajouté au décalage 0-base spécifiée dans Décalage.
4. Si Remplacer est coché, la chaîne de caractères spécifiée dans Remplacer est remplacée par la chaîne de caractères spécifiée dans Avec.
5. Si Base est coché, le nom de base d'origine est remplacé par ce qui est spécifié dans Base et un numéro séquentiel est ajouté à ce nom de base. Seq.Offset spécifie le nombre de départ, et Nombres spécifie le nombre de chiffres à utiliser.  Exemple: si Base est 'fichier', Décalage est '1', et Nombres est '3', alors les éléments sélectionnés seront renommés fichier001, fichier002, fichier003, etc.
6. Si Préfixer est coché, un certain nombre avec le nombre spécifié dans Décalage avec des incréments de Increment est ajouté au début du nouveau nom de l'élément.  Exemple: Si Nombre est '3', Décalage est '10', et Increment est '5', alors les éléments sélectionnés seront renommés 010fichier.ext, 015fichier.ext, 020fichier.ext, 025fichier.ext etc.7. Si Préfixe est coché, le texte spécifié est ajouté au début du nouveau nom de l'élément.
8. Si Joindre est coché, le texte spécifié est ajouté à la fin du nouveau nom de base de l'élément. Ici, l'extension est gardé intacte.
9. Si Extension est coché, le texte spécifié est utilisé comme une extension de l'élément. Si Remplacer est coché, l'extension d'origine de l'élément est supprimé avant d'ajouter la nouvelle extension.     Pour les noms de fichiers avec de nombreux points, vous pouvez spécifier l'endroit où l'extension commence en définissant un des boutons radio Point de départ.
10. Si Casse est coché, ici, le nouveau nom de l'élément est converti soit en minuscules ou en majuscules (selon ce qui est spécifié).

L'étape finale
A ce stade, il devrait y avoir un ou plusieurs éléments dans la colonne Nouveau Nom de la liste des fichiers. Il faut noter qu'aucune modification n'est encore apportée sur le disque à ce stade. Vous avez maintenant les choix suivants :
- Si les nouveaux noms ne sont pas ce que vous attendiez: sélectionnez ces mêmes éléments dans la liste des fichiers, définissez les options pour renommer, puis appuyez sur la bouton [Renommer].
- Si vous voulez renommer d'autres éléments dans le même répertoire: sélectionner les éléments dans la liste des fichiers, définissez les options pour renommer, puis cliquez sur [Renommer].
- Si vous changez d'avis et décider de ne pas renommer un élément: sélectionnez cet élément dans la liste des fichiers, unset (décocher) toutes les options pour renommer, puis appuyez sur [Renommer].
- Si vous êtes satisfait de toutes les modifications dans la colonne Nouveau Nom: Cliquez sur le bouton [Lancer] pour valider les modifications sur le disque.

Rapports de bogues
Bien que certains efforts aient été faits pour rendre ce programme aussi solide que possible, il peut y avoir des bogues dont je n'ai pas encore entendu parler. Si vous en trouvez, veuillez me le faire savoir. Pour plus d'informations pour me contacter, consultez le fichier README sur mon site Web.
 gFnRename v0.6 - Un utilitaire simple pour renommer des fichiers étiquette_du_bas étiquette_du_haut pre- 