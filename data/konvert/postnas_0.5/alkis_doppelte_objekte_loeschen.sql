
-- Bereinigung "doppelte Objekte"

-- z.B. nachdem eine NAS-Datei doppelt konvertiert wurde

-- Stand 03.02.2011

-- Wenn eine NAS-Datei versehentlich ein zweites mal konvertiert wird, dann merkt PostNAS das nicht!
-- Die "gml_id" wäre ein eindeutiges Kennzeichen, aber als Primary-Key wird die "ogc_fid" künstlich gebildet.

--   ==>  Anpassung Schema?

-- Vorher DB-Sicherung!
--
-- sudo pg_dump -h localhost -p 5432 -U postgres -o -C alkis05300 | gzip > /data/bkup/alkis05300.sql.gz
--


-- Hier die wichtigsten Tabellen:
-- - Die Tabellen aus der Gruppe Nutzungsart muessen eindeutige gml_ids haben fuer die
--   Zusammenfassung in einer Tabelle fuer die Buchauskunft.
-- - Flurstueck wird per WMS-Feature-Info abgefragt.
-- - "alkis_beziehungen" ist die meist-beanspruchte Tabelle

-- Um alle Tabellen zu entruempeln: siehe Shell-Script.


--CREATE VIEW redundanzen_ax_gehoelz
--AS
--  SELECT 
--       a.gml_id, 
--       a.ogc_fid AS erster, 
--       b.ogc_fid AS weiterer
--  FROM ax_gehoelz AS a
--  JOIN ax_gehoelz AS b
--    ON a.gml_id  = b.gml_id 
--   AND b.ogc_fid > a.ogc_fid;


-- 01 REO: ax_Wohnbauflaeche
-- -------------------------------------
DELETE 
  FROM ax_wohnbauflaeche AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_wohnbauflaeche AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 02 REO: ax_IndustrieUndGewerbeflaeche
-- -------------------------------------
DELETE 
  FROM ax_IndustrieUndGewerbeflaeche AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_IndustrieUndGewerbeflaeche AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 03 REO: ax_Halde
-- -------------------------------------
DELETE 
  FROM ax_Halde AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Halde AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 04 ax_Bergbaubetrieb
-- -------------------------------------
DELETE 
  FROM ax_Bergbaubetrieb AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Bergbaubetrieb AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 05 REO: ax_TagebauGrubeSteinbruch
-- -------------------------------------
DELETE 
  FROM ax_TagebauGrubeSteinbruch AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_TagebauGrubeSteinbruch AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 06 REO: ax_FlaecheGemischterNutzung
-- -------------------------------------
DELETE 
  FROM ax_FlaecheGemischterNutzung AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_FlaecheGemischterNutzung AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 07 REO: ax_FlaecheBesondererFunktionalerPraegung
-- -------------------------------------
DELETE 
  FROM ax_FlaecheBesondererFunktionalerPraegung AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_FlaecheBesondererFunktionalerPraegung AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 08 REO: ax_SportFreizeitUndErholungsflaeche
-- -------------------------------------
DELETE 
  FROM ax_SportFreizeitUndErholungsflaeche AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_SportFreizeitUndErholungsflaeche AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 09 REO: ax_Friedhof
-- -------------------------------------
DELETE 
  FROM ax_Friedhof AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Friedhof AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- ** Objektartengruppe: Verkehr **

-- 10 ax_Strassenverkehr
-- -------------------------------------
DELETE 
  FROM ax_Strassenverkehr AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Strassenverkehr AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 11 ax_Weg
-- -------------------------------------
DELETE 
  FROM ax_Weg AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Weg AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 12 ax_Platz
-- -------------------------------------
DELETE 
  FROM ax_Platz AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Platz AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 13 ax_Bahnverkehr
-- -------------------------------------
DELETE 
  FROM ax_Bahnverkehr AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Bahnverkehr AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 14 ax_Flugverkehr
-- -------------------------------------
DELETE 
  FROM ax_Flugverkehr AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Flugverkehr AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 15 ax_Schiffsverkehr
