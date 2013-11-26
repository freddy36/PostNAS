--
-- ALKIS PostNAS 0.7
--
-- ======================================================
-- Zusammenfassung der Tabellen der tatsächlichen Nutzung
-- ======================================================
--
-- Um bei einer Feature.Info (Welche Nutzung an dieser Stelle?) 
-- oder einer Verschneidung (Welche Nutzungen auf dem Flurstück?) 
-- nicht 26 verschiedene Tabellen abfragen zu müssen, werden die wichtigsten 
-- Felder dieser Tabellen zusammen gefasst.
--
-- Teil 3: Laden der (redundanten) Tabelle "nutzung", notwendig nach jeder Fortführung.
--
-- Stand 
--
--  2012-02-10 PostNAS 07, Umbenennung
--  2012-04-24 keine historischen Flaechen (..WHERE endet IS NULL), 
--             Feld 'beginnt' mitnehmen wegen Doppelbelegung gml_id (noch klären)
--  2013-11-18 - Spalte nutzung.class mit Wert 0 füllen wenn Quellspalte NULL ist.
--             - Korrektur der Schlüsseltabelle "nutzung_class":
--               Fehlende Werte aus konvertierten Daten ergänzen. Wenn dies in der Praxis wirklich 
--               vorkommt, sollte das Lade-Script "nutzungsart_metadaten.sql" ergänzt werden.


SET client_encoding = 'UTF-8';


-- Tabelle  l e e r e n
-- --------------------
DELETE FROM nutzung;


-- Tabelle  l a d e n 
-- --------------------

-- Welche Felder der Ursprungstabellen in die Zielfelder "class" und "info" geladen werden,
-- wird dokumentiert über die Tabelle "nutzung_meta" im Script "alkis_nutzungsart_meta.sql".


-- ****  Objektbereich: Tatsächliche Nutzung  ****

-- ** Objektartengruppe: Siedlung **

-- 01 REO: ax_Wohnbauflaeche
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                       info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 1,       coalesce(artderbebauung, 0), null ,zustand, name, null,        wkb_geometry 
  FROM ax_wohnbauflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 02 REO: ax_IndustrieUndGewerbeflaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 2,       coalesce(funktion, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_industrieundgewerbeflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 03 REO: ax_Halde
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 3,       coalesce(lagergut, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_halde
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 04 ax_Bergbaubetrieb
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 4,       coalesce(abbaugut, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_bergbaubetrieb
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 05 REO: ax_TagebauGrubeSteinbruch
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 5,       coalesce(abbaugut, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_tagebaugrubesteinbruch
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 06 REO: ax_FlaecheGemischterNutzung
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 6,       coalesce(funktion, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_flaechegemischternutzung
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 07 REO: ax_FlaecheBesondererFunktionalerPraegung
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,           zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 7,       coalesce(funktion, 0), artderbebauung, zustand, name, null,        wkb_geometry 
  FROM ax_flaechebesondererfunktionalerpraegung
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 08 REO: ax_SportFreizeitUndErholungsflaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 8,       coalesce(funktion, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_sportfreizeitunderholungsflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';
-- weiteres Feld: name char(20)?


-- 09 REO: ax_Friedhof
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 9,       coalesce(funktion, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_friedhof
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- ** Objektartengruppe: Verkehr **

-- 10 ax_Strassenverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,   zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 10,      coalesce(funktion, 0), null,   zustand, name, zweitname,   wkb_geometry 
  FROM ax_strassenverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 11 ax_Weg
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 11,      coalesce(funktion, 0), null,  null,    name, bezeichnung, wkb_geometry 
  FROM ax_weg
  WHERE endet IS NULL;


-- 12 ax_Platz
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 12,      coalesce(funktion, 0), null, null,    name, zweitname,   wkb_geometry 
  FROM ax_platz
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 13 ax_Bahnverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,          zustand, name,        bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 13,      coalesce(funktion, 0), bahnkategorie, zustand, bezeichnung, null,        wkb_geometry 
  FROM ax_bahnverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';
-- bahnkategorie ist alternativ ein geeignetes class-Feld


-- 14 ax_Flugverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 14,      coalesce(art, 0),      null,  zustand, name, bezeichnung, wkb_geometry 
  FROM ax_flugverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 15 ax_Schiffsverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 15,      coalesce(funktion, 0), null, zustand, name, null,        wkb_geometry 
  FROM ax_schiffsverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- ** Objektartengruppe: Vegetation **

-- 16 ax_Landwirtschaft
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                           info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 16,      coalesce(vegetationsmerkmal, 0), null, null,    name, null,        wkb_geometry 
  FROM ax_landwirtschaft
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 17 ax_Wald
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                           info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 17,      coalesce(vegetationsmerkmal, 0), null, null,    name, bezeichnung, wkb_geometry 
  FROM ax_wald
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 18 ax_Gehoelz
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 18,      coalesce(funktion, 0), vegetationsmerkmal, null,    null, null,        wkb_geometry 
  FROM ax_gehoelz
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 19 ax_Heide
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,  info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 19,      0,      null, null,    name, null,        wkb_geometry 
  FROM ax_heide
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 20 ax_Moor
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,  info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 20,          0,  null, null,    name, null,        wkb_geometry 
  FROM ax_moor
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 21 ax_Sumpf
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,  info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 21,          0,  null, null,    name, null,        wkb_geometry 
  FROM ax_sumpf
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 22 ax_UnlandVegetationsloseFlaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,                 zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 22,      coalesce(funktion, 0), oberflaechenmaterial, null,    name, null,        wkb_geometry 
  FROM ax_unlandvegetationsloseflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';

-- (23 Nummerierungslücke)

-- ** Objektartengruppe: Gewässer **

-- 24 ax_Fliessgewaesser
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand,  name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 24,      coalesce(funktion, 0), null, zustand,  name, null,        wkb_geometry 
  FROM ax_fliessgewaesser
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 25 ax_Hafenbecken
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info,    zustand,   name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 25,      coalesce(funktion, 0), nutzung, null,      name, null,        wkb_geometry 
  FROM ax_hafenbecken
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 26 ax_StehendesGewaesser
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung,         wkb_geometry)
  SELECT             gml_id, beginnt, 26,      coalesce(funktion, 0), null, null,    name, gewaesserkennziffer, wkb_geometry 
  FROM ax_stehendesgewaesser
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 27 ax_Meer
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,                 info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 27,      coalesce(funktion, 0), null, null,    name, bezeichnung, wkb_geometry 
  FROM ax_meer
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- Ergaenzung der Schlüsseltabelle
-- -------------------------------

-- Fehlende Einträge in der manuell gefüllten Tabelle "nutzung_class" (Theorie, aus GeoInfoDok)
-- durch Einträge aus der zusammen gefassten Tabelle "nutzung" ergänzen (Praxis).

-- Wenn in der Praxis weitere Schlüssel vorkommen, die in der Tabelle "nutzung_class" noch nicht 
-- enthalten sind, dann kann das bei Equivalenz-Abfragen (INNER JOIN) dazu führen, dass die 
-- Nutzungsarten-Abschnitte mit den dort fehlenden Schlüsseln ausgelassen werden.

INSERT INTO  nutzung_class ( nutz_id, class, label, blabla )
  SELECT DISTINCT 
         n.nutz_id,
         n.class,
        '(unbekannt)' AS label, 
        'Schlüssel wurde im PostProcessing aus der Tabelle "nutzung" ergänzt' AS blabla
     FROM nutzung n  -- Daten aus Konverter -- die Praxis
     WHERE NOT EXISTS 
     ( SELECT c.class
         FROM nutzung_class c -- vorbereitete Metadaten aus GeoInfoDok  -- die Theorie
        WHERE n.nutz_id = c.nutz_id 
          AND n.class = c.class
      )
      ORDER BY n.nutz_id, n.class ;

-- END --
