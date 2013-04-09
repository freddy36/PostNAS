-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---

DELETE FROM NUTZUNG;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,          info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 1,       artderbebauung, null ,zustand, name, null,        ora_geometry 
  FROM AX_wohnbauflaeche
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 2,       funktion, null, zustand, name, null,        ora_geometry 
  FROM AX_industrieundgewerbeflaeche
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 3,       lagergut, null, zustand, name, null,        ora_geometry 
  FROM AX_halde
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 4,       abbaugut, null, zustand, name, null,        ora_geometry 
  FROM AX_bergbaubetrieb
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 5,       abbaugut, null, zustand, name, null,        ora_geometry 
  FROM AX_tagebaugrubesteinbruch
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 6,       funktion, null, zustand, name, null,        ora_geometry 
  FROM AX_flaechegemischternutzung
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,           zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 7,       funktion, artderbebauung, zustand, name, null,        ora_geometry 
  FROM AX_FLAECHEBESONDERERFUNKTIONAL
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 8,       funktion, null, zustand, name, null,        ora_geometry 
  FROM AX_SPORTFREIZEITUNDERHOLUNGSFL
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 9,       funktion, null, zustand, name, null,        ora_geometry 
  FROM AX_friedhof
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,   zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 10,      funktion, null,   zustand, name, zweitname,   ora_geometry 
  FROM AX_strassenverkehr
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,  zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 11,      funktion, null,  null,    name, bezeichnung, ora_geometry 
  FROM AX_weg
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 12,      funktion, null, null,    name, zweitname,   ora_geometry 
  FROM AX_platz
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,          zustand, name,        bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 13,      funktion, bahnkategorie, zustand, bezeichnung, null,        ora_geometry 
  FROM AX_bahnverkehr
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,  zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 14,      art,      null,  zustand, name, bezeichnung, ora_geometry 
  FROM AX_flugverkehr
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 15,      funktion, null, zustand, name, null,        ora_geometry 
  FROM AX_schiffsverkehr
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,              info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 16,      vegetationsmerkmal, null, null,    name, null,        ora_geometry 
  FROM AX_landwirtschaft
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,              info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 17,      vegetationsmerkmal, null, null,    name, bezeichnung, ora_geometry 
  FROM AX_wald
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,               zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 18,      funktion, vegetationsmerkmal, null,    null, null,        ora_geometry 
  FROM AX_gehoelz
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 19,      null,  null, null,    name, null,        ora_geometry 
  FROM AX_heide
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 20,      null,  null, null,    name, null,        ora_geometry 
  FROM AX_moor
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class, info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 21,      null,  null, null,    name, null,        ora_geometry 
  FROM AX_sumpf
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,                 zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 22,      funktion, oberflaechenmaterial, null,    name, null,        ora_geometry 
  FROM AX_UNLANDVEGETATIONSLOSEFLAECH
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand,  name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 24,      funktion, null, zustand,  name, null,        ora_geometry 
  FROM AX_fliessgewaesser
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info,    zustand,   name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 25,      funktion, nutzung, null,      name, null,        ora_geometry 
  FROM AX_hafenbecken
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung,         ora_geometry)
  SELECT             gml_id, beginnt, 26,      funktion, null, null,    name, gewaesserkennziffer, ora_geometry 
  FROM AX_stehendesgewaesser
  WHERE ENDET IS NULL;
INSERT INTO NUTZUNG (gml_id, beginnt, nutz_id, class,    info, zustand, name, bezeichnung, ora_geometry)
  SELECT             gml_id, beginnt, 27,      funktion, null, null,    name, bezeichnung, ora_geometry 
  FROM AX_meer
  WHERE ENDET IS NULL;
purge recyclebin;
QUIT;
