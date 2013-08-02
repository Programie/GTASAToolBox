*** Extras ***


*** Wichtig ***
In diesem Ordner findest du einige Dateien, die du mit der GTA San Andreas ToolBox und/oder mit GTA San Andreas verwenden kannst.
Diese Dateien sind in Ordner sortiert.
Alle Dateien, die sich in diesem Ordner befinden, in dem auch diese Readme-Datei ist, können direkt in den Ordner der GTA San Andreas ToolBox kopiert werden.
Wenn sich eine Datei in einem Unterordner befindet, muss diese auch in den selben Ordner im ToolBox-Verzeichnis kopiert werden.

Beispiel:

Die GTA San Andreas ToolBox ist in dem Verzeichnis "C:\Programme\SelfCoders\GTA San Andreas ToolBox\" installiert. Das ist somit das ToolBox-Verzeichnis.
Wenn du nun zum Beispiel die Datei "XYZ.ini" installieren möchtest, welche sich im Ordner "ABC\Test\" (C:\Programme\SelfCoders\GTA San Andreas ToolBox\Extras\ABC\Test\) befindet,
muss diese zum Installieren auch in den Ordner "C:\Programme\SelfCoders\GTA San Andreas ToolBox\ABC\Test\" kopiert werden.


Es gibt ein paar Besonderheiten der Ordnerstruktur.
Die Dateien und Ordner im Ordner "GTASA" müssen in das Verzeichnis von GTA San Andreas kopiert werden, sofern es nicht durch eine Readme-Datei bestimmt wird.

Befindet sich in einem der Ordner eine Readme-Datei, wird möglicherweise in dieser Readme-Datei beschrieben, wo die Datei(en) hinkopiert werden müssen und welche man dafür kopieren muss, damit es funktioniert.
Es gibt Extras, die zusätzliche Dateien benötigen. Dies wird dann in der entsprechenden Readme-Datei angegeben.
Achte darauf, dass du vor dem Überschreiben von Dateien ein Backup erstellst, da ein Überschreiben von Dateien nicht mehr rückgängig gemacht werden kann.


Wenn du Dateien in den Ordner "Update" kopierst, werden diese Dateien beim nächsten Start der GTA San Andreas ToolBox GUI automatisch in die Ordner verschoben.

Ein kleines Beispiel dazu:
Du kopierst eine Datei mit dem Name "X.txt" in den Ordner "Update", welcher sich im ToolBox-Ordner befindet. In unserem Beispiel ist dies "C:\Programme\SelfCoders\GTA San Andreas ToolBox\Update\".
Beim nächsten Start der GTA San Andreas ToolBox GUI, werden alle Dateien aus diesem Ordner in den ToolBox-Ordner verschoben. Ist das Verschieben nicht erfolgreich,
zum Beispiel weil die zu verschiebende Datei gerade verwendet wird, wird versucht die Datei beim nächsten Start der ToolBox GUI erneut zu kopieren. Erst wenn die Datei erfolgreich kopiert worden ist, wird die Datei aus dem Update-Ordner gelöscht.
Ist ein Ordner im Update-Ordner leer, wird dieser auch gelöscht. Befinden sich keine Dateien und Ordner im Update-Ordner, wird der Update-Ordner gelöscht.

Die Ordnerstruktur:
ToolBox-Ordner\Update\Datei.txt => ToolBox-Ordner\Datei.txt
ToolBox-Ordner\Update\X\ABC.exe => ToolBox-Ordner\X\ABC.exe

Ist der Zielordner, in welche die Datei kopiert werden soll, nicht vorhanden, wird er automatisch erstellt.



*** Automatische Ausführung eines Scripts beim Start der GTA San Andreas ToolBox ***
Nun ist es Möglich, mit der GTA San Andreas ToolBox Scripts automatisch beim Start der ToolBox GUI auszuführen.
Hierzu muss nur ein San Andreas ToolBox Script (satbs) im ToolBox-Ordner mit dem Name "Startup.satbs" vorhanden sein.
Diese Datei wird bei jedem Start der ToolBox GUI ausgeführt.