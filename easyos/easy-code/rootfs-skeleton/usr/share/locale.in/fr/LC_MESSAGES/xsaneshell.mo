��          |      �          0   !  #   R  -   v      �  1   �     �  �   
     �     �  0   �  l       �  /   �  /   �  B   �  *   @  .   k     �  �   �     �  W  �  >   �  ~   ,	                 
                                  	        1. Run 'sane-find-scanner' in a terminal window. 2. Make sure 'sg' module is loaded. 3. Specify the device on the commandline, ex: 4. or maybe a symbolic link, ex: Do you have a parallel-port, USB or SCSI scanner? Frontend for Xsane If your scanner is one of these, then Xsane will not auto-detect it.
-- in that case, click 'QUIT' button and open 'dll.conf' in a text
   editor and uncomment the appropriate entry. QUIT The list of supported drivers is in text file /etc/sane.d/dll.conf
When Xsane starts, your scanner (if it is connected and turned on)
should be autodetected. However, some entries in 'dll.conf' are
commented-out. Here is the list of SANE drivers that are commented
-out in file 'dll.conf' To continue and run Xsane, answer this question: Xsane may be a bit 'insane' when detecting a SCSI scanner. There are
various things that you may have to do: Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: 
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language-Team: LANGUAGE <LL@li.org>
Language: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 1. Lancez 'sane-find-scanner' dans un terminal. 2. Assurez-vous que le module 'sg' est chargé. 3. Indiquez le périphérique dans la ligne de commande, p. ex. : 4. ou peut-être un lien symbolique, ex : Avez-vous un scanner parallèle, USB ou SCSI ? Interface pour Xsane Si votre scanner est un de ces types, alors Xsane ne le trouvera pas automatiquement. 
-- dans ce cas, cliquer sur le bouton QUITTER et ouvrir 'dll.conf' dans un éditeur de texte 
   et retirer le commentaire approprié. QUITTER La liste des pilotes pris en charge se trouve dans le fichier texte /etc/sane.d/dll.conf 
Lorsque Xsane se lance, votre scanner (si connecté et allumé) 
doit être détecté automatiquement. Cependant, certaines entrées dans 'dll.conf' sont 
décommentées. Voici la liste des pilotes SANE qui sont décommentés 
dans le fichier 'dll.conf' Pour continuer et lancer Xsane, répondez à cette question : Xsane peut être un peu 'fou' quand il détecte un scanner SCSI. Il y a 
diverses choses que vous devrez certainement faire : 