��    G      T  a   �                      @     G     d     l  G   t     �     �     �            %   0  #   V     z     �     �  c   �          %     >     V  �   o  �  	  :   �  	   �  
   �     �  !   �          )  G   6     ~  &   �  ,   �     �  
   �     �     �  O        T     r     �     �     �     �  #   �  1   �     ,      B     c     �     �  j  �  F        M  |   m  �   �  �   �  �   !     �  	   �  /   �  �   �  �   �  �  �  �   v     
          0  9  4     n     �     �  &   �  	   �     �  F   �     "     9  &   O     v     �     �  %   �     �                     �      �     �      �  �     �  �  B   �     �     �       %   *     P     \  Q   h     �  ,   �  $   �        
         %      3   O   B   "   �      �      �      �   	   !     !  !    !  2   B!     u!  %   �!  &   �!     �!     �!  �  �!  O   �#     �#  �   $  �   �$  �   P%  �   �%     �&     �&  5   �&  �   �&  �   �'    (  �   �*     6+     G+     \+     "   6   -          $             +      ,   D                     2                    C   %      9       7       1   @   B                       0   )   (   F           =         5           ?         >       ;   /   &   3   *   4                    
       G   8            A       .       :       <             E       #       '   !   	                  Auto Reconnect C O N F I G U R E   W V D I A L CHOOSE CLOSE window but stay online CONNECT Connect Connect to internet with a analog dialup or digital wireless (3g) modem Connect to the Internet Connection status log DISCONNECT or stop trying Dialtone check Disconnect from the internet Enter the Phone or Access Number here Enter your SIM PIN only if required Enter your password here Exit the program Help Init6-Init9 lines are available for user purposes; the commented examples can be used as described: Initialisation string 2 Initialisation string 2: Initialisation string 3 Initialisation string 3: It seems that the modem has changed.\n
It was '${wvMODEM}', it is now '${newMODEM}'\n
Do you want to update PupDial?\n
Recommend click UPDATE button... It seems that you have a modem, at port ${MYDEVM}\n
However, it is recommended that you now click the 'TEST' button\n
to test that it is working.\n
\n
Note 1: The test will also optionally probe for what is called an\n
'inialization string'. If you are running PupDial for the first time\n
or have changed modems, you will definitely need to click the 'TEST'\n
button and obtain an initialization string.\n
\n
Note 2: If you think that ${MYDEVM} might be the wrong modem,\n
click the 'No' button and the main PupDial GUI has a 'CHOOSE' button\n
that will enable you to test alternative modem interfaces.\n
\n
Recommend click 'TEST' to probe the modem... Make sure this box is checked to attempt auto reconnection Max speed Max speed: Modem Internet dialer Modem detected! Device interface: Modem setup Modem setup: NOTICE: If the log shows a failure to connect, please click left button No No modem detected! You cannot dialout! Only for 3G or cell/mobile phone connections Password Password : Phone number Phone number: PupDial - Internet connection with analog dialup or digital wireless modem (3g) PupDial modem Internet dialer PupDial: WvDial connection log PupDial: modem changed PupDial: modem found Quit R U N   W V D I A L Reading modem configuration file... Recommended to check this box if using a 3G modem SIM PIN (if required) Selected modem device interface: String for modem initialisation Stupid mode Test/Select The reason for asking this, is an internal modem will have been detected at bootup, but a 'hotpluggable' external modem may not have have been detected if plugged in after bootup. Also, if you have both, say an internal analog dialup modem, plus a USB modem, PupDial may choose the wrong one -- ticking or unticking the checkbox here will avoid that confusion... This documentation has 2 chapters:\n1. Run wvdial\n2. Configure wvdial Tick checkbox if external modem To force only 2G or 3G, uncomment the Init4 line and append 0 (2G) or 2 (3G), and substitute your operator's name for MYOPS. To force the 3G quality of service level, uncomment the Init6/Init7 line pair and set value two places each, for 384k/144k/64k, omitting the \"k\" (e.g., =1,4,64,384,64,384). To list all the APNs stored in the modem, uncomment the Init8 line; check the Connection status log for lines beginning with +CGDCONT:. To list the operator identifier stored in the modem, uncomment the Init9 line; check the Connection status log for a line beginning with +COPS: Username Username: WARNING! No modem detected! You cannot dialout! Welcome to PupDial, written by Barry Kauler, with
contributions from Richard Erwin, for Puppy Linux.

A MODEM WAS NOT AUTOMATICALLY DETECTED, SO YOU
NEED TO CLICK THE 'CHOOSE' BUTTON. DO THIS NOW! Welcome to PupDial, written by Barry Kauler, with
contributions from Richard Erwin, for Puppy Linux.

A MODEM WAS NOT AUTOMATICALLY DETECTED, SO YOU
NEED TO CLICK THE 'Choose modem' BUTTON. DO THIS NOW! Welcome to PupDial, written by Barry Kauler, with
contributions from Richard Erwin, for Puppy Linux.

There is a configuration file, /etc/wvdial.conf, that is read by
PupDial, and changes made to any of the above boxes will be saved
to wvdial.conf when you click the 'Exit' or 'Connect' buttons.
Note, you can also manually edit wvdial.conf with a text editor.

If you are using PupDial for the first time, it is recommended that
you click the help buttons, in particular the 'Modem setup' button. Welcome! First, a basic question: do you want to connect to the Internet using an internal fixed modem, or a removable (USB, serial, PCMCIA) modem? Wireless:   APN: WvDial documentation Yes Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2014-10-07 16:03+0200
PO-Revision-Date: 2014-03-25 16:20+0200
Last-Translator: L18L <EMAIL@ADDRESS>
Language-Team: GERMAN <LL@li.org>
Language: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 Automatisch wiederverbinden wvdial konfigurieren WÄHL Fenster SCHLIESSEN aber online bleiben VERBINDEN Netz Ins Internet verbinden mit analogem oder digitalem drahtlos (3g) Modem Ins Internet verbinden Verbindungsstatus log TRENNE VERBINDUNG oder beende Versuche Wahlton-Check Trennen der Internetverbindung Hier die Telefonnummer eingeben SIM PIN (falls erforderlich) eingeben Hier Paßwort eingeben Programm verlassen Hilfe Die Init6-Init9 Zeilen sind für Benutzerzwecke verfügbar; die kommentierten Beispiele können wie beschrieben benutzt werden: Initialisierungs-Zeichenkette 2 Initialisierungs-Zeichenkette 2: Initialisierungs-Zeichenkette 3 Initialisierungs-Zeichenkette 3: Anscheinend wurde das Modem ausgewechselt.\n
Es war '${wvMODEM}', es ist jetzt '${newMODEM}'\n
Möchtest Du PupDial aktualisieren?\n
klick UPDATE Button empfohlen... Es scheint, daß Du ein Modem hast, am Port ${MYDEVM}\n
Jedoch wird empfohlen, daß Du jetzt den 'TEST' Button anklickst,\n
um zu testen, ob es funktioniert.\n
\n
Hinweis 1: Der Test wird auch optional eine sogenannte 'Initialisierungs-Zeichenkette'\n
ermitteln'. Falls Du PupDial das erste Mal startest oder falls Du ein \n
anderes Modem hast, wirst Du unbedingt den 'TEST' Button anklicken müssen,\n
um eine 'Initialisierungs-Zeichenkette' zu erhalten.\n
\n
Hinweis 2: Falls Du denkst, daß ${MYDEVM} das falsche Modem ist,\n
klick den 'Nein' Button und das Hauptfenster von PupDial hat einen 'WÄHL' Button,\n
der Dir dann ermöglicht, alternative Modemschnittstellen zu testen.\n
\n
Empfehle: klick 'TEST' zum Test des Modems.. Diese Box aktivieren um automatische Wiederverbindung zu versuchen Maximalgeschwindigkeit Maximalgeschwindigkeit: Interneteinwahl mit Modem Modem entdeckt! Geräteschnittstelle: Modem-Setup Modem-Setup Hinweis: Falls der log einen Verbindungsfehler anzeigt, klicke den linken Button. Nein Kein Modem entdeckt! Du kommst nicht hinaus! Nur für 3G oder mobile Verbindungen Paßwort Paßwort : Telefonnummer Telefonnummer: PupDial - Internetverbindung mit analog dialup oder digital wireless modem (3g) PupDial: Interneteinwahl mit Modem PupDial: WvDial Verbindungslog PupDial: Modem gewechselt PupDial: Modem gefunden Verlassen wvdial benutzen Lese Modem-Konfigurationsdatei... Empfohlen wird Aktivierung dieser Box bei 3G Modem SIM PIN (falls erforderlich) Gewählte Modem-Geräteschnittstelle: Zeichenkette zur Modem-initialisierung Dummer Modus Test/Selekt Der Grund für diese Frage ist, ein internes Modem wird beim Start des Computers entdeckt sein, aber ein 'heißeingestecktes' externes Modem mag nicht entdeckt worden sein, falls nach dem Start eingeschaltet. Auch falls Du beides hast, sagen wir ein internes Analogmodem, plus ein USB Modem, dann kann PupDial das falsche wählen -- Checkbox aktiviert oder nicht aktiviert wird diese Verwirrung hier vermeiden... Diese Dokumentation hat 2 Kapitel:\n1. wvdial benutzen\n2. wvdial konfigurieren Haken rein falls externes Modem Um nur 2G oder 3G zu erzwingen, entkommentiere die Init4 Zeile und hänge 0 (2G) oder 2 (3G) daran, und setze Deinen operator Namen für MYOPS ein. Um die 3G Qualität des Servicelevels zu erzwingen, entkommentiere das Init6/Init7 Zeilenpaar und setze die Werte, je zwei, für 384k/144k/64k, ohne \"k\" (z.B., =1,4,64,384,64,384). Um alle im Modem gespeicherten APNs aufzulisten, entkommentiere die Init8 Zeile; check den Verbindungsstatus log nach Zeilen, die mit +CGDCONT: beginnen. Um den im Modem gespeicherten operator Namen aufzulisten, entkommentiere die Init9 Zeile; check den Verbindungsstatus log nach einer Zeile, die mit +COPS: beginnt. Benutzername Benutzername: WARNUNG! Kein Modem entdeckt! Du kommst nicht hinaus! Willkommen bei PupDial, geschrieben von Barry Kauler, mit
Beiträgen von Richard Erwin, für Puppy Linux.

EIN MODEM WURDE NICHT AUTOMATISCH ENTDECKT, SODASS DU DEN
'WÄHL' BUTTON KLICKEN MUSST. TU ES JETZT! Willkommen bei PupDial, geschrieben von Barry Kauler, mit
Beiträgen von Richard Erwin, für Puppy Linux.

EIN MODEM WURDE NICHT AUTOMATISCH ENTDECKT, SODASS DU DEN
'WÄHL' BUTTON KLICKEN MUSST. TU ES JETZT! Willkommen bei PupDial, geschrieben von Barry Kauler, mit
Beiträgen von Richard Erwin, für Puppy Linux.

Es gibt eine Konfigurationsdatei, /etc/wvdial.conf, die von PupDial
gelesen wird, und Änderungen, die in irgeneiner der obigen Boxen gemacht werden,
werden in wvdial.conf gespeichert, beim Klick auf 'Beenden' oder 'Verbinden' Button.
Hinweis, man kann wvdial.conf auch manuell mit einem Texteditor editieren.

Wenn Du PupDial zum ersten Mal benutzst, wird empfohlen, die Hilfe-Buttons
zu benutzen, besonders den 'Modem setup' Button. Willkommen! Zuerst eine grundlegende Frage: möchtest Du ins Internet mit einem internen Modem oder mit einem entfernbaren (USB, seriell, PCMCIA) Modem? Drahtlos:   APN: WvDial Dokumentation Ja 