
-- ALKIS PostNAS 0.7

-- ======================================================
-- Zusammenfassung der Tabellen der tatsächlichen Nutzung
-- ======================================================

-- Um bei einer Feature.Info (Welche Nutzung an dieser Stelle?) 
-- oder einer Verschneidung (Welche Nutzungen auf dem Flurstück?) 
-- nicht 26 verschiedene Tabellen abfragen zu müssen, werden die wichtigsten 
-- Felder dieser Tabellen zusammen gefasst.

-- Teil 3: Laden der (redundanten) Tabelle "nutzung", notwendig nach jeder Fortführung.

-- Stand 

--  2012-02-10 PostNAS 07, Umbenennung
--  2012-04-24 keine historischen Flaechen (..WHERE endet IS NULL), 
--             Feld 'beginnt' mitnehmen wegen Doppelbelegung gml_id (noch klären)

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
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,          info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 1,       artderbebauung, null ,zustand, name, null,        wkb_geometry 
  FROM ax_wohnbauflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 02 REO: ax_IndustrieUndGewerbeflaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 2,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_industrieundgewerbeflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 03 REO: ax_Halde
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 3,       lagergut, null, zustand, name, null,        wkb_geometry 
  FROM ax_halde
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 04 ax_Bergbaubetrieb
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 4,       abbaugut, null, zustand, name, null,        wkb_geometry 
  FROM ax_bergbaubetrieb
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 05 REO: ax_TagebauGrubeSteinbruch
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 5,       abbaugut, null, zustand, name, null,        wkb_geometry 
  FROM ax_tagebaugrubesteinbruch
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 06 REO: ax_FlaecheGemischterNutzung
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 6,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_flaechegemischternutzung
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 07 REO: ax_FlaecheBesondererFunktionalerPraegung
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,           zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 7,       funktion, artderbebauung, zustand, name, null,        wkb_geometry 
  FROM ax_flaechebesondererfunktionalerpraegung
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 08 REO: ax_SportFreizeitUndErholungsflaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 8,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_sportfreizeitunderholungsflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';
-- weiteres Feld: name char(20)?


-- 09 REO: ax_Friedhof
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 9,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_friedhof
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- ** Objektartengruppe: Verkehr **

-- 10 ax_Strassenverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,   zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 10,      funktion, null,   zustand, name, zweitname,   wkb_geometry 
  FROM ax_strassenverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 11 ax_Weg
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 11,      funktion, null,  null,    name, bezeichnung, wkb_geometry 
  FROM ax_weg
  WHERE endet IS NULL;


-- 12 ax_Platz
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 12,      funktion, null, null,    name, zweitname,   wkb_geometry 
  FROM ax_platz
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 13 ax_Bahnverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,          zustand, name,        bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 13,      funktion, bahnkategorie, zustand, bezeichnung, null,        wkb_geometry 
  FROM ax_bahnverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';
-- bahnkategorie ist alternativ ein geeignetes class-Feld


-- 14 ax_Flugverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 14,      art,      null,  zustand, name, bezeichnung, wkb_geometry 
  FROM ax_flugverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 15 ax_Schiffsverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 15,      funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_schiffsverkehr
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- ** Objektartengruppe: Vegetation **

-- 16 ax_Landwirtschaft
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,              info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 16,      vegetationsmerkmal, null, null,    name, null,        wkb_geometry 
  FROM ax_landwirtschaft
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 17 ax_Wald
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,              info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 17,      vegetationsmerkmal, null, null,    name, bezeichnung, wkb_geometry 
  FROM ax_wald
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 18 ax_Gehoelz
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,               zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 18,      funktion, vegetationsmerkmal, null,    null, null,        wkb_geometry 
  FROM ax_gehoelz
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 19 ax_Heide
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 19,      null,  null, null,    name, null,        wkb_geometry 
  FROM ax_heide
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 20 ax_Moor
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 20,      null,  null, null,    name, null,        wkb_geometry 
  FROM ax_moor
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 21 ax_Sumpf
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 21,      null,  null, null,    name, null,        wkb_geometry 
  FROM ax_sumpf
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 22 ax_UnlandVegetationsloseFlaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,                 zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 22,      funktion, oberflaechenmaterial, null,    name, null,        wkb_geometry 
  FROM ax_unlandvegetationsloseflaeche
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';

-- (23 Nummerierungslücke)

-- ** Objektartengruppe: Gewässer **

-- 24 ax_Fliessgewaesser
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand,  name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 24,      funktion, null, zustand,  name, null,        wkb_geometry 
  FROM ax_fliessgewaesser
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 25 ax_Hafenbecken
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info,    zustand,   name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 25,      funktion, nutzung, null,      name, null,        wkb_geometry 
  FROM ax_hafenbecken
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 26 ax_StehendesGewaesser
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung,         wkb_geometry)
  SELECT             gml_id, beginnt, 26,      funktion, null, null,    name, gewaesserkennziffer, wkb_geometry 
  FROM ax_stehendesgewaesser
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- 27 ax_Meer
-- -------------------------------------
INSERT INTO nutzung (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, beginnt, 27,      funktion, null, null,    name, bezeichnung, wkb_geometry 
  FROM ax_meer
  WHERE endet IS NULL
    AND st_geometrytype(wkb_geometry) = 'ST_Polygon';


-- END --
