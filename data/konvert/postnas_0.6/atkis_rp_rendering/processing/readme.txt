Um tagesaktuelle Daten abzuleiten, reicht ein Aufruf der 
./batch.sh 

Zuvor sollte jedoch
1. die DB-Konfiguration in psql.conf angepasst werden
2. sichergestellt werden, dass nicht benötigte Datensätze in batch.sh auskommentiert sind
3. Datensätze, die gekachelt werden sollen, in der kacheln.sh aufgeführt sind.


Im Verzeichnis functions/ liegt der Source für die Funktion grid(), die die Ausgangskacheln erstellt.
Bei einer Datenmigration auf einen neuen Server muss diese Funktion dort aufgespielt werden, bevor 
man mit dem Prozessieren beginnt.

In sql/ liegen die Quellcodes aller (Vor)Verarbeitungsschritte. Diese können je nach Anforderung
angepasst werden.

