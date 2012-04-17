-- =====
-- ALKIS
-- =====

--  PostNAS 0.7

--  2012-02-25 PostNAS 07, Umbenennung
--  2012-04-17 flstnr_ohne_position


--  -----------------------------------------
--  Sichten fuer Verwendung im mapfiles (wms)
--  -----------------------------------------


-- WMS-Layer "ag_t_flurstueck"
-- ---------------------------

-- Die Geometrie befindet sich in "ap_pto", der Label in "ax_flurstueck"
-- Die Verbindung erfolgt über "alkis_beziehungen"


-- Bruchnummerierung erzeugen
-- ALT 2012-04-17: Diese Version zeigt nur die manuell gesetzten Positionen
CREATE OR REPLACE VIEW s_flurstueck_nr
AS 
 SELECT f.ogc_fid, 
        p.wkb_geometry,  -- Position des Textes
        f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum
   FROM ap_pto             p
   JOIN alkis_beziehungen  v  ON p.gml_id       = v.beziehung_von
   JOIN ax_flurstueck      f  ON v.beziehung_zu = f.gml_id
  WHERE v.beziehungsart = 'dientZurDarstellungVon' 
  --AND p."art" = 'ZAE_NEN'
  ;

COMMENT ON VIEW s_flurstueck_nr IS 'fuer Kartendarstellung: Bruchnummerierung Flurstück';

-- NEU 2012-04-17
-- Wenn keine manuelle Position gesetzt ist, wird die Flaechenmitte verwendet

-- ACHTUNG: Dieser View kann nicht direkt im Mapserver-WMS verwendet werden.
-- Die Anzeige ist zu langsam. Filterung über BBOX kann nicht funktionieren, da zunächst ALLE Standardpositionen 
-- berechnet werden müssen, bevor darüber gefiltert werden kann.

-- FAZIT: In einer Hilfstabelle mit geometrischem Index zwischenspeichern.
--        Siehe PostProcessing Tabelle "pp_flurstueck_nr"

CREATE OR REPLACE VIEW s_flurstueck_nr2
AS 
  SELECT f.ogc_fid, 
         p.wkb_geometry,  -- manuelle Position des Textes
         f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum
    FROM ap_pto             p
    JOIN alkis_beziehungen  v  ON p.gml_id       = v.beziehung_von
    JOIN ax_flurstueck      f  ON v.beziehung_zu = f.gml_id
   WHERE v.beziehungsart = 'dientZurDarstellungVon' 
   --AND p."art" = 'ZAE_NEN'
 UNION 
  SELECT f.ogc_fid,
         ST_PointOnSurface(f.wkb_geometry) AS wkb_geometry,  -- Flaechenmitte als Position des Textes
         f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum
    FROM      ax_flurstueck     f 
    LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.gml_id
   WHERE v.beziehungsart is NULL
  ;

COMMENT ON VIEW s_flurstueck_nr2 IS 'Bruchnummerierung Flurstück, auch Standard-Position. Nicht direkt fuer WMS verwenden';


-- Layer "ag_t_gebaeude"
-- ---------------------

-- Problem: Zu einigen Gebäuden gibt es mehrere Hausnummern.
-- Diese unterscheiden sich im Feld ap-pto.advstandardmodell
-- z.B. 3 verschiedene Einträge mit <NULL>, {DKKM500}, {DKKM1000}, (Beispiel; Lage, Lange Straße 15 c)


CREATE OR REPLACE VIEW s_hausnummer_gebaeude 
AS 
 SELECT ap_pto.ogc_fid, 
        ap_pto.wkb_geometry, -- Point
        ap_pto.drehwinkel * 57.296 AS drehwinkel,   -- umn: ANGLE [drehwinkel]
        ax_lagebezeichnungmithausnummer.hausnummer  -- umn: LABELITEM
   FROM ap_pto
   JOIN alkis_beziehungen 
     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_lagebezeichnungmithausnummer 
     ON alkis_beziehungen.beziehung_zu  = ax_lagebezeichnungmithausnummer.gml_id
  WHERE alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

