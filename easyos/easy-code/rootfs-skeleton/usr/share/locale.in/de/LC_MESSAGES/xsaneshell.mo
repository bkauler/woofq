��          �      L      �  0   �  #   �  -         D  a   e     �  1   �       ^     �   }  �   4     �     �     �     �  0     :   I  l   �  ^  �  8   P  .   �  8   �  4   �  n   &	     �	  @   �	     �	  f   �	  �   f
  �   E     $  	   -  	   7  J  A  8   �  <   �  �                     	                                                                 
                 1. Run 'sane-find-scanner' in a terminal window. 2. Make sure 'sg' module is loaded. 3. Specify the device on the commandline, ex: 4. or maybe a symbolic link, ex: <b>When Xsane starts, your scanner (if it is connected and turned on) should be autodetected.</b> About SCSI drives Do you have a parallel-port, USB or SCSI scanner? Frontend for Xsane However, some entries in the drivers list (/etc/sane.d/dll.conf) are commented-out. These are: If your scanner is one of these, then Xsane will not auto-detect it.
-- in that case, click 'QUIT' button and open 'dll.conf' in a text
   editor and uncomment the appropriate entry. If your scanner is one of these, then Xsane will not auto-detect it. - in that case, click 'Quit' button and open 'dll.conf' in a text editor and uncomment the appropriate entry. NOTE: QUIT Quit The list of supported drivers is in text file /etc/sane.d/dll.conf
When Xsane starts, your scanner (if it is connected and turned on)
should be autodetected. However, some entries in 'dll.conf' are
commented-out. Here is the list of SANE drivers that are commented
-out in file 'dll.conf' To continue and run Xsane, answer this question: To continue and run Xsane, please choose the scanner type. Xsane may be a bit 'insane' when detecting a SCSI scanner. There are
various things that you may have to do: Project-Id-Version: xsaneshell VERSION
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2014-03-11 14:08+0100
PO-Revision-Date: 2014-03-10 13:18+0100
Last-Translator: root <root@localhost>
Language-Team: German
Language: de
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
 1. 'sane-find-scanner' in einem Terminalfenster starten. 2. Sicherstellen, dass Modul 'sg' geladen ist. 3. Das Gerät auf der Kommandozeile spezifizieren, Bsp.: 4. oder vielleichtmaybe ein symbolischer Link, Bsp.: <b>Beim Start von Xsane sollte der Scanner (falls verbunden und eingeschaltet) automatisch erkannt werden.</b> Über SCSI-Laufwerke Welchen Anschluß hat der Scanner: USB, Parallel-Port oder SCSI? Frontend für Xsane Jedoch sind einige EInträge in der Treiberliste (/etc/sane.d/dll.conf) auskommentiert. Es sind diese: Falls der Scanner einer von diesen ist, dann wird Xsane ihn nicht erkennen.
-- in diesem Fall, den Button 'VERLASSEN' anklicken und 'dll.conf' in einem 
   Texteditor öffnen und den entsprechenden Eintrag entkommentieren. Falls der Scanner einer von diesen ist, dann wird Xsane ihn nicht erkennen.
-- in diesem Fall, den Button 'VERLASSEN' anklicken und 'dll.conf' in einem 
   Texteditor öffnen und den entsprechenden Eintrag entkommentieren. HINWEIS: VERLASSEN Verlassen Die Liste der unterstützten Treiber ist in der Textdatei /etc/sane.d/dll.conf
Wenn Xsane startet, sollte der Scanner (falls verbunden und eingeschaltet)
selbsttätig entdeckt werden. Jedoch sind einige Einträge in 'dll.conf' 
auskommentiert. Hier ist die Liste der SANE-Treiber, die in der Datei 
'dll.conf' auskommentiert sind. Zum Weitermachen mit Xsane bitte dise Frage beantworten: Zum Weitermachen mit Xsane bitte den Scanner-Typ auswählen. Xsane kann ein bischen 'ungesund' beim Entdecken eines SCSI-Scanners sein. 
Es gibt verschiedene Dinge, die man möglicherweise tun muss: 