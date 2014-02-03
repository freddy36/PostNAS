--
-- *****************************
--       A  L   K   I   S
-- *****************************
--
-- Datenbankstruktur PostNAS 0.7
--

-- Stand
-- -----

-- 2014-01-31 FJ: Neues Zusatzmodul zu "alkis_PostNAS_schema.sql".
--                Anpassen der PostNAS-Datenbank an die Besonderheiten einer Führung OHNE Historie.
--                Dies setzt voraus, dass als Trigger-Function die Version "kill" eingerichtet wurde.


-- Die Spalte identifier aus allen Tabellen entfernen.
-- Dies erledigt eine Function aus "alkis-functions.sql".
-- Diese Spalte wird (ausschließlich?) vom Trigger für Historie verwendet.
SELECT alkis_drop_all_identifier();


-- Diese Function kann nun nicht mehr ausgeführt werden.
DROP FUNCTION delete_feature_hist();


--  +++ In "alkis_beziehungen" wird die Spalte "beginnt" nicht mehr verwendet.
--  +++ Die wurde gefüllt mit dem Trigger "update_fields" Procedure "update_fields_beziehungen()"
--  +++ Spalte löschen?  In Hist noch verwendet?

--
--          THE  (happy)  END
--