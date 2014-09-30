-- =====
-- ALKIS
-- =====

--  PostNAS 0.8

--  -----------------------------------------
--  Sichten fuer Verwendung im mapfiles (wms)
--  -----------------------------------------

--  Dieses SQL sollte in jeder PostNAS-ALKIS-Datenbank verarbeitet werden, weil es vom Mapfile benötigt wird.

--  2012-04-17 flstnr_ohne_position
--  2012-04-24 pauschal Filter 'endet IS NULL' um historische Objekte auszublenden
--  2012-10-29 Redundanzen in Beziehungen suchen (entstehen durch replace)
--  2013-02-20 Mehrfache Buchungsstellen zum FS suchen, dies sind Auswirkungen eines Fehlers bei Replace
--  2013-03-05 Beschriftungen aus ap_pto auseinander sortieren, neuer View "grenzpunkt"
--  2013-03-12 Optimierung Hausnummern, View "gebaeude_txt" (Funktion und Name)
--  2013-04-15 Unterdrücken doppelter Darstellung in den Views 'ap_pto_stra', 'ap_pto_nam', 'ap_pto_rest'
--  2013-04-16 Thema "Bodenschätzung" und fehlernde Kommentare zum Views ergänzt.
--             Diese Datei aufgeteilt in "sichten.sql" und "sichten_wms.sql"
--  2013-04-22 art="PNR" (Pseudonummer)
--  2013-10-24 View ap_pto_stra wird ersetzt durch die Tabellen "pp_strassenname" und "pp_strassenklas", die im postProcessing gefüllt werden.
--  2014-02-24 Kein Filter auf advstandardmodell bei Flurstücks-Zuordnungspfeil
--  2014-08-26 View "ap_lto_stra" analog "ap_pto_stra" für Straßennamen auf Linien-Geometrie
--  2014-08-28 Die Tabelle "alkis_beziehungen" überflüssig machen.
--             Relationen nun direkt über neue Spalten in den Objekttabellen. 
--  2014-08-29 P- und L-Straßennamen gegenseitig ausschließen in ap_pto_stra und ap_lto_stra
--  2014-09-30 Umbenennung Schlüsseltabellen (Prefix)

-- Layer "ag_t_gebaeude"
-- ---------------------
-- Problem: Zu einigen Gebäuden gibt es mehrere Hausnummern.
-- Diese unterscheiden sich im Feld ap_pto.advstandardmodell
-- z.B. 3 verschiedene Einträge mit <NULL>, {DKKM500}, {DKKM1000}

-- Nimmt vorzugsweise den Text der Darstellung aus ap_pto (nach der Migration zunächst ibR immer gefüllt).
-- Wenn der nicht gefüllt ist, wird statt dessen die Nummer aus der verknüpften Labebezeichnung verwendet.

-- DROP VIEW IF EXISTS s_hausnummer_gebaeude;

CREATE OR REPLACE VIEW s_hausnummer_gebaeude 
AS 
 SELECT p.ogc_fid, 
        p.wkb_geometry,                       -- Point
        p.drehwinkel * 57.296 AS drehwinkel,  -- umn: ANGLE
    --  p.horizontaleausrichtung  AS hor,     -- = 'zentrisch'
    --  p.vertikaleausrichtung    AS ver,     -- = 'Basis' (oft), "Mitte" (selten)
    --  p.schriftinhalt,                      -- WMS: das bessere LABELITEM, kann aber leer sein
    --  l.hausnummer,                         -- WMS: LABELITEM default/native
        COALESCE(p.schriftinhalt, l.hausnummer) AS hausnummer
   FROM ap_pto p
   JOIN ax_lagebezeichnungmithausnummer l       ON l.gml_id = ANY (p.dientzurdarstellungvon) 
  WHERE p.art = 'HNR'
    AND 'DKKM1000' = ANY (p.advstandardmodell) -- erste Näherungslösung um Redundanzen zu unterdrücken
    AND p.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_hausnummer_gebaeude IS 'Sicht für Kartendarstellung: Hausnummern der Hauptgebäude.';
-- ibR: darzustellender Text steht immer in ap_pto.schriftinhalt
-- AED: ap_pto.schriftinhalt ist meist leer, nur selten ein Eintrag

-- ToDo: In PostProcessing die Hausnummer von l.hausnummer in p.schriftinhalt kopieren, wenn leer
--   Das würde die COALESCE-Trickserei ersparen

-- Layer "ag_t_nebengeb"
-- ---------------------
-- ax_gebaeude  >hat>  ax_lagebezeichnungmitpseudonummer, kein Drehwinkel.

-- DROP VIEW IF EXISTS lfdnr_nebengebaeude;

CREATE OR REPLACE VIEW lfdnr_nebengebaeude 
AS 
 SELECT g.ogc_fid, 
        g.wkb_geometry, 
        l.laufendenummer     -- umn: LABELITEM - die laufende Nummer des Nebengebaeudes
   FROM ax_gebaeude g
   JOIN ax_lagebezeichnungmitpseudonummer l
     ON g.hat = l.gml_id
   WHERE g.endet IS NULL AND l.endet IS NULL;

COMMENT ON VIEW lfdnr_nebengebaeude 
  IS 'Sicht für Kartendarstellung: Laufende Nummer des Nebengebäudes zu einer Lagebezeichnung mit der Flächengeometrie des Gebäudes';

-- Gebäude-Text
-- ------------

-- DROP VIEW IF EXISTS gebaeude_txt;

CREATE OR REPLACE VIEW gebaeude_txt 
AS 
 SELECT g.ogc_fid, 
        g.wkb_geometry,
        g.name,                    -- selten gefüllt 
        f.bezeichner AS funktion   -- umn: LABELITEM
   FROM ax_gebaeude g
   JOIN v_geb_funktion f 
     ON g.gebaeudefunktion = f.wert
  WHERE g.endet IS NULL 
    AND g.gebaeudefunktion < 9998; -- "Nach Quellenlage nicht zu spezifizieren" braucht man nicht anzeigen

COMMENT ON VIEW gebaeude_txt 
  IS 'Sicht für Kartendarstellung: Name zum Gebäude und Entschlüsselung der Gebäude-Funktion (Ersatz für Symbole)';

-- Layer "ag_p_flurstueck"
-- -----------------------

-- DROP VIEW IF EXISTS s_zugehoerigkeitshaken_flurstueck;

CREATE OR REPLACE VIEW s_zugehoerigkeitshaken_flurstueck 
AS 
 SELECT p.ogc_fid, 
        p.wkb_geometry, 
        p.drehwinkel * 57.296 AS drehwinkel
   FROM ap_ppo p
   JOIN ax_flurstueck f
     ON f.gml_id = ANY (p.dientZurDarstellungVon)  
  WHERE p.art = 'Haken'
    AND f.endet IS NULL
    AND p.endet IS NULL;

COMMENT ON VIEW s_zugehoerigkeitshaken_flurstueck 
  IS 'Sicht für Kartendarstellung: Zugehörigkeitshaken zum Flurstück.';

-- Layer "s_zuordungspfeil_flurstueck" (Signaturnummer 2004)
-- -----------------------------------

-- DROP VIEW IF EXISTS s_zuordungspfeil_flurstueck;

CREATE OR REPLACE VIEW s_zuordungspfeil_flurstueck 
AS 
 SELECT l.ogc_fid, 
        l.wkb_geometry
   FROM ap_lpo l
   JOIN ax_flurstueck f
     ON f.gml_id = ANY (l.dientZurDarstellungVon) 
  WHERE l.art = 'Pfeil'
    AND f.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeil_flurstueck 
  IS 'Sicht für Kartendarstellung: Zuordnungspfeil zur Flurstücksnummer, Liniengeometrie.';


-- DROP VIEW IF EXISTS s_zuordungspfeilspitze_flurstueck;