COMMENT ON VIEW s_hausnummer_gebaeude IS 'fuer Kartendarstellung: Hausnummern Hauptgebäude';


-- Layer "ag_t_nebengeb"
-- ---------------------

CREATE OR REPLACE VIEW s_nummer_nebengebaeude 
AS 
 SELECT ap_pto.ogc_fid, 
        ap_pto.wkb_geometry, 
        ap_pto.drehwinkel * 57.296 AS drehwinkel,        -- umn: ANGLE [drehwinkel]
     -- alkis_beziehungen.beziehungsart,                 -- TEST
     -- ax_lagebezeichnungmitpseudonummer.pseudonummer,  -- die HsNr des zugehoerigen Hauptgebaeudes
        ax_lagebezeichnungmitpseudonummer.laufendenummer -- umn: LABELITEM - die laufende Nummer des Nebengebaeudes
   FROM ap_pto
   JOIN alkis_beziehungen 
     ON ap_pto.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_lagebezeichnungmitpseudonummer 
     ON alkis_beziehungen.beziehung_zu  = ax_lagebezeichnungmitpseudonummer.gml_id
  WHERE alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon'
;

COMMENT ON VIEW s_nummer_nebengebaeude IS 'fuer Kartendarstellung: Hausnummern Nebengebäude';


-- Layer "ag_p_flurstueck"
-- -----------------------

CREATE OR REPLACE VIEW s_zugehoerigkeitshaken_flurstueck 
AS 
 SELECT ap_ppo.ogc_fid, 
        ap_ppo.wkb_geometry, 
        ap_ppo.drehwinkel * 57.296 AS drehwinkel,
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
    AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon'
    AND ('DKKM1000' ~~ ANY (ap_lpo.advstandardmodell));

COMMENT ON VIEW s_zuordungspfeil_flurstueck IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer';


CREATE OR REPLACE VIEW s_zuordungspfeilspitze_flurstueck 
AS 
 SELECT ap_lpo.ogc_fid, (((st_azimuth(st_pointn(ap_lpo.wkb_geometry, 1), 
        st_pointn(ap_lpo.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(ap_lpo.wkb_geometry) AS wkb_geometry 
   FROM ap_lpo
   JOIN alkis_beziehungen 
     ON ap_lpo.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_flurstueck 
     ON alkis_beziehungen.beziehung_zu = ax_flurstueck.gml_id
  WHERE ap_lpo.art = 'Pfeil'
    AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon'
    AND ('DKKM1000' ~~ ANY (ap_lpo.advstandardmodell));

COMMENT ON VIEW s_zuordungspfeilspitze_flurstueck IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer, Spitze';



-- Layer NAME "ap_pto" GROUP "praesentation"
-- ----------------------------------------
-- Texte, die nicht schon in einem anderen Layer ausgegeben werden

CREATE OR REPLACE VIEW s_beschriftung 
AS 
  SELECT ap_pto.ogc_fid, 
         ap_pto.schriftinhalt, 
         ap_pto.art, 
         ap_pto.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
         ap_pto.wkb_geometry 
    FROM ap_pto 
   WHERE not ap_pto.schriftinhalt IS NULL 
     AND art NOT IN ('HNR', 'PNR');

-- Feb. 2012 PostNAS 0.6: 'ZAE_NEN' kommt nicht mehr vor!

-- Diese 'IN'-Liste fortschreiben bei Erweiterungen des Mapfiles
-- Wenn ein Text zum fachlich passenden Layer angezeigt wird, dann hier ausblenden,
-- d.h. die Kennung in die Klammer eintragen.

-- Werte in ap_pto.art:
-- 'HNR'  = Hausnummer
-- 'PNR'  = Pseudo-Nummer = laufende Nummer Nebengebäude

-- Ermittlung der vorkommenden Arten mit:
--   SELECT DISTINCT art FROM ap_pto ORDER BY art;

-- Noch nicht berücksichtigt:
   
--"AGT""ART""ATP""BBD""BezKlassifizierungStrasse""BSA""BWF""BWF_ZUS""FKT""Fliessgewaesser""FreierText"
--"Friedhof""Gewanne""GFK""Halde_LGT""HHO""NAM""PKN""Platz""PRO""SPG""SPO""StehendesGewaesser"
--"Strasse""VEG""Vorratsbehaelter""Weg""Weitere Höhe""ZNM""<NULL>"

COMMENT ON VIEW s_beschriftung IS 'ap_pto, die noch nicht in anderen Layern angezeigt werden';


-- Layer "s_zuordungspfeil_gebaeude"
-- -----------------------------------

CREATE OR REPLACE VIEW s_zuordungspfeil_gebaeude 
AS 
 SELECT ap_lpo.ogc_fid, 
     -- alkis_beziehungen.beziehungsart, -- TEST
     -- ap_lpo.art, -- TEST
        ap_lpo.wkb_geometry
   FROM ap_lpo
   JOIN alkis_beziehungen 
     ON ap_lpo.gml_id = alkis_beziehungen.beziehung_von
   JOIN ax_gebaeude 
     ON alkis_beziehungen.beziehung_zu = ax_gebaeude.gml_id
  WHERE ap_lpo.art = 'Pfeil'
    AND alkis_beziehungen.beziehungsart = 'dientZurDarstellungVon';

COMMENT ON VIEW s_zuordungspfeil_gebaeude IS 'fuer Kartendarstellung: Zuordnungspfeil für Gebäude-Nummer';


-- Sichten vom OBK (Oberbergischer Kreis)
-- --------------------------------------

-- Dazu notwendig: Feld "ax_besondereflurstuecksgrenze.artderflurstuecksgrenze" als Array "integer[]" !
-- Anpassung DB-Schema erfolgte am 18.09.2011


CREATE VIEW sk2004_zuordnungspfeil 
AS
 SELECT ap.ogc_fid, ap.wkb_geometry 
 FROM ap_lpo ap 
 WHERE ((ap.signaturnummer = 2004) 
   AND ('DKKM1000'::text ~~ ANY ((ap.advstandardmodell)::text[])));

COMMENT ON VIEW sk2004_zuordnungspfeil IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer"';
-- krz: ap.signaturnummer is NULL in allen Sätzen
--      Siehe s_zuordungspfeil_flurstueck 

CREATE VIEW sk2004_zuordnungspfeil_spitze 
AS
 SELECT ap.ogc_fid, (((st_azimuth(st_pointn(ap.wkb_geometry, 1), 
        st_pointn(ap.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(ap.wkb_geometry) AS wkb_geometry 
 FROM ap_lpo ap 
 WHERE ((ap.signaturnummer = 2004) 
   AND ('DKKM1000'::text ~~ ANY ((ap.advstandardmodell)::text[])));
-- krz: ap.signaturnummer is NULL in allen Sätzen


CREATE OR REPLACE VIEW sk2012_flurgrenze 
AS 
 SELECT fg.ogc_fid, fg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze fg
  WHERE (3000 = ANY (fg.artderflurstuecksgrenze)) 
    AND fg.advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk2012_flurgrenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Flurgrenze"';


CREATE OR REPLACE VIEW sk2014_gemarkungsgrenze 
AS 
 SELECT gemag.ogc_fid, gemag.wkb_geometry
   FROM ax_besondereflurstuecksgrenze gemag
  WHERE (7003 = ANY (gemag.artderflurstuecksgrenze)) 
    AND gemag.advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk2014_gemarkungsgrenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Gemarkungsgrenze"';


CREATE OR REPLACE VIEW sk2018_bundeslandgrenze 
AS 
 SELECT blg.ogc_fid, blg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze blg
  WHERE (7102 = ANY (blg.artderflurstuecksgrenze)) 
    AND blg.advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk2018_bundeslandgrenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Bundeslandgrenze"';


CREATE OR REPLACE VIEW sk2020_regierungsbezirksgrenze 
AS 
 SELECT rbg.ogc_fid, rbg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze rbg
  WHERE (7103 = ANY (rbg.artderflurstuecksgrenze)) 
    AND rbg.advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk2020_regierungsbezirksgrenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Regierungsbezirksgrenze"';


CREATE OR REPLACE VIEW sk2022_gemeindegrenze 
AS 
 SELECT gemg.ogc_fid, gemg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze gemg
  WHERE (7106 = ANY (gemg.artderflurstuecksgrenze)) 
    AND gemg.advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk2022_gemeindegrenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Gemeindegrenze"';


-- Zusammenfassung "Politische Grenzen"  Art= 7102, 7103, 7104, 7106

-- Grenze der Bundesrepublik Deutschland 7101 (G)
-- Grenze des Bundeslandes 7102 (G)
-- Grenze des Regierungsbezirks 7103 (G)
-- Grenze des Landkreises 7104 (G)
-- Grenze der Gemeinde 7106
-- Grenze des Gemeindeteils 7107
-- Grenze der Verwaltungsgemeinschaft 7108

CREATE OR REPLACE VIEW sk201x_politische_grenze 
AS 
 SELECT ogc_fid, artderflurstuecksgrenze as art, wkb_geometry
   FROM ax_besondereflurstuecksgrenze

-- WHERE ( ANY (artderflurstuecksgrenze) IN (7102,7103,7104,7106) ) 

  WHERE (7102 = ANY (artderflurstuecksgrenze) 
     OR  7102 = ANY (artderflurstuecksgrenze) 
     OR  7103 = ANY (artderflurstuecksgrenze) 
     OR  7104 = ANY (artderflurstuecksgrenze) 
     OR  7106 = ANY (artderflurstuecksgrenze)
    )
    AND advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk201x_politische_grenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze Politische Grenzen (Bund, Land, Kreis, Gemeinde)';
-- Gefällt mir nicht!
-- Array-Felder eignen sich nicht als Filter. Optimierung: in Tabelle speichern


--  ------------------------------------------
--  Sichten fuer Fehlersuche und Daten-Analyse
--  ------------------------------------------


-- Flurstücke mit Anzeige der Flurstücksnummer an der "Standardposition"

-- Nach der Konvertierung aus ALK hat zunächst jedes Flurstück eine explizit gesetzte Position der Flurstücksnummer.

-- Nach einer manuellen Teilung bekommen die neuen Flurstücke im ALKIS nur dann eine Position,
-- wenn die Positioin manuell bestimmt (verschoben) wurde.
-- Wenn die Flurstücksnummer an ihrer "Standardposition" angezeigt werden soll, 
-- dann wird diese in den Daten (DHK, NAS) nicht gesetzt.
-- Der Konverter PostNAS konvertiert aber nur die Daten, die er bekommt, er setzt nicht die Standard-Position 
-- für die Flurstücke, die ohne eine manuelle Position kommen.

-- Diese Fälle identifizieren
CREATE OR REPLACE VIEW flstnr_ohne_position
AS 
 SELECT f.gml_id, 
        f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS such -- Suchstring für ALKIS-Navigation nach FS-Kennzeichen
 FROM        ax_flurstueck     f 
   LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.gml_id
 --LEFT JOIN ap_pto            p  ON p.gml_id       = v.beziehung_von
  WHERE v.beziehungsart is NULL
--ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler
  ;

COMMENT ON VIEW flstnr_ohne_position IS 'Flurstücke ohne manuell gesetzte Position für die Präsentation der FS-Nr';


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

CREATE OR REPLACE VIEW baurecht
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
      -- , d.stellenart                -- weiter entschluesseln?
    FROM ax_bauraumoderbodenordnungsrecht r
    LEFT JOIN ax_bauraumoderbodenordnungsrecht_artderfestlegung a
      ON r.artderfestlegung = a.wert
    LEFT JOIN ax_dienststelle d
      ON r.land = d.land AND r.stelle = d.stelle
 ;

-- MAP NEU:
-- DATA "wkb_geometry from (SELECT ogc_fid, gml_id, adfkey, name, stelle, rechtbez, adfbez, stellbez, wkb_geometry FROM baurecht) as foo using unique ogc_fid using SRID=25832" # gespeicherter View


-- Man glaubt es kaum, aber im ALKIS haben Gemeinde und Gemarkung keinerlei Beziehung miteinander
-- Nur durch Auswertung der Flurstücke kann man ermitteln, in welcher Gemeinde eine Gemarkung liegt.

-- 2011-12-08 umbenannt

CREATE OR REPLACE VIEW gemarkung_in_gemeinde
AS
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
;

COMMENT ON VIEW gemarkung_in_gemeinde IS 'Welche Gemarkung liegt in welcher Gemeinde? Durch Verweise aus Flurstück.';


-- Untersuchen, welche Geometrie-Typen vorkommen

CREATE OR REPLACE VIEW arten_von_flurstuecksgeometrie
AS
 SELECT   count(gml_id) as anzahl,
          st_geometrytype(wkb_geometry)
 FROM     ax_flurstueck
 GROUP BY st_geometrytype(wkb_geometry);


-- A d r e s s e n 

-- Verschluesselte Lagebezeichnung (Strasse und Hausnummer) fuer eine Gemeinde
-- Schluessel der Gemeinde nach Bedarf anpassen!

--  FEHLER: Funktion to_char(character varying, unknown) existiert nicht


CREATE VIEW  adressen_hausnummern
AS
    SELECT 
        s.bezeichnung AS strassenname, 
         g.bezeichnung AS gemeindename, 
         l.land, 
         l.regierungsbezirk, 
         l.kreis, 
         l.gemeinde, 
         l.lage        AS strassenschluessel, 
         l.hausnummer 
    FROM   ax_lagebezeichnungmithausnummer l  
    JOIN   ax_gemeinde g 
      ON l.kreis=g.kreis 
     AND l.gemeinde=g.gemeinde 
    JOIN   ax_lagebezeichnungkatalogeintrag s 
      ON l.kreis=s.kreis 
     AND l.gemeinde=s.gemeinde 
     AND l.lage = s.lage        -- ab PostNAS 0.6
    WHERE     l.gemeinde = 40;  -- "40" = Stadt Lage


-- Zuordnung dieser Adressen zu Flurstuecken
-- Schluessel der Gemeinde nach Bedarf anpassen!

CREATE VIEW adressen_zum_flurstueck
AS
    SELECT
           f.gemarkungsnummer, 
           f.flurnummer, 
           f.zaehler, 
           f.nenner,
           g.bezeichnung AS gemeindename, 
           s.bezeichnung AS strassenname, 
           l.lage        AS strassenschluessel, 
           l.hausnummer 
      FROM   ax_flurstueck f 
      JOIN   alkis_beziehungen v 
        ON f.gml_id=v.beziehung_von
      JOIN   ax_lagebezeichnungmithausnummer l  
        ON l.gml_id=v.beziehung_zu
      JOIN   ax_gemeinde g 
        ON l.kreis=g.kreis 
       AND l.gemeinde=g.gemeinde 
      JOIN   ax_lagebezeichnungkatalogeintrag s 
        ON l.kreis=s.kreis 
       AND l.gemeinde=s.gemeinde 
       AND l.lage = s.lage   -- ab PostNAS 0.6
     WHERE v.beziehungsart='weistAuf'
       AND l.gemeinde = 40  -- "40" = Stadt Lage
     ORDER BY 
           f.gemarkungsnummer,
           f.flurnummer,
           f.zaehler,
           f.nenner;


-- Flurstücke eines Eigentümers
-- ----------------------------

-- Dieser View liefert nur die (einfache) Buchungsart "Grundstück"
-- Solche Fälle wie "Erbbaurecht an Grundstück" oder "Wohnungs-/Teileigentum an aufgeteiltes Grundstück"
-- oder "Miteigentum an aufteteiltes Grundstück" fehlen in deisere Auswertung.
-- Dazu siehe: "rechte_eines_eigentuemers".

-- Das Ergbenis ist gedacht für den Export als CSV und Weiterverarbeitung mit einer Tabellenkalkulation
-- oder einer einfachen Datenbank.

-- Auch ein Export als Shape ist moeglich (dafuer: geom hinzugefuegt, Feldnamen gekuerzt)
-- Kommando:
--  pgsql2shp -h localhost -p 5432 -f "/data/.../alkis_fs_gemeinde.shp"  [db-name]  public.flurstuecke_eines_eigentuemers

-- Übersicht der Tabellen:
--
-- Person <benennt< NamNum. >istBestandteilVon> Blatt <istBestandteilVon< Stelle >istGebucht> Flurstueck
--                                              *-> Bezirk                *-> Buchungsart     *-> Gemarkung

-- Wobei ">xxx>" = JOIN über die Verbindungs-Tabelle "alkis_beziehungen" mit der Beziehungsart "xxx".

CREATE VIEW flurstuecke_eines_eigentuemers 
AS 
   SELECT 
      k.bezeichnung                AS gemarkung, 
      k.gemarkungsnummer           AS gemkg_nr, 
      f.flurnummer                 AS flur, 
      f.zaehler                    AS fs_zaehler, 
      f.nenner                     AS fs_nenner, 
      f.amtlicheflaeche            AS flaeche, 
      f.wkb_geometry               AS geom,  -- fuer Export als Shape
   -- g.bezirk, 
      b.bezeichnung                AS bezirkname,
      g.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt, 
      g.blattart, 
      s.laufendenummer             AS bvnr, 
      art.bezeichner               AS buchgsart, 
   -- s.zaehler || '/' || s.nenner AS buchg_anteil, 
      n.laufendenummernachdin1421  AS name_num, 
   -- n.zaehler || '/' || n.nenner AS nam_anteil, 
      p.nachnameoderfirma          AS nachname --, 
   -- p.vorname 
   FROM       ax_person              p
        JOIN  alkis_beziehungen      bpn  ON bpn.beziehung_zu  = p.gml_id 
        JOIN  ax_namensnummer        n    ON bpn.beziehung_von =n.gml_id 
        JOIN  alkis_beziehungen      bng  ON n.gml_id = bng.beziehung_von 
        JOIN  ax_buchungsblatt       g    ON bng.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsblattbezirk b    ON g.land = b.land AND g.bezirk = b.bezirk 
        JOIN  alkis_beziehungen      bgs  ON bgs.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsstelle      s    ON s.gml_id = bgs.beziehung_von 
        JOIN  ax_buchungsstelle_buchungsart art ON s.buchungsart = art.wert 
        JOIN  alkis_beziehungen      bsf  ON bsf.beziehung_zu = s.gml_id
        JOIN  ax_flurstueck          f    ON f.gml_id = bsf.beziehung_von 
        JOIN  ax_gemarkung           k    ON f.land = k.land AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Gemeinde %'   -- ** Bei Bedarf anpassen!
     AND bpn.beziehungsart = 'benennt'           -- Namennummer     >> Person
     AND bng.beziehungsart = 'istBestandteilVon' -- Namensnummer    >> Grundbuch
     AND bgs.beziehungsart = 'istBestandteilVon' -- Buchungs-Stelle >> Grundbuch
     AND bsf.beziehungsart = 'istGebucht'        -- Flurstueck      >> Buchungs-Stelle
   ORDER BY   
         k.bezeichnung,
         f.flurnummer,
         f.zaehler,
         f.nenner,
         g.bezirk, 
         g.buchungsblattnummermitbuchstabenerweiterung,
         s.laufendenummer 
;


-- Rechte eines Eigentümers
-- ------------------------

-- Dieser View sucht speziell die Fälle wo eine Buchungsstelle ein Recht "an" einer anderen Buchungsstelle hat.
--  - "Erbbaurecht *an* Grundstück" 
--  - "Wohnungs-/Teileigentum *an* Aufgeteiltes Grundstück"
--  - "Miteigentum *an* Aufteteiltes Grundstück"
-- Suchkriterium ist der Name des Eigentümers auf dem "herrschenden" Grundbuch, also dem Besitzer des Rechtes.

-- Diese Fälle fehlen im View "flurstuecke_eines_eigentuemers".

-- Übersicht der Tabellen:
--
-- Person <benennt< NamNum. >istBestandteilVon> Blatt <istBestandteilVon< Stelle-h >an> Stelle-d >istGebucht> Flurstueck
-- 

-- Wobei ">xxx>" = JOIN über die Verbindungs-Tabelle "alkis_beziehungen" mit der Beziehungsart "xxx".


CREATE VIEW rechte_eines_eigentuemers 
AS
   SELECT 
      k.bezeichnung                AS gemarkung, 
      k.gemarkungsnummer           AS gemkg_nr, 
      f.flurnummer                 AS flur, 
      f.zaehler                    AS fs_zaehler, 
      f.nenner                     AS fs_nenner, 
      f.amtlicheflaeche            AS flaeche, 
      f.wkb_geometry               AS geom,  -- fuer Export als Shape
   -- g.bezirk, 
      b.bezeichnung                AS bezirkname,
      g.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt, 
   -- g.blattart, 
      sh.laufendenummer            AS bvnr_herr, 
      sh.zaehler || '/' || sh.nenner AS buchg_anteil_herr, 
      arth.bezeichner              AS buchgsa_herr, 
      bss.beziehungsart            AS bez_art,
      artd.bezeichner              AS buchgsa_dien, 
      sd.laufendenummer            AS bvnr_dien, 
   -- sd.zaehler || '/' || sd.nenner AS buchg_anteil_dien,
      n.laufendenummernachdin1421  AS name_num, 
   -- n.zaehler || '/' || n.nenner AS nam_anteil, 
      p.nachnameoderfirma          AS nachname --,  
   -- p.vorname 
   FROM       ax_person              p
        JOIN  alkis_beziehungen      bpn  ON bpn.beziehung_zu  = p.gml_id 
        JOIN  ax_namensnummer        n    ON bpn.beziehung_von =n.gml_id 
        JOIN  alkis_beziehungen      bng  ON n.gml_id = bng.beziehung_von 
        JOIN  ax_buchungsblatt       g    ON bng.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsblattbezirk b    ON g.land = b.land AND g.bezirk = b.bezirk 
        JOIN  alkis_beziehungen      bgs  ON bgs.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsstelle      sh   ON sh.gml_id = bgs.beziehung_von  -- herrschende Buchung
        JOIN  ax_buchungsstelle_buchungsart arth ON sh.buchungsart = arth.wert 
        JOIN  alkis_beziehungen      bss  ON sh.gml_id = bss.beziehung_von
        JOIN  ax_buchungsstelle      sd   ON sd.gml_id = bss.beziehung_zu   -- dienende Buchung
        JOIN  ax_buchungsstelle_buchungsart artd ON sd.buchungsart = artd.wert 
        JOIN  alkis_beziehungen      bsf  ON bsf.beziehung_zu = sd.gml_id
        JOIN  ax_flurstueck          f    ON f.gml_id = bsf.beziehung_von 
        JOIN  ax_gemarkung           k    ON f.land = k.land AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Stadt %'   -- ** Bei Bedarf anpassen!
     AND bpn.beziehungsart = 'benennt'           -- Namennummer     >> Person
     AND bng.beziehungsart = 'istBestandteilVon' -- Namensnummer    >> Grundbuch
     AND bgs.beziehungsart = 'istBestandteilVon' -- B-Stelle herr   >> Grundbuch
     AND bss.beziehungsart in ('an','zu')        -- B-Stelle herr.  >> B-Stelle dien.
     AND bsf.beziehungsart = 'istGebucht'        -- Flurstueck      >> B-Stelle dien
   ORDER BY   
         k.bezeichnung,
         f.flurnummer,
         f.zaehler,
         f.nenner,
         g.bezirk, 
         g.buchungsblattnummermitbuchstabenerweiterung,
         sh.laufendenummer 
;

-- END --

