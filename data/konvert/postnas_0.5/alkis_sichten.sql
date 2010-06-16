-- =====
-- ALKIS
-- =====

--  PostNAS 0.3, 24.02.2009  R. Segsa, DT

--  PostNAS 0.4, 02.04.2009

--  PostNAS 0.5, 
--   06.01.2010  F, Jaeger, KRZ
--   21.01.2010  ap-pto.art
--   14.6.2010   GRANT entfernt

--   Verbindungen werden seit PostNAS 0.5 nicht mehr nachträglich mit einem Script generiert
--   sondern vom Konverter PostNAS gesetzt.
--   Jetzt zentrale Tabelle "alkis_beziehungen" statt der Felder (ForeignKey) in den einzelnen Tabellen.


--  -----------------------------------------
--  Sichten fuer Verwendung im mapfiles (wms)
--  -----------------------------------------


-- Layer "ag_t_flurstueck" in ag_flurstueck.map
-- --------------------------------------------

-- Die Geometrie befindet sich in "ap_pto", der Label in "ax_flurstueck"
-- Die Verbindung erfolgt über "alkis_beziehungen"

-- bis 13.01.2010:
--CREATE OR REPLACE VIEW s_flurstuecksnummer_flurstueck 
--AS 
-- SELECT ap_pto.ogc_fid, 
--        ap_pto.wkb_geometry, 
--        ax_flurstueck.flurstueckskennzeichen, 
--        ax_flurstueck.zaehler,                 -- umn: LABELITEM
--        ax_flurstueck.nenner
--   FROM ap_pto
--   JOIN alkis_beziehungen 
--     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
--   JOIN ax_flurstueck 
--     ON alkis_beziehungen.beziehung_zu = ax_flurstueck.gml_id
--  WHERE ap_pto.art = 'ZAE_NEN'                 -- Zähler / Nenner
--    AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

-- In einigen Gebieten enthält das Feld "ap_pto.art"
-- nicht den Wert 'ZAE_NEN' sondern 'urn:adv:fachdatenverbindung'.
-- Die Flurstücksnummer fehlt dann im WMS.
-- Die Bedingung vorübergehend heraus nehmen. Ursache klären!

CREATE OR REPLACE VIEW s_flurstuecksnummer_flurstueck 
AS 
 SELECT ap_pto.ogc_fid, 
        ap_pto.wkb_geometry, 
        ax_flurstueck.flurstueckskennzeichen, 
        ax_flurstueck.zaehler,                 -- umn: LABELITEM
        ax_flurstueck.nenner
   FROM ap_pto
   JOIN alkis_beziehungen 
     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_flurstueck 
     ON alkis_beziehungen.beziehung_zu = ax_flurstueck.gml_id
  WHERE alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

 -- GRANT SELECT ON TABLE s_flurstuecksnummer_flurstueck TO ms5;


-- Layer "ag_t_gebaeude" in ag_gebaeude.map
-- -----------------------------------------

--CREATE OR REPLACE VIEW s_hausnummer_gebaeude 
--AS 
-- SELECT ap_pto.ogc_fid, 
--        ap_pto.wkb_geometry, 
--        ap_pto.drehwinkel * 57.296 AS drehwinkel,   -- umn: ANGLE [drehwinkel]
--        ax_lagebezeichnungmithausnummer.hausnummer  -- umn: LABELITEM
--   FROM ap_pto
--   JOIN alkis_beziehungen 
--     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
--   JOIN ax_lagebezeichnungmithausnummer 
--     ON alkis_beziehungen.beziehung_zu  = ax_lagebezeichnungmithausnummer.gml_id
--  WHERE ap_pto.art = 'HNR'  -- Hausnummer
--     AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';


-- In einigen Gebieten enthält das Feld "ap_pto.art"
-- nicht den Wert 'HNR'.
-- Die Hausnummer fehlt dann im WMS.
-- Die Bedingung vorübergehend heraus nehmen. Ursache klären!


CREATE OR REPLACE VIEW s_hausnummer_gebaeude 
AS 
 SELECT ap_pto.ogc_fid, 
        ap_pto.wkb_geometry, 
        ap_pto.drehwinkel * 57.296 AS drehwinkel,   -- umn: ANGLE [drehwinkel]
        ax_lagebezeichnungmithausnummer.hausnummer  -- umn: LABELITEM
   FROM ap_pto
   JOIN alkis_beziehungen 
     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_lagebezeichnungmithausnummer 
     ON alkis_beziehungen.beziehung_zu  = ax_lagebezeichnungmithausnummer.gml_id
  WHERE alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