CREATE OR REPLACE VIEW s_zuordungspfeilspitze_flurstueck 
AS 
 SELECT l.ogc_fid, 
        (((st_azimuth(st_pointn(l.wkb_geometry, 1), 
        st_pointn(l.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(l.wkb_geometry) AS wkb_geometry 
   FROM ap_lpo l
   JOIN ax_flurstueck f
     ON f.gml_id = ANY (l.dientzurdarstellungvon) 
  WHERE l.art = 'Pfeil'
    AND f.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeilspitze_flurstueck 
  IS 'Sicht für Kartendarstellung: Zuordnungspfeil Flurstücksnummer, Spitze, Punktgeometrie mit Drehwinkel.';


-- Drehwinkel in Bogenmass, wird vom mapserver in Grad benötigt. Umrechnung durch Faktor (180 / Pi)

-- Zuordnungspfeil Bodenschätzung (Signaturnummer 2701)
-- ----------------------------------------------------

CREATE OR REPLACE VIEW s_zuordungspfeil_bodensch
AS 
 SELECT l.ogc_fid, 
        l.wkb_geometry
   FROM ap_lpo l
   JOIN ax_bodenschaetzung b
     ON b.gml_id = ANY (l.dientzurdarstellungvon)
  WHERE l.art = 'Pfeil'
    AND ('DKKM1000' = ANY (l.advstandardmodell))
    AND b.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeil_bodensch 
  IS 'Sicht für Kartendarstellung: Zuordnungspfeil Bodenschätzung, Liniengeometrie.';


-- DROP VIEW IF EXISTS s_zuordungspfeilspitze_bodensch;
 
CREATE OR REPLACE VIEW s_zuordungspfeilspitze_bodensch 
AS 
 SELECT l.ogc_fid, 
        (((st_azimuth(st_pointn(l.wkb_geometry, 1), 
        st_pointn(l.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(l.wkb_geometry) AS wkb_geometry 
   FROM ap_lpo l
   JOIN ax_bodenschaetzung b
     ON b.gml_id = ANY (l.dientzurdarstellungvon )
  WHERE l.art = 'Pfeil'
    AND 'DKKM1000' = ANY (l.advstandardmodell)
    AND b.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeilspitze_flurstueck IS 'Sicht für Kartendarstellung: Zuordnungspfeil Bodenschätzung, Spitze, Punktgeometrie mit Drehwinkel.';


-- Layer NAME "ap_pto_stra" (Straße) GROUP "praesentation"
-- -------------------------------------------------------
-- Von doppelten Textpositionen nur das passendere Modell anzeigen.
-- Eine Relation wird fuer die Gruppierung verwendet:
--  ap_pto >dientZurDarstellungVon> ax_lagebezeichnungohnehausnummer

-- 2014-08-26: Spalte gml_id hinzugefügt.
-- Auch Zeilen mit leerem Schriftinhalt verwenden. Das wird im PostProcessing noch ergänzt. 

-- DROP VIEW IF EXISTS ap_pto_stra;

CREATE OR REPLACE VIEW ap_pto_stra 
AS 
  SELECT p.ogc_fid,
         l.gml_id,                               -- wird im PP zum Nachladen aus Katalog gebraucht
      -- p.advstandardmodell       AS modell,    -- TEST
      -- l.unverschluesselt, l.lage AS schluessel, -- zur Lage  TEST
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.drehwinkel * 57.296     AS winkel,    -- * 180 / Pi
         p.wkb_geometry
    FROM ap_pto p
    JOIN ax_lagebezeichnungohnehausnummer l
      ON l.gml_id = ANY (p.dientzurdarstellungvon)
   WHERE  p.endet IS NULL
     AND  p.art IN ('Strasse','Weg','Platz','BezKlassifizierungStrasse') -- CLASSES im LAYER
     AND (   'DKKM1000' = ANY (p.advstandardmodell) -- "Lika 1000" bevorzugen
       -- OR 'DLKM'     = ANY (p.advstandardmodell) -- oder auch Kataster allgemein 
           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
          OR (p.advstandardmodell IS NULL
               -- Alternativen zur Legebezeichnung suchen in P- und L-Version
               AND (SELECT s.ogc_fid FROM ap_lto s -- irgend ein Feld eines anderen Textes (suchen)
                      JOIN ax_lagebezeichnungohnehausnummer ls ON ls.gml_id = ANY(s.dientzurdarstellungvon)
                     WHERE ls.gml_id = l.gml_id AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
                   ) IS NULL  -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
               AND (SELECT s.ogc_fid FROM ap_pto s
                      JOIN ax_lagebezeichnungohnehausnummer ls ON ls.gml_id = ANY(s.dientzurdarstellungvon)
                     WHERE ls.gml_id = l.gml_id AND NOT s.advstandardmodell IS NULL LIMIT 1 
                   ) IS NULL 
              ) 
         )
;

COMMENT ON VIEW ap_pto_stra 
  IS 'Sicht für Kartendarstellung: Beschriftung aus "ap_pto" für Lagebezeichnung mit Art "Straße", "Weg", "Platz" oder Klassifizierung.
 Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe. Dient im Script pp_laden.sql zum ersten Füllen der Tabelle "pp_strassenname_p".';

-- Daten aus dem View "ap_pto_stra" werden im PostProcessing gespeichert in den Tabellen "pp_strassenname" und "pp_strassenklas".
-- Der View übernimmt die Auswahl des passenden advstandardmodell und rechnet den Winkel passend um,
-- In der Tabelle werden dann die leer gebliebenen Label aus dem Katalog noch ergänzt.

-- DROP VIEW IF EXISTS ap_lto_stra;

CREATE OR REPLACE VIEW ap_lto_stra 
AS 
  SELECT p.ogc_fid,
         l.gml_id,                               -- wird im PP zum Nachladen aus Katalog gebraucht
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.wkb_geometry
    FROM ap_lto p
    JOIN ax_lagebezeichnungohnehausnummer l
      ON l.gml_id = ANY (p.dientzurdarstellungvon)
   WHERE  p.endet IS NULL
     AND  p.art   IN ('Strasse','Weg','Platz','BezKlassifizierungStrasse') -- Diese Werte als CLASSES in LAYER behandeln. 
     AND (    'DKKM1000' = ANY (p.advstandardmodell) -- "Lika 1000" bevorzugen
       --  OR 'DLKM'     = ANY (p.advstandardmodell) -- oder auch Kataster allgemein?
           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
           OR (p.advstandardmodell IS NULL
               -- Alternativen zur Legebezeichnung suchen in P- und L-Version
               AND (SELECT s.ogc_fid FROM ap_lto s -- irgend ein Feld eines anderen Textes (suchen)
                      JOIN ax_lagebezeichnungohnehausnummer ls ON ls.gml_id = ANY(s.dientzurdarstellungvon)
                     WHERE ls.gml_id = l.gml_id AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
                   ) IS NULL  -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
               AND (SELECT s.ogc_fid FROM ap_pto s
                      JOIN ax_lagebezeichnungohnehausnummer ls ON ls.gml_id = ANY(s.dientzurdarstellungvon)
                     WHERE ls.gml_id = l.gml_id AND NOT s.advstandardmodell IS NULL LIMIT 1 
                   ) IS NULL 
              ) 
         )
;

COMMENT ON VIEW ap_lto_stra 
  IS 'Sicht für Kartendarstellung: Beschriftung aus "ap_lto" für Lagebezeichnung mit Art "Straße", "Weg", "Platz" oder Klassifizierung.
 Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe. Dient im Script pp_laden.sql zum ersten Füllen der Tabelle "pp_strassenname_l".';

-- 2014-08-26: Daten aus dem View "ap_lto_stra" werden im PostProcessing gespeichert in den Tabellen "pp_strassenname_l".
-- Der View übernimmt die Auswahl des passenden advstandardmodell.
-- In der Tabelle werden dann die leer gebliebenen Label aus dem Katalog noch ergänzt.


-- Layer NAME "ap_pto_nam" GROUP "praesentation"
-- -------------------------------------------------------
-- 'NAM' = Name (Eigenname) und 'ZNM' = Zweitname (touristischer oder volkstümlicher Name) zu ...
--   -- AX_Strassenverkehr oder AX_Platz usw.
--  ap_pto >dientZurDarstellungVon> ?irgendwas?

-- Dieser View wird bisher nicht verwendet. Dazu müsste ein neuer Layer erzeugt werden und die 
-- Arten 'NAM' und 'ZNM' dann aus den View 'ap_pto_rest' heraus genommen werden.

-- Entweder Layer trennen nach Text-Typen "NAM"+"ZNM" und dem Rest
-- ODER           trennen nach fachlichen Ebenen wie "Nutzung" und "Gebäude" und ....

-- DROP VIEW IF EXISTS ap_pto_nam;

CREATE OR REPLACE VIEW ap_pto_nam 
AS 
  SELECT p.ogc_fid,
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.drehwinkel * 57.296     AS winkel,    -- * 180 / Pi
         p.wkb_geometry
    FROM ap_pto p
    JOIN nutzung l                      -- Im PostProcessing zusammen gefasste Nutzungsarten-Abschnitte
      ON l.gml_id = ANY (p.dientzurdarstellungvon) 
   WHERE NOT p.schriftinhalt IS NULL 
     AND  p.endet IS NULL                            -- nichts historisches
     AND  p.art   IN ('NAM','ZNM')                   -- CLASSES in LAYER
     AND ('DKKM1000' = ANY (p.advstandardmodell)     -- "Lika 1000" bevorzugen
           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
           OR (p.advstandardmodell IS NULL
               AND (SELECT s.gml_id                  -- irgend ein Feld
                      FROM ap_pto s                  -- eines anderen Textes (suchen)
                      JOIN nutzung l2                 -- Im PostProcessing zusammen gefasste Nutzungsarten-Abschnitte
                        ON l2.gml_id = ANY (s.dientzurdarstellungvon) 
                     WHERE NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
                   ) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         )
;

COMMENT ON VIEW ap_pto_nam 
  IS 'Sicht für Kartendarstellung: Beschriftung mit Art = Name/Zweitname. Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe.';
-- ToDo: Im PostProcessing in einer Tabelle speichern.


-- Layer NAME "ap_pto" GROUP "praesentation"
-- ----------------------------------------
-- REST: Texte, die nicht schon in einem anderen Layer ausgegeben werden
-- Ersetzt den View "s_beschriftung"
-- Doppelte Darstellung aufgrund verschiedener "advstandardmodell" zum Objekt unterdrücken analog ap_pto_stra und ap_pto_nam

-- DROP VIEW IF EXISTS ap_pto_rest;

CREATE OR REPLACE VIEW ap_pto_rest
AS 
  SELECT p.ogc_fid, 
         p.schriftinhalt, 
         p.art, 
         p.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
         p.wkb_geometry 
    FROM ap_pto p
   WHERE NOT p.schriftinhalt IS NULL
     AND NOT p.dientzurdarstellungvon IS NULL
     AND p.endet IS NULL
     AND p.art   NOT IN ('PNR','HNR','Strasse','Weg','Platz','BezKlassifizierungStrasse','AOG_AUG') -- 'PNR',
     -- Diese 'IN'-Liste fortschreiben bei Erweiterungen des Mapfiles
     -- 'PNR' = Pseudonummer (lfd.-Nr.-Nebengebäude), Inhalte wie "(1)" oder "P50" - kommt nicht mehr vor, oder?
    AND ('DKKM1000' = ANY (p.advstandardmodell)     -- "Lika 1000" bevorzugen
           -- Ersatzweise auch "keine Angabe" (null) akzeptieren, aber nur wenn ...
           OR (p.advstandardmodell IS NULL
               AND ( SELECT s.ogc_fid               -- irgend ein Feld
                      FROM ap_pto s
                     WHERE p.dientzurdarstellungvon = s.dientzurdarstellungvon -- gleiches Präsentationsobj.
                       AND NOT s.advstandardmodell IS NULL -- Irgend eine Angabe
                     LIMIT 1  -- einer reicht als Ausschlußkriterium
                    ) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         );

COMMENT ON VIEW ap_pto_rest 
  IS 'Sicht für Kartendarstellung: Beschriftungen aus "ap_pto", die noch nicht in anderen Layern angezeigt werden.';
-- ToDo: Im PostProcessing in einer Tabelle speichern.

-- Kommt PNR (Pseudonummer) noch im Bestand vor?
--  SELECT * FROM ap_pto WHERE art = 'PNR' LIMIT 100; 


-- Layer "s_zuordungspfeil_gebaeude"
-- -----------------------------------
-- DROP VIEW IF EXISTS s_zuordungspfeil_gebaeude;

CREATE OR REPLACE VIEW s_zuordungspfeil_gebaeude
AS 
 SELECT l.ogc_fid, 
     -- ap_lpo.art, -- TEST
        l.wkb_geometry
   FROM ap_lpo l
   JOIN ax_gebaeude g
     ON g.gml_id = ANY(l.dientzurdarstellungvon)
  WHERE l.art = 'Pfeil'
    AND g.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeil_gebaeude 
  IS 'Sicht für Kartendarstellung: Zuordnungspfeil für Gebäude-Nummer (Nebengebäude). Wird wahrscheinlich nicht mehr benötigt.';


-- Grenzpunkte
-- -----------
-- Zum Punktort des Grenzpunktes auch eine Information zur Vermarkung holen
-- DROP VIEW IF EXISTS grenzpunkt;

CREATE OR REPLACE VIEW grenzpunkt 
AS 
 SELECT o.ogc_fid, 
        o.wkb_geometry, 
     -- g.punktkennung,    -- ggf später als labelitem "rrrrrhhhhAnnnnn" "32483 5751 0 02002"
        g.abmarkung_marke  -- steuert die Darstellung >9000 = unvermarkt
   FROM ax_punktortta o
   JOIN ax_grenzpunkt g
     ON o.istteilvon = g.gml_id
   WHERE g.endet IS NULL
     AND g.endet IS NULL;

COMMENT ON VIEW grenzpunkt 
  IS 'Sicht für Kartendarstellung: Zusammenführung von Punktort (Geometrie) und AX_Grenzpunkt (Eigenschaften)';


-- Sichten vom OBK (Oberbergischer Kreis)
-- --------------------------------------

CREATE OR REPLACE VIEW sk2012_flurgrenze 
AS 
 SELECT fg.ogc_fid, fg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze fg
  WHERE 3000   = ANY (fg.artderflurstuecksgrenze)
    AND 'DLKM' = ANY (fg.advstandardmodell);

COMMENT ON VIEW sk2012_flurgrenze IS 'Sicht für Kartendarstellung: besondere Flurstücksgrenze "Flurgrenze"';

CREATE OR REPLACE VIEW sk2014_gemarkungsgrenze 
AS 
 SELECT gemag.ogc_fid, gemag.wkb_geometry
   FROM ax_besondereflurstuecksgrenze gemag
  WHERE 7003   = ANY (gemag.artderflurstuecksgrenze)
    AND 'DLKM' = ANY (gemag.advstandardmodell);

COMMENT ON VIEW sk2014_gemarkungsgrenze IS 'Sicht für Kartendarstellung: besondere Flurstücksgrenze "Gemarkungsgrenze"';

CREATE OR REPLACE VIEW sk2018_bundeslandgrenze 
AS 
 SELECT blg.ogc_fid, blg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze blg
  WHERE 7102   = ANY (blg.artderflurstuecksgrenze)
    AND 'DLKM' = ANY (blg.advstandardmodell);

COMMENT ON VIEW sk2018_bundeslandgrenze IS 'Sicht für Kartendarstellung: besondere Flurstücksgrenze "Bundeslandgrenze"';

CREATE OR REPLACE VIEW sk2020_regierungsbezirksgrenze 
AS 
 SELECT rbg.ogc_fid, rbg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze rbg
  WHERE 7103   = ANY (rbg.artderflurstuecksgrenze) 
    AND 'DLKM' = ANY (rbg.advstandardmodell);

COMMENT ON VIEW sk2020_regierungsbezirksgrenze IS 'Sicht für Kartendarstellung: besondere Flurstücksgrenze "Regierungsbezirksgrenze"';

CREATE OR REPLACE VIEW sk2022_gemeindegrenze 
AS 
 SELECT gemg.ogc_fid, gemg.wkb_geometry
   FROM ax_besondereflurstuecksgrenze gemg
  WHERE 7106   = ANY (gemg.artderflurstuecksgrenze) 
    AND 'DLKM' = ANY (gemg.advstandardmodell);

COMMENT ON VIEW sk2022_gemeindegrenze IS 'Sicht für Kartendarstellung: besondere Flurstücksgrenze "Gemeindegrenze"';


-- Zusammenfassung "Politische Grenzen"  Art= 7102, 7103, 7104, 7106

-- Grenze der Bundesrepublik Deutschland 7101 (G)
-- .. des Bundeslandes 7102 (G)
-- .. des Regierungsbezirks 7103 (G)
-- .. des Landkreises 7104 (G)
-- .. der Gemeinde 7106
-- .. des Gemeindeteils 7107
-- .. der Verwaltungsgemeinschaft 7108

CREATE OR REPLACE VIEW sk201x_politische_grenze 
AS 
 SELECT ogc_fid, artderflurstuecksgrenze as art, wkb_geometry
   FROM ax_besondereflurstuecksgrenze
--WHERE ( ANY (artderflurstuecksgrenze) IN (7102,7103,7104,7106) ) 
  WHERE (7102 = ANY (artderflurstuecksgrenze) 
     OR  7102 = ANY (artderflurstuecksgrenze) 
     OR  7103 = ANY (artderflurstuecksgrenze) 
     OR  7104 = ANY (artderflurstuecksgrenze) 
     OR  7106 = ANY (artderflurstuecksgrenze)
    )
    AND 'DLKM' = ANY (advstandardmodell);

COMMENT ON VIEW sk201x_politische_grenze IS 'Sicht für Kartendarstellung: besondere Flurstücksgrenze Politische Grenzen (Bund, Land, Kreis, Gemeinde)';
-- Gefällt mir nicht! Array-Felder eignen sich nicht als Filter. Optimierung: in Tabelle speichern


-- Gruppe: Bodenschätzung
-- ----------------------

-- Für Nachschlagen bei Feature-Info: Entschlüsselung in Langform zu einer Klassenfläche, ohne Geometrie.
CREATE OR REPLACE VIEW s_bodensch_ent
AS 
 SELECT bs.ogc_fid,
      --bs.advstandardmodell,   -- NUR TEST
        ka.bezeichner                      AS kulturart_e,
        ba.bezeichner                      AS bodenart_e,
        zs.bezeichner                      AS zustandsstufe_e,
        bs.bodenzahlodergruenlandgrundzahl AS grundz,
        bs.ackerzahlodergruenlandzahl      AS agzahl,
        ea1.bezeichner                     AS entstehart1,
        ea2.bezeichner                     AS entstehart2,
        -- entstehungsartoderklimastufewasserverhaeltnisse ist array!
        bs.sonstigeangaben,                           -- integer array  - Entschlüsseln?
        so1.bezeichner                     AS sonst1, -- Enstschlüsselung 
     -- so2.bezeichner                     AS sonst2, -- immer leer?
        bs.jahreszahl                                 -- integer
   FROM      ax_bodenschaetzung bs
   LEFT JOIN v_bschaetz_kulturart      ka ON bs.kulturart = ka.wert
   LEFT JOIN v_bschaetz_bodenart       ba ON bs.bodenart  = ba.wert
   LEFT JOIN v_bschaetz_zustandsstufe  zs ON bs.zustandsstufeoderbodenstufe = zs.wert
   LEFT JOIN v_bschaetz_entsteh_klima ea1 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[1] = ea1.wert   -- [1] fast immer gefüllt
   LEFT JOIN v_bschaetz_entsteh_klima ea2 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[2] = ea2.wert   -- [2] manchmal gefüllt
   LEFT JOIN v_bschaetz_sonst so1 ON bs.sonstigeangaben[1] = so1.wert -- [1] selten gefüllt
 --LEFT JOIN v_bschaetz_sonst so2 ON bs.sonstigeangaben[2] = so2.wert -- [2] fast nie
   WHERE bs.endet IS NULL;

COMMENT ON VIEW s_bodensch_ent IS 'Sicht für Feature-Info: Bodenschätzung, mit Langtexten entschlüsselt';

-- Variante 1: Nur EIN Layer. 
--             Label mittig in der Fläche, dann ist auch kein Zuordnungs-Pfeil notwendig.

-- Klassenfläche (Geometrie) mit ihrem Kurz-Label-Text, der dann mittig an Standardposition angezeigt werden kann. 
CREATE OR REPLACE VIEW s_bodensch_wms
AS 
 SELECT bs.ogc_fid,
        bs.wkb_geometry,
     -- bs.advstandardmodell,     -- NUR TEST
     -- bs.entstehungsartoderklimastufewasserverhaeltnisse AS entstehart, -- Array der Keys, NUR TEST
        ka.kurz AS kult,  -- Kulturart, CLASSITEM, steuert die Farbe
     -- Viele Felder zusammen packen zu einem kompakten Zwei-Zeilen-Label:
          ba.kurz  ||             -- Bodenart
          zs.kurz  ||             -- Zustandsstufe
          ea1.kurz ||             -- Entstehungsart oder Klimastufe, Wasserverhaeltnisse ist ein Array mit 1 bis 2 Elementen
          coalesce (ea2.kurz, '') -- NULL vermeiden!
          || ' ' ||               -- Zeilenwechsel im Label (UMN: WRAP)
          bs.bodenzahlodergruenlandgrundzahl || '/' ||
          bs.ackerzahlodergruenlandzahl 
        AS derlabel               -- LABELITEM Umbruch am Blank
   FROM      ax_bodenschaetzung bs
   LEFT JOIN v_bschaetz_kulturart      ka ON bs.kulturart = ka.wert
   LEFT JOIN v_bschaetz_bodenart       ba ON bs.bodenart  = ba.wert
   LEFT JOIN v_bschaetz_zustandsstufe  zs ON bs.zustandsstufeoderbodenstufe = zs.wert
   LEFT JOIN v_bschaetz_entsteh_klima ea1 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[1] = ea1.wert   -- [1] fast immer gefüllt
   LEFT JOIN v_bschaetz_entsteh_klima ea2 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[2] = ea2.wert   -- [2] manchmal gefüllt
   WHERE bs.endet IS NULL;

COMMENT ON VIEW s_bodensch_wms IS 'Sicht für Kartendarstellung: Bodenschätzung mit kompakten Informationen für Label.';


-- Variante 2: Fläche und Text als getrennte Layer. Text an manueller Position, 
--             ggf. außerhalb der Fläche. Dann ist ein Zuordnungspfeil notwendig.

-- Die Fläche ohne Label
CREATE OR REPLACE VIEW s_bodensch_po
AS
 SELECT ogc_fid,
        wkb_geometry,
        kulturart  -- Kulturart, numerischer Schlüssel, CLASSITEM
   FROM ax_bodenschaetzung
  WHERE endet IS NULL;

COMMENT ON VIEW s_bodensch_po IS 'Sicht für Kartendarstellung: Klassenfläche der Bodenschätzung ohne Label.';

-- Der Label zu den Klassenabschnitten
-- ACHTUNG: Zu einigen Abschnitten gibt es mehrerere (identische) Label an verschiedenen Positionen! 
CREATE OR REPLACE VIEW s_bodensch_tx
AS 
 SELECT bs.ogc_fid,
        p.wkb_geometry,           -- Geomterie (Punkt) des Labels
     -- bs.wkb_geometry,          -- Geometrie der Fläche, nicht des Label
        bs.advstandardmodell,     -- NUR TEST
     -- bs.entstehungsartoderklimastufewasserverhaeltnisse AS entstehart, -- Array der Keys, NUR TEST
        ka.kurz AS kult,  -- Kulturart, CLASSITEM, steuert die Farbe
     -- p.horizontaleausrichtung,  -- Feinpositionierung  ..    (zentrisch)
	 -- p.vertikaleausrichtung,    --  .. des Labels            (basis)   -> uc
     -- Viele Felder zusammen packen zu einem kompakten Zwei-Zeilen-Label:
          ba.kurz  ||              -- Bodenart
          zs.kurz  ||              -- Zustandsstufe
          ea1.kurz ||              -- Entstehungsart oder Klimastufe, Wasserverhaeltnisse
          coalesce (ea2.kurz, '')  -- Noch mal, ist ein Array mit 1 bis 2 Elementen
          || ' ' ||                -- Zeilenwechsel im Label (UMN: WRAP ' ')
          bs.bodenzahlodergruenlandgrundzahl || '/' ||
          bs.ackerzahlodergruenlandzahl 
        AS derlabel                -- LABELITEM, Umbruch am Leerzeichen
   FROM ap_pto                                 p
   JOIN ax_bodenschaetzung                     bs ON bs.gml_id = ANY(p.dientzurdarstellungvon)
   LEFT JOIN v_bschaetz_kulturart      ka ON bs.kulturart = ka.wert
   LEFT JOIN v_bschaetz_bodenart       ba ON bs.bodenart  = ba.wert
   LEFT JOIN v_bschaetz_zustandsstufe  zs ON bs.zustandsstufeoderbodenstufe = zs.wert
   LEFT JOIN v_bschaetz_entsteh_klima ea1 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[1] = ea1.wert 
   LEFT JOIN v_bschaetz_entsteh_klima ea2 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[2] = ea2.wert 
  WHERE  p.endet  IS NULL
     AND bs.endet IS NULL;

COMMENT ON VIEW s_bodensch_tx IS 'Sicht für Kartendarstellung: Kompakter Label zur Klassenfläche der Bodenschätzung an manueller Position. 
Der Label wird zusammengesetzt aus: Bodenart, Zustandsstufe, Entstehungsart oder Klimastufe/Wasserverhältnisse, Bodenzahl oder Grünlandgrundzahl und Ackerzahl oder Grünlandzahl.';

-- Redundanz suchen:
--  SELECT ogc_fid, count(advstandardmodell) AS anzahl FROM s_bodensch_tx GROUP BY ogc_fid HAVING count(advstandardmodell) > 1;
--  SELECT * FROM s_bodensch_tx WHERE ogc_fid in (2848, 1771, 3131, 3495) ORDER BY ogc_fid;

-- END --