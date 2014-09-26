
-- ALKIS PostNAS 0.8

-- Eine Datenbank
-- .. wurde bisher mit HIST-Trigger geladen.
-- Historische Objekte werden aber gar nicht benötigt.
-- Darum umwandeln auf Kill-Trigger für die weiteren Konvertierungen.
-- Umgekehrt geht das nicht!

-- Stand 
--  2014-09-23 PostNAS 0.8


-- Historische Objekte aus allen Objekt-Tabellen entfernen

   SELECT alkis_delete_all_endet();


-- Trigger umschalten
-- Die Trigger-Function "delete_feature_kill()" sollte in "alkis-functions.sql" angelegt worden sein,
-- wurde aber bisher nicht benutzt.

DROP TRIGGER delete_feature_trigger;

CREATE TRIGGER delete_feature_trigger
	BEFORE INSERT ON delete
	FOR EACH ROW
	EXECUTE PROCEDURE delete_feature_kill();


-- Jetzt Ausführen von Vacuum sinnvoll
