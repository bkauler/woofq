��          |      �             !  �  $  !   �     �     �  $     e   5  d  �  =        >     \  d  `     �  �  �  ,   �  !   �     �  /     d   >  V  �  k  �  *   f     �                     	             
                         No Okay, the modem was probed and it responded, confirming that it does exist,\n
now the probe can be done to determine a suitable initialization string.\n
Click the 'Yes' button to do this (recommended), or\n
'No' if you already have a suitable initialization string for this modem in\n
/etc/wvdial.conf (the configuration file for PupDial) ...that would probably\n
be the case if you had used this modem the last time that you ran PupDial.\n
\n
Note: For some modern modems, the default 'ATZ' initialization string is\n
sufficient and you do not have to do this probe, however it does not do any\n
harm to do so (and gives further confirmation the modem works)... Please wait, updating settings... PupDial: Initialization string PupDial: modem test Sorry, the modem was not detected as Success, the modem responds as $DEVM! (The modem is there; getting it to dial out is another matter!) Success, the modem responds as $DEVM! (The modem is there; getting it to dial out is another matter!)\n
Click the 'yes' button if you would like /dev/modem to be a link to ${DEVM} and the Wvdial\n
configuration file /etc/wvdial.conf set with entry 'Modem = /dev/${DEVM}. An attempt will\n
also be made to determine appropriate modem initialization strings. The PupDial configuration file /etc/wvdial.conf does have initialization\n
strings in it from previous usage of PupDial. Would you like to reset\n
them to the default ('ATZ' only)?\n
Note, you might want to do this if you have changed modems and you know\n
that the defaults are sufficient. If in doubt, click 'No'... Verifying modem is present... Yes Project-Id-Version: modemtest VERSION
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2014-12-12 15:35+0100
PO-Revision-Date: 2014-12-12 15:35+0100
Last-Translator: esmourguit <jj@moulinier.net>
Language-Team: French
Language: fr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
 Non Tout va bien, le modem a été testé et il a répondu, confirmant qu'il existe bien.\n
Maintenant le test peut être fait pour déterminer une chaîne d'initialisation appropriée.\n
Cliquez sur 'Yes' pour le faire (recommandé),\n
ou 'No' si vous avez déjà une chaîne d'initialisation appropriée pour ce modem dans\n
/etc/wvdial.conf (le fichier de configuration de PupDial) ... c'est probablement le cas\n
si vous avez utilisé ce modem la dernière fois que vous avez exécuté PupDial.\n
\n
Note: Pour certains modems modernes, la chaîne d'initialisation 'ATZ' par défaut est\n
suffisante et vous n'avez pas besoin de faire ce test, mais celal ne fait pas de\n
mal de le faire (et cela confirme que le modem fonctionne) ... Patientez, actualisation des paramètres ... PupDial: Chaîne d'initialisation PupDial: test du modem Désolé, le modem n'a pas été détecté sous Réussi, le modem répond sous $DEVM! (Le modem c'est bien, le faire communiquer c'est autre chose!) C'est réussi, le modem répond! (mais le faire communiquer c'est autre chose!)\n
Cliquez sur 'Yes' si vous voulez lier /dev/modem à ${DEVM} et paramétrer le fichier\n
de configuration Wvdial /etc/wvdial.conf avec l'entrée 'Modem = /dev/${DEVM}. Une\n
tentative aura également lieu pour déterminer les chaînes d'initialisation du modem. Il y a un problème, le test n'a pas générer de chaîne d'initialisation. Vous pouvez essayer de\n
débrancher le modem, redémarrer, puis brancher le modem et relancer à nouveau PupDial.\n
Alternativement, dans la fenêtre principale de PupDial, essayez l'une de ces chaînes dans la\n
deuxième zone d'entrée de chaîne d'initialisation  (en les écrivant!) Vérification de la présence du modem ... Oui 