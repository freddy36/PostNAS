-- ==============
-- ALKIS  PostNAS
-- ==============

-- Verarbeiten der NAS-Loeschsaetze bei Aktualisierung
-- Siehe http://trac.wheregroup.com/PostNAS/wiki/SchrittfuerSchritt

--  2011-09-20 PostNAS 0.6


-- Vorbereitung der Spalte featureid 
UPDATE "delete" 
   SET featureid = substring(featureid from 1 for 16);

-- Löschen der Einträge aus den Tabellen und der Beziehungen aus alkis_beziehungen 
SELECT deleteFeature(typename, featureid) AS deletefeature 
FROM   delete 
GROUP BY deletefeature;

-- Löschen der Einträge der Tabelle delete
-- (Truncate erfordert, dass der ausfuehrende User der Owner ist.)
TRUNCATE table "delete";


-- END --