-- -------------------------------------
DELETE 
  FROM ax_Schiffsverkehr AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Schiffsverkehr AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- ** Objektartengruppe: Vegetation **

-- 16 ax_Landwirtschaft
-- -------------------------------------
DELETE 
  FROM ax_Landwirtschaft AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Landwirtschaft AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 17 ax_Wald
-- -------------------------------------
DELETE 
  FROM ax_Wald AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Wald AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 18 ax_Gehoelz
-- -------------------------------------
DELETE 
  FROM ax_gehoelz AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_gehoelz AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 19 ax_Heide
-- -------------------------------------
DELETE 
  FROM ax_Heide AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Heide AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 20 ax_Moor
-- -------------------------------------
DELETE 
  FROM ax_Moor AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Moor AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 21 ax_Sumpf
-- -------------------------------------
DELETE 
  FROM ax_Sumpf AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Sumpf AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 22 ax_UnlandVegetationsloseFlaeche
-- -------------------------------------
DELETE 
  FROM ax_UnlandVegetationsloseFlaeche AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_UnlandVegetationsloseFlaeche AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- ** Objektartengruppe: Gewässer **

-- 24 ax_Fliessgewaesser
-- -------------------------------------
DELETE 
  FROM ax_Fliessgewaesser AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Fliessgewaesser AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 25 ax_Hafenbecken
-- -------------------------------------
DELETE 
  FROM ax_Hafenbecken AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Hafenbecken AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 26 ax_StehendesGewaesser
-- -------------------------------------
DELETE 
  FROM ax_StehendesGewaesser AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_StehendesGewaesser AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- 27 ax_Meer
-- -------------------------------------
DELETE 
  FROM ax_Meer AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_Meer AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);


-- ---------------------------------------------------------------

-- Flurstück

DELETE 
  FROM ax_flurstueck AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_flurstueck AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);


DELETE 
  FROM ax_besondereflurstuecksgrenze AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_besondereflurstuecksgrenze AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);


-- Grundbuch

DELETE 
  FROM ax_buchungsblatt AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_buchungsblatt AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

DELETE 
  FROM ax_buchungsstelle AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_buchungsstelle AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

-- Punkte

DELETE 
  FROM ax_grenzpunkt AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_grenzpunkt AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

DELETE 
  FROM ax_aufnahmepunkt AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_aufnahmepunkt AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

DELETE 
  FROM ax_sonstigervermessungspunkt AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_sonstigervermessungspunkt AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);

DELETE 
  FROM ax_besonderergebaeudepunkt AS dublette
WHERE EXISTS
   (SELECT solitaer.gml_id 
      FROM ax_besonderergebaeudepunkt AS solitaer
     WHERE solitaer.gml_id  = dublette.gml_id 
       AND dublette.ogc_fid > solitaer.ogc_fid);


-- Verbindungen / Relationen     -  S o n d e r f a l l
-- -------------------------

--CREATE VIEW redundanzen_alkis_beziehungen
--AS
--  SELECT solitaer.ogc_fid  AS erster,
--         dublette.ogc_fid  AS zweiter 
--    FROM alkis_beziehungen AS solitaer
--    JOIN alkis_beziehungen AS dublette
--      ON solitaer.beziehung_von = dublette.beziehung_von 
--     AND solitaer.beziehungsart = dublette.beziehungsart 
--     AND solitaer.beziehung_zu  = dublette.beziehung_zu  
--     AND solitaer.ogc_fid       < dublette.ogc_fid;

--  100573 Zeilen

DELETE 
  FROM alkis_beziehungen AS dublette
WHERE EXISTS
   (SELECT solitaer.ogc_fid
      FROM alkis_beziehungen AS solitaer
     WHERE solitaer.beziehung_von = dublette.beziehung_von 
       AND solitaer.beziehungsart = dublette.beziehungsart 
       AND solitaer.beziehung_zu  = dublette.beziehung_zu  
       AND solitaer.ogc_fid       < dublette.ogc_fid);

-- Achtung: sehr lange Ausführungszeit


-- THE (happy) END
