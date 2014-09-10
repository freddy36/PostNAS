--
-- *****************************
--       A  L   K   I   S
-- *****************************
--
-- Datenbankstruktur PostNAS 0.8
--

-- Stand
-- -----

-- 2014-01-31 FJ: Neues Zusatzmodul zu "alkis_PostNAS_schema.sql".
--                Anpassen der PostNAS-Datenbank an die Besonderheiten einer Führung OHNE Historie.
--                Dies setzt voraus, dass als Trigger-Function die Version "kill" eingerichtet wurde.

-- 2014-08-28 FJ: Version 0.8 - zunächst übernommen, aber ...
--                Mittelfristig überlegen, ob "delete_feature_hist" ohne "identifier" auskommt.
--                Der gleiche Schlüssel steht auch in "gml_id". Dann Spalte "identifier" ganz aus dem Schema entfernen.

-- Die Spalte identifier aus allen Tabellen entfernen.
-- Dies erledigt eine Function aus "alkis-functions.sql".
-- Diese Spalte wird (ausschließlich) vom Trigger für Historie verwendet.

SELECT alkis_drop_all_identifier();


-- Die Function "delete_feature_hist" kann nun nicht mehr ausgeführt werden.

DROP FUNCTION delete_feature_hist();

--
--      THE  (happy)  END
--