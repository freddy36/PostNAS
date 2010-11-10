-- =====
-- ALKIS
-- =====

--  PostNAS 0.3, 24.02.2009  R. Segsa, DT

--  PostNAS 0.4, 02.04.2009

--  PostNAS 0.5, 
--   06.01.2010  F, Jaeger, KRZ
--   21.01.2010  F.J. ap-pto.art
--   14.06.2010  F.J. GRANT entfernt
--   24.09.2010  F.J. "s_flurstueck_nr" ersetzt "s_flurstuecksnummer_flurstueck" (Bruchnummer)


--   Verbindungen werden seit PostNAS 0.5 nicht mehr nachträglich mit einem Script generiert
--   sondern vom Konverter PostNAS gesetzt.
--   Jetzt zentrale Tabelle "alkis_beziehungen" statt der Felder (ForeignKey) in den einzelnen Tabellen.


--  -----------------------------------------
--  Sichten fuer Verwendung im mapfiles (wms)
--  -----------------------------------------


-- Layer "ag_t_flurstueck"
-- -----------------------

-- Die Geometrie befindet sich in "ap_pto", der Label in "ax_flurstueck"
-- Die Verbindung erfolgt über "alkis_beziehungen"

-- PostNAS 0.5, September 2010:
--   Musterdaten RLP: zaehler-nenner steht auch in Feld "ap_pto.schriftinhalt"
--   Lippe NRW:       Feld "ap_pto.schriftinhalt" ist leer. Label aus Tabelle "ax_flurstueck" entnehmen


-- In einigen Gebieten enthält das Feld "ap_pto.art"
-- nicht den Wert 'ZAE_NEN' sondern 'urn:adv:fachdatenverbindung'.
-- Die Flurstücksnummer fehlt dann im WMS.
-- Die Bedingung vorübergehend heraus nehmen. Ursache klären!


-- Version "s_flurstuecksnummer_flurstueck" bis 24.09.2010, 
-- wird ersetzt durch "s_flurstueck_nr"

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
--  WHERE alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';


-- Bruchnummerierung erzeugen
-- (ersetzt s_flurstuecksnummer_flurstueck ab Sept. 2010)
--DROP VIEW s_flurstueck_nr;
CREATE OR REPLACE VIEW s_flurstueck_nr
AS 
 SELECT ap_pto.ogc_fid, 
        ap_pto.wkb_geometry,   -- Position des Textes
    --  ax_flurstueck.flurstueckskennzeichen,   -- am Stueck, aufgefuellt, unpraktisch
    --  ax_flurstueck.gemarkungsnummer,  -- integer
    --  ax_flurstueck.flurnummer,        -- integer
    --  ax_flurstueck.zaehler,           -- integer
    --  ax_flurstueck.nenner,            -- integer oder NULL
        ax_flurstueck.zaehler::text || COALESCE ('/' || ax_flurstueck.nenner::text, '') AS fsnum
   FROM ap_pto
   JOIN alkis_beziehungen 
     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_flurstueck 
     ON alkis_beziehungen.beziehung_zu = ax_flurstueck.gml_id
  WHERE alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon'
  --AND ap_pto.art = 'ZAE_NEN'
  ;

COMMENT ON VIEW s_flurstueck_nr IS 'fuer Kartendarstellung: Bruchnummerierung Flurstück';


-- Layer "ag_t_gebaeude"
-- ---------------------

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


-- In einigen Gebieten in Lippe enthält das Feld "ap_pto.art"
-- nicht den Wert 'HNR'. Die Hausnummer fehlt dann im WMS.
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

COMMENT ON VIEW s_hausnummer_gebaeude IS 'fuer Kartendarstellung: Hausnummern Hauptgebäude';




-- Layer "ag_p_flurstueck"
-- -----------------------

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

COMMENT ON VIEW s_zugehoerigkeitshaken_flurstueck IS 'fuer Kartendarstellung';


-- Layer "s_zuordungspfeil_flurstueck"
-- -----------------------------------

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

COMMENT ON VIEW s_zuordungspfeil_flurstueck IS 'fuer Kartendarstellung';


-- Layer NAME "ap_pto" GROUP "praesentation"
-- ----------------------------------------
-- Texte, die nicht schon in einem anderen Layer ausgegeben werden


CREATE OR REPLACE VIEW s_beschriftung 
AS 
  SELECT ap_pto.ogc_fid, 
      -- ap_pto.gml_id, 
         ap_pto.schriftinhalt, 
         ap_pto.art, 
         ap_pto.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
         ap_pto.wkb_geometry 
    FROM ap_pto 
   WHERE not ap_pto.schriftinhalt IS NULL 
     AND art NOT IN ('ZAE_NEN', 'HNR')
   ;
--  IN ('FKT', 'Friedhof', 'urn:adv:fachdatenv')

-- Diese IN-Liste fortschreiben bei Erweiterungen des Mapfiles

-- Lippe: Der Wert 'ZAE_NEN' fehlt. Diese Fälle anders identifizieren?

GRANT SELECT ON TABLE s_beschriftung                    TO ms5;

COMMENT ON VIEW s_beschriftung IS 'ap_pto, die noch nicht in anderen Layern angezeigt werden';

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



-- EXTENT für Mapfile eines Mandenten ermitteln

CREATE OR REPLACE VIEW flurstuecks_minmax AS 
 SELECT min(st_xmin(wkb_geometry)) AS r_min, 
        min(st_ymin(wkb_geometry)) AS h_min, 
        max(st_xmax(wkb_geometry)) AS r_max, 
        max(st_ymax(wkb_geometry)) AS h_max
   FROM public.ax_flurstueck;

COMMENT ON VIEW flurstuecks_minmax IS 'Maximale Ausdehnung von ax_flurstueck fuer EXTENT-Angabe im Mapfile';



-- Nach Laden der Keytables:


-- MAP ALT:
-- DATA "wkb_geometry from (SELECT ogc_fid, gml_id, artderfestlegung, name, bezeichnung, stelle, wkb_geometry FROM ax_bauraumoderbodenordnungsrecht) as foo using unique ogc_fid using SRID=25832"

CREATE VIEW baurecht
AS
  SELECT r.ogc_fid, 
         r.wkb_geometry, 
         r.gml_id, 
         r.artderfestlegung as adfkey, -- Art der Festlegung - Key 
         r."name",                     -- Eigenname des Gebietes
         r.stelle,                     -- Stelle Key
         r.bezeichnung AS rechtbez,    -- Verfahrensnummer
         a.bezeichner  AS adfbez,      -- Art der Festlegung - Bezeichnung
         d.bezeichnung AS stellbez     -- Stelle Bezeichnung
      -- , d.stellenart  --- weiter entschluesseln?
    FROM ax_bauraumoderbodenordnungsrecht r
    LEFT JOIN ax_bauraumoderbodenordnungsrecht_artderfestlegung a
      ON r.artderfestlegung = a.wert
    LEFT JOIN ax_dienststelle d
      ON r.land = d.land AND r.stelle = d.stelle
 ;

-- MAP NEU:
-- DATA "wkb_geometry from (SELECT ogc_fid, gml_id, adfkey, name, stelle, rechtbez, adfbez, stellbez, wkb_geometry FROM baurecht) as foo using unique ogc_fid using SRID=25832" # gespeicherter View


-- END --

