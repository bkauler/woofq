��          �      �       0     1  �  4  !   �     �       $      e   E  d  �  =    9  N     �     �  ;  �     �	  �  �	  /   �  %   �       (   %  w   N  ~  �  U  E  �  �     $     B                    	             
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
that the defaults are sufficient. If in doubt, click 'No'... There is a problem, probing did not generate an initialization string. You could try\n
unplugging the modem, reboot Puppy then plug-in the modem and try again with PupDial.\n
Alternatively, in the PupDial main GUI window, try one of these strings in the second\n
initialization-string entry box (write them down!) Verifying modem is present... Yes Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2014-10-07 16:29+0200
PO-Revision-Date: 2014-02-24 18:49+0800
Last-Translator: L18L <EMAIL@ADDRESS>
Language-Team: GERMAN <LL@li.org>
Language: de
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 Nein In Ordnung, das Modem wurde angesprochen und es antwortete, was bestätigt, daß es existiert,\n
jetzt probieren wir, eine passende Initialisierungszeichenkette zu bekommen.\n
Klick dazu den 'Ja'-Button (empfohlen), oder\n
'Nein' falls Du bereits einen passende Initialisierungszeichenkette für dieses Modem in\n
/etc/wvdial.conf (die Konfigurationsdatei für PupDial) hast ...das ist wahrscheinlich\n
der Fall, wenn Du mit diesem Modem das letzte Mal PupDial benutzt hast.\n
\n
Hinweis: Für einige moderne Modems, ist die Standard-Initialisierungszeichenkette 'ATZ' \n
ausreichend und Du mußt dieses Probieren nicht ausführen, jedoch schadet es nichts\n
 (und gibt eine Bestätigung, daß das Modem funktioniert)... Bitte warten, aktualisiere die Einstellungen... PupDial: Initialisierungszeichenkette PupDial: Modemtest Sorry, das Modem wurde nicht erkannt als Erfolg, das Modem antwortet als $DEVM! (Das Modem ist da; es zu hinaustelefonieren zu bringen, ist einen anders Sache!) Erfolg, das Modem antwortet als $DEVM! (Das Modem ist da; es zum hinaustelefonieren zu bringen, ist eine andere Sache!)\n
Klick den 'ja'-Button, wenn Du gern /dev/modem als link auf ${DEVM} hättest und die Wvdial\n
Konfigurationsdatei /etc/wvdial.conf gesetzt mit dem Eintrag 'Modem = /dev/${DEVM}. Ein Versuch wird\n
auch gemacht, passende Initialisierungszeichenketten zu machen. Die PupDial-Konfigurationsdatei /etc/wvdial.conf hat eine Initialisierungszeichenkette\n
 von früherer Benutzung von PupDial. Möchtest Du sie gern zurücksetzen\n
auf den Standard (nur 'ATZ')?\n
Hinweis, Du magst dies tun, falls Du das Modem ausgewechselt hast und Du weißt,\n
daß der Standard ausreicht. Im Zweifelsfall, klick 'Nein'... Es gibt ein Problem, es konnte keine Initialisierungszeichenkette generiert werden. Du könntest versuchen\n
das Modem zu entfernen, Puppy neu starten und dann das Modem wieder zu verbinden und nocheinmal PupDial probieren.\n
Alternativ, im PupDial Haupt GUI Fenster, versuch es mit einer dieser Zeichenketten in dem zweiten\n
Eingabefeld für Initialisierungszeichenketten (schreib sie auf!) Verifiziere Modemsexistenz... Ja 