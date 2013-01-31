-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---

DELETE FROM NUTZUNG;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,          info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 1,       artderbebauung, null ,zustand, name, null,        ora_geometry 
  FROM ax_wohnbauflaeche
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 2,       funktion, null, zustand, name, null,        ora_geometry 
  FROM ax_industrieundgewerbeflaeche
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 3,       lagergut, null, zustand, name, null,        ora_geometry 
  FROM ax_halde
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 4,       abbaugut, null, zustand, name, null,        ora_geometry 
  FROM ax_bergbaubetrieb
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 5,       abbaugut, null, zustand, name, null,        ora_geometry 
  FROM ax_tagebaugrubesteinbruch
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 6,       funktion, null, zustand, name, null,        ora_geometry 
  FROM ax_flaechegemischternutzung
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,           zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 7,       funktion, artderbebauung, zustand, name, null,        ora_geometry 
  FROM AX_FLAECHEBESONDERERFUNKTIONAL
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 8,       funktion, null, zustand, name, null,        ora_geometry 
  FROM AX_SPORTFREIZEITUNDERHOLUNGSFL
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 9,       funktion, null, zustand, name, null,        ora_geometry 
  FROM ax_friedhof
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,   zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 10,      funktion, null,   zustand, name, zweitname,   ora_geometry 
  FROM ax_strassenverkehr
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,  zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 11,      funktion, null,  null,    name, bezeichnung, ora_geometry 
  FROM ax_weg
  WHERE endet IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 12,      funktion, null, null,    name, zweitname,   ora_geometry 
  FROM ax_platz
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,          zustand, name,        bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 13,      funktion, bahnkategorie, zustand, bezeichnung, null,        ora_geometry 
  FROM ax_bahnverkehr
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,  zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 14,      art,      null,  zustand, name, bezeichnung, ora_geometry 
  FROM ax_flugverkehr
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 15,      funktion, null, zustand, name, null,        ora_geometry 
  FROM ax_schiffsverkehr
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,              info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 16,      vegetationsmerkmal, null, null,    name, null,        ora_geometry 
  FROM ax_landwirtschaft
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,              info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 17,      vegetationsmerkmal, null, null,    name, bezeichnung, ora_geometry 
  FROM ax_wald
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,               zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 18,      funktion, vegetationsmerkmal, null,    null, null,        ora_geometry 
  FROM ax_gehoelz
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 19,      null,  null, null,    name, null,        ora_geometry 
  FROM ax_heide
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 20,      null,  null, null,    name, null,        ora_geometry 
  FROM ax_moor
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 21,      null,  null, null,    name, null,        ora_geometry 
  FROM ax_sumpf
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,                 zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 22,      funktion, oberflaechenmaterial, null,    name, null,        ora_geometry 
  FROM AX_UNLANDVEGETATIONSLOSEFLAECH
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand,  name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 24,      funktion, null, zustand,  name, null,        ora_geometry 
  FROM ax_fliessgewaesser
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,    zustand,   name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 25,      funktion, nutzung, null,      name, null,        ora_geometry 
  FROM ax_hafenbecken
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung,         ora_geometry)
  SELECT             gml_id, beginnt, 26,      funktion, null, null,    name, gewaesserkennziffer, ora_geometry 
  FROM ax_stehendesgewaesser
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 27,      funktion, null, null,    name, bezeichnung, ora_geometry 
  FROM ax_meer
  WHERE endet IS NULL
    AND st_geometrytype(ora_geometry) = 'ST_Polygon';
purge recyclebin;
QUIT;