--GRANT SELECT ON TABLE s_hausnummer_gebaeude TO ms5;
  

-- Layer "ag_p_flurstueck" in ag_flurstueck.map
-- --------------------------------------------

CREATE OR REPLACE VIEW s_zugehoerigkeitshaken_flurstueck 
AS 
 SELECT ap_ppo.ogc_fid, 
        ap_ppo.wkb_geometry, 
        ap_ppo.drehwinkel * 57.296 + 90 AS drehwinkel, 
        ax_flurstueck.flurstueckskennzeichen
   FROM ap_ppo
   JOIN alkis_beziehungen 
     ON ap_ppo.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_flurstueck 
     ON alkis_beziehungen.beziehung_zu = ax_flurstueck.gml_id
  WHERE ap_ppo.art = 'Haken'
    AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

--GRANT SELECT ON TABLE s_zugehoerigkeitshaken_flurstueck TO ms5;



-- Layer "ag_l_flurstueck" in ag_flurstueck.map
-- --------------------------------------------

CREATE OR REPLACE VIEW s_zuordungspfeil_flurstueck 
AS 
 SELECT ap_lpo.ogc_fid, 
        ap_lpo.wkb_geometry
   FROM ap_lpo
   JOIN alkis_beziehungen 
     ON ap_lpo.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_flurstueck 
     ON alkis_beziehungen.beziehung_zu = ax_flurstueck.gml_id
  WHERE ap_lpo.art = 'Pfeil'
    AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

--GRANT SELECT ON TABLE s_zuordungspfeil_flurstueck TO ms5;


--  ------------------------------------------
--  Sichten fuer Fehlersuche und Daten-Analyse
--  ------------------------------------------


-- Zeigt die Texte an, die nicht in einem der Mapfile-Views verarbeitet werden
CREATE OR REPLACE VIEW s_allgemeine_texte 
AS 
 SELECT ap_pto.ogc_fid, 
      --ap_pto.wkb_geometry, 
      --ap_pto.gml_id,
        ap_pto.art, 
        ap_pto.drehwinkel * 57.296 AS drehwinkel,   -- * 180 / Pi
        ap_pto.schriftinhalt
   FROM ap_pto
  WHERE NOT ap_pto.art = 'ZAE_NEN' 
    AND NOT ap_pto.art = 'HNR' 
    AND NOT ap_pto.art = 'FKT' 
    AND NOT ap_pto.art = 'Friedhof' 
    AND ap_pto.schriftinhalt IS NOT NULL;



-- Analyse zu o.g. Fehler:
--  Welche Inhalte kommen im Feld ap_pto.art vor?
CREATE OR REPLACE VIEW ap_pto_arten 
AS 
  SELECT DISTINCT art 
    FROM ap_pto;


-- Umbruch im Label?
-- z.B. "Schwimm-/nbecken"
-- Sind 2 Buchstaben in Mapfile bei "WRAP" möglich?
CREATE OR REPLACE VIEW texte_mit_umbruch 
AS 
 SELECT ogc_fid, schriftinhalt, art
   FROM ap_pto 
  WHERE not schriftinhalt is null
    AND schriftinhalt like '%/n%';

-- ... schriftinhalt like '%/%';
-- RLP: Flurstücks-Bruchnummer art='ZAE_NEN' als Schriftinhalt (2 Fälle)



CREATE OR REPLACE VIEW s_allgemeine_texte_arten
AS 
 SELECT DISTINCT art 
   FROM s_allgemeine_texte;

-- dies liefert die Werte:
--  Bahnverkehr, BWF, FKT_LGT, Fliessgewaesser, FreierText, Gewanne, NAM, Platz,
--  StehendesGewaesser, Strasse, urn:adv:fachdatenv, Weg, ZNM

--GRANT SELECT ON TABLE s_allgemeine_texte  TO ms5; -- nicht im WMS


-- EXTENT für Mapfile eines Mandenten ermitteln

CREATE OR REPLACE VIEW flurstuecks_minmax AS 
 SELECT min(st_xmin(wkb_geometry)) AS r_min, 
        min(st_ymin(wkb_geometry)) AS h_min, 
        max(st_xmax(wkb_geometry)) AS r_max, 
        max(st_ymax(wkb_geometry)) AS h_max
   FROM public.ax_flurstueck;

COMMENT ON VIEW flurstuecks_minmax IS 'Maximale Ausdehnung von ax_flurstueck fuer EXTENT-Angabe im Mapfile';


-- END --

