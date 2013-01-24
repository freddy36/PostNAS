
-- ALKIS PostNAS 0.6

-- ======================================================
-- Zusammenfassung der Tabellen der tatsächlichen Nutzung
-- ======================================================

-- Um bei einer Feature.Info (Welche Nutzung an dieser Stelle?) 
-- oder einer Verschneidung (Welche Nutzungen auf dem Flurstück?) 
-- nicht 26 verschiedene Tabellen abfragen zu müssen, werden die wichtigsten 
-- Felder dieser Tabellen zusammen gefasst.

-- Teil 3: Laden der (redundanten) Tabelle "nutzung", notwendig nach jeder Fortführung.

-- Stand 

--  2011-07-25 PostNAS 06, Umbenennung

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
INSERT INTO nutzung (gml_id, nutz_id, class,          info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 1,       artderbebauung, null ,zustand, name, null,        wkb_geometry 
  FROM ax_wohnbauflaeche;


-- 02 REO: ax_IndustrieUndGewerbeflaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 2,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_industrieundgewerbeflaeche;


-- 03 REO: ax_Halde
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 3,       lagergut, null, zustand, name, null,        wkb_geometry 
  FROM ax_halde;


-- 04 ax_Bergbaubetrieb
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 4,       abbaugut, null, zustand, name, null,        wkb_geometry 
  FROM ax_bergbaubetrieb;


-- 05 REO: ax_TagebauGrubeSteinbruch
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 5,       abbaugut, null, zustand, name, null,        wkb_geometry 
  FROM ax_tagebaugrubesteinbruch;


-- 06 REO: ax_FlaecheGemischterNutzung
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 6,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_flaechegemischternutzung;


-- 07 REO: ax_FlaecheBesondererFunktionalerPraegung
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,           zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 7,       funktion, artderbebauung, zustand, name, null,        wkb_geometry 
  FROM ax_flaechebesondererfunktionalerpraegung;


-- 08 REO: ax_SportFreizeitUndErholungsflaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 8,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_sportfreizeitunderholungsflaeche;
-- weiteres Feld: name char(20)?


-- 09 REO: ax_Friedhof
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 9,       funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_friedhof;


-- ** Objektartengruppe: Verkehr **

-- 10 ax_Strassenverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,   zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 10,      funktion, null,   zustand, name, zweitname,   wkb_geometry 
  FROM ax_strassenverkehr;


-- 11 ax_Weg
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 11,      funktion, null,  null,    name, bezeichnung, wkb_geometry 
  FROM ax_weg;


-- 12 ax_Platz
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 12,      funktion, null, null,    name, zweitname,   wkb_geometry 
  FROM ax_platz;


-- 13 ax_Bahnverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,          zustand, name,        bezeichnung, wkb_geometry)
  SELECT             gml_id, 13,      funktion, bahnkategorie, zustand, bezeichnung, null,        wkb_geometry 
  FROM ax_bahnverkehr;
-- bahnkategorie ist alternativ ein geeignetes class-Feld


-- 14 ax_Flugverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,  zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 14,      art,      null,  zustand, name, bezeichnung, wkb_geometry 
  FROM ax_flugverkehr;


-- 15 ax_Schiffsverkehr
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 15,      funktion, null, zustand, name, null,        wkb_geometry 
  FROM ax_schiffsverkehr;


-- ** Objektartengruppe: Vegetation **

-- 16 ax_Landwirtschaft
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,              info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 16,      vegetationsmerkmal, null, null,    name, null,        wkb_geometry 
  FROM ax_landwirtschaft;


-- 17 ax_Wald
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,              info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 17,      vegetationsmerkmal, null, null,    name, bezeichnung, wkb_geometry 
  FROM ax_wald;


-- 18 ax_Gehoelz
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,               zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 18,      funktion, vegetationsmerkmal, null,    null, null,        wkb_geometry 
  FROM ax_gehoelz;


-- 19 ax_Heide
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class, info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 19,      null,  null, null,    name, null,        wkb_geometry 
  FROM ax_heide;


-- 20 ax_Moor
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class, info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 20,      null,  null, null,    name, null,        wkb_geometry 
  FROM ax_moor;


-- 21 ax_Sumpf
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class, info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 21,      null,  null, null,    name, null,        wkb_geometry 
  FROM ax_sumpf;


-- 22 ax_UnlandVegetationsloseFlaeche
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,                 zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 22,      funktion, oberflaechenmaterial, null,    name, null,        wkb_geometry 
  FROM ax_unlandvegetationsloseflaeche;

-- (23 Nummerierungslücke)

-- ** Objektartengruppe: Gewässer **

-- 24 ax_Fliessgewaesser
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand,  name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 24,      funktion, null, zustand,  name, null,        wkb_geometry 
  FROM ax_fliessgewaesser;


-- 25 ax_Hafenbecken
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info,    zustand,   name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 25,      funktion, nutzung, null,      name, null,        wkb_geometry 
  FROM ax_hafenbecken;


-- 26 ax_StehendesGewaesser
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung,         wkb_geometry)
  SELECT             gml_id, 26,      funktion, null, null,    name, gewaesserkennziffer, wkb_geometry 
  FROM ax_stehendesgewaesser;


-- 27 ax_Meer
-- -------------------------------------
INSERT INTO nutzung (gml_id, nutz_id, class,    info, zustand, name, bezeichnung, wkb_geometry)
  SELECT             gml_id, 27,      funktion, null, null,    name, bezeichnung, wkb_geometry 
  FROM ax_meer;


-- END --
