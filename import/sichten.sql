-- =====
-- ALKIS
-- =====

--  PostNAS 0.7

--  2012-02-25 PostNAS 07, Umbenennung
--  2012-04-17 flstnr_ohne_position
--  2012-04-24 pauschal Filter 'endet IS NULL' um historische Objekte auszublenden
--  2012-10-29 Redundanzen in Beziehungen suchen (entstehen durch replace)
--  2013-02-20 Mehrfache Buchungsstellen zum FS suchen, dies sind Auswirkungen eines Fehlers bei Replace
--  2013-03-05 Beschriftungen aus ap_pto auseinander sortieren, neuer View "grenzpunkt"
--  2013-03-12 Optimierung Hausnummern, View "gebaeude_txt" (Funktion und Name)
--  2013-04-15 Unterdrücken doppelter Darstellung in den Views 'ap_pto_stra', 'ap_pto_nam', 'ap_pto_rest'

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
    AND p.endet IS NULL
    AND f.endet IS NULL;
COMMENT ON VIEW s_flurstueck_nr IS 'fuer Kartendarstellung: Bruchnummerierung Flurstück (nur manuell gesetzte Positionen)';

-- Wenn keine manuelle Position gesetzt ist, wird die Flaechenmitte verwendet

-- ACHTUNG: Dieser View kann nicht direkt im Mapserver-WMS verwendet werden.
-- Die Anzeige ist zu langsam. Filterung über BBOX kann nicht funktionieren, da zunächst ALLE Standardpositionen 
-- berechnet werden müssen, bevor darüber gefiltert werden kann.

-- In einer Hilfstabelle mit geometrischem Index zwischenspeichern.
-- Siehe PostProcessing Tabelle "pp_flurstueck_nr"

CREATE OR REPLACE VIEW s_flurstueck_nr2
AS 
  SELECT f.ogc_fid, 
         p.wkb_geometry,  -- manuelle Position des Textes
         f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum
    FROM ap_pto             p
    JOIN alkis_beziehungen  v  ON p.gml_id       = v.beziehung_von
    JOIN ax_flurstueck      f  ON v.beziehung_zu = f.gml_id
   WHERE v.beziehungsart = 'dientZurDarstellungVon' 
     AND p.endet IS NULL
     AND f.endet IS NULL
 UNION 
  SELECT f.ogc_fid,
         ST_PointOnSurface(f.wkb_geometry) AS wkb_geometry,  -- Flaechenmitte als Position des Textes
         f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum
    FROM      ax_flurstueck     f 
    LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.gml_id
   WHERE v.beziehungsart is NULL
     AND f.endet IS NULL;

COMMENT ON VIEW s_flurstueck_nr2 IS 'Bruchnummerierung Flurstück, auch Standard-Position. Nicht direkt fuer WMS verwenden!';


-- Layer "ag_t_gebaeude"
-- ---------------------
-- Problem: Zu einigen Gebäuden gibt es mehrere Hausnummern.
-- Diese unterscheiden sich im Feld ap_pto.advstandardmodell
-- z.B. 3 verschiedene Einträge mit <NULL>, {DKKM500}, {DKKM1000}, (Beispiel; Lage, Lange Straße 15 c)

 --   DROP VIEW s_hausnummer_gebaeude;
 --	CREATE OR REPLACE VIEW s_hausnummer_gebaeude 
 --	AS 
 --	 SELECT p.ogc_fid, 
 --			p.wkb_geometry,				         -- Point
 --			p.drehwinkel * 57.296 AS drehwinkel, -- umn: ANGLE [drehwinkel]
 --			l.hausnummer				         -- umn: LABELITEM
 --	   FROM ap_pto p
 --	   JOIN alkis_beziehungen v
 --		 ON p.gml_id = v.beziehung_von
 --	   JOIN ax_lagebezeichnungmithausnummer l
 --		 ON v.beziehung_zu  = l.gml_id
 --	  WHERE v.beziehungsart = 'dientZurDarstellungVon'
 --		AND p.endet IS NULL
 --		AND l.endet IS NULL;
 --	COMMENT ON VIEW s_hausnummer_gebaeude IS 'fuer Kartendarstellung: Hausnummern Hauptgebäude';

-- Verbesserte Version 2013-03-07
-- Nimmt nun vorzugsweise den Text der Darstellung aus ap_pto (bei ibR immer gefüllt).
-- Wenn der nicht gefüllt ist, wird statt dessen die Nummer aus der verknüpften Labebezeichnung 
-- verwendet (der häufigste Fall bei AED). 
DROP VIEW s_hausnummer_gebaeude;
CREATE OR REPLACE VIEW s_hausnummer_gebaeude 
AS 
 SELECT p.ogc_fid, 
        p.wkb_geometry,			              -- Point
        p.drehwinkel * 57.296 AS drehwinkel,  -- umn: ANGLE
    --  p.art,
    --  p.advstandardmodell       AS modell,  -- TEST
    --  p.horizontaleausrichtung  AS hor,     -- = 'zentrisch'
    --  p.vertikaleausrichtung    AS ver,     -- = 'Basis' (oft), "Mitte" (selten)
    --  p.schriftinhalt,                      -- WMS: das bessere LABELITEM, kann aber leer sein
    --  l.hausnummer,                         -- WMS: LABELITEM default/native
        COALESCE(p.schriftinhalt, l.hausnummer) AS hausnummer
   FROM ap_pto p
   JOIN alkis_beziehungen v
     ON p.gml_id = v.beziehung_von
   JOIN ax_lagebezeichnungmithausnummer l
	 ON v.beziehung_zu  = l.gml_id
  WHERE p.art = 'HNR'
    AND 'DKKM1000' = ANY (p.advstandardmodell) -- erste Näherungslösung um Redundanzen zu unterdrücken
    AND v.beziehungsart = 'dientZurDarstellungVon'
	AND p.endet IS NULL
	AND l.endet IS NULL
-- LIMIT 200 -- TEST
;
COMMENT ON VIEW s_hausnummer_gebaeude IS 'fuer Kartendarstellung: Hausnummern Hauptgebäude';

-- Welche Karten-Typen ?
--   SELECT DISTINCT advstandardmodell FROM ap_pto p WHERE p.art = 'HNR';
-- Liefert:
--   "{DKKM1000}"
--   "{DKKM1000,DKKM500}"
--   "{DKKM500}"
--   ""    (IS NULL)

-- ibR (Mi-Lk): darzustellender Text steht immer in ap_pto.schriftinhalt 
-- AED (Lippe): ap_pto.schriftinhalt ist meist leer, nur selten ein Eintrag

-- ToDo: Wie bei ap_pto_stra von mehren ap_pto zu einer Hausnummer die geeignete auswählen

-- ToDo: In PostProcessing die Hausnummer von l.hausnummer in p.schriftinhalt kopieren, wenn leer
--   Das würde die COALESCE-Trickserei ersparen

-- Layer "ag_t_nebengeb"
-- ---------------------
-- 2013-03-05: Diese Abfrage liefert keine Daten mehr??
--	CREATE OR REPLACE VIEW s_nummer_nebengebaeude 
--	AS 
--	 SELECT p.ogc_fid, 
--			p.wkb_geometry, 
--			p.drehwinkel * 57.296 AS drehwinkel,	-- umn: ANGLE [drehwinkel]
--		 -- l.pseudonummer,			-- die HsNr des zugehoerigen Hauptgebaeudes
--			l.laufendenummer		-- umn: LABELITEM - die laufende Nummer des Nebengebaeudes
--	   FROM ap_pto p
--	   JOIN alkis_beziehungen v 
--		 ON p.gml_id = v.beziehung_von
--	   JOIN ax_lagebezeichnungmitpseudonummer l
--		 ON v.beziehung_zu  = l.gml_id
--	  WHERE v.beziehungsart = 'dientZurDarstellungVon'
--		AND p.endet IS NULL
--		AND l.endet IS NULL;
--	COMMENT ON VIEW s_nummer_nebengebaeude IS 'fuer Kartendarstellung: Hausnummern Nebengebäude';

-- Suche nach einem Ersatz:
-- ax_gebaeude  >hat>  ax_lagebezeichnungmitpseudonummer, kein Drehwinkel.
CREATE OR REPLACE VIEW lfdnr_nebengebaeude 
AS 
 SELECT g.ogc_fid, 
        g.wkb_geometry, 
    --  l.pseudonummer,			-- TEST die HsNr des zugehoerigen Hauptgebaeudes
        l.laufendenummer		-- umn: LABELITEM - die laufende Nummer des Nebengebaeudes
   FROM ax_gebaeude g
   JOIN alkis_beziehungen v 
     ON g.gml_id = v.beziehung_von
   JOIN ax_lagebezeichnungmitpseudonummer l
     ON v.beziehung_zu  = l.gml_id
   WHERE v.beziehungsart = 'hat'
     AND g.endet IS NULL
     AND g.endet IS NULL;
COMMENT ON VIEW lfdnr_nebengebaeude IS 'Laufende Nummer des Nebengebäudes zu einer Lagebezeichnung mit der Flächengeometrie des Gebäudes';


-- Gebäude-Text
-- ------------
CREATE OR REPLACE VIEW gebaeude_txt 
AS 
 SELECT g.ogc_fid, 
        g.wkb_geometry,
        g.name,                    -- selten gefüllt 
        f.bezeichner AS funktion   -- umn: LABELITEM
   FROM ax_gebaeude g
   JOIN ax_gebaeude_funktion f 
     ON g.gebaeudefunktion = f.wert
  WHERE g.endet IS NULL 
    AND g.gebaeudefunktion < 9998; -- "Nach Quellenlage nicht zu spezifizieren" braucht man nicht anzeigen
COMMENT ON VIEW gebaeude_txt IS 'Entschlüsselung der Gebäude-Funktion (Ersatz für Symbole)';

-- Layer "ag_p_flurstueck"
-- -----------------------
CREATE OR REPLACE VIEW s_zugehoerigkeitshaken_flurstueck 
AS 
 SELECT p.ogc_fid, 
        p.wkb_geometry, 
        p.drehwinkel * 57.296 AS drehwinkel,
        f.flurstueckskennzeichen
   FROM ap_ppo p
   JOIN alkis_beziehungen v
     ON p.gml_id = v.beziehung_von
   JOIN ax_flurstueck f
     ON v.beziehung_zu = f.gml_id
  WHERE p.art = 'Haken'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND f.endet IS NULL
    AND p.endet IS NULL;

COMMENT ON VIEW s_zugehoerigkeitshaken_flurstueck IS 'fuer Kartendarstellung';

-- Layer "s_zuordungspfeil_flurstueck"
-- -----------------------------------
CREATE OR REPLACE VIEW s_zuordungspfeil_flurstueck 
AS 
 SELECT l.ogc_fid, 
        l.wkb_geometry
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.gml_id = v.beziehung_von
   JOIN ax_flurstueck f
     ON v.beziehung_zu = f.gml_id
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND ('DKKM1000' ~~ ANY (l.advstandardmodell))
    AND f.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeil_flurstueck IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer';


CREATE OR REPLACE VIEW s_zuordungspfeilspitze_flurstueck 
AS 
 SELECT l.ogc_fid, 
        (((st_azimuth(st_pointn(l.wkb_geometry, 1), 
        st_pointn(l.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(l.wkb_geometry) AS wkb_geometry 
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.gml_id = v.beziehung_von
   JOIN ax_flurstueck f
     ON v.beziehung_zu = f.gml_id
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND ('DKKM1000' ~~ ANY (l.advstandardmodell))
    AND f.endet IS NULL
    AND l.endet IS NULL;

COMMENT ON VIEW s_zuordungspfeilspitze_flurstueck IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer, Spitze';

-- Drehwinkel in Bogenmass, wird vom mapserver in Grad benötigt.
-- Umrechnung durch Faktor (180 / Pi)


-- Layer NAME "ap_pto_stra" (Straße) GROUP "praesentation"
-- -------------------------------------------------------
-- Von doppelten Textpositionen nur das passendere Modell anzeigen.
-- Eine Relation wird fuer die Gruppierung verwendet:
--  ap_pto >dientZurDarstellungVon> ax_lagebezeichnungohnehausnummer
CREATE OR REPLACE VIEW ap_pto_stra 
AS 
  SELECT p.ogc_fid,
	  -- p.advstandardmodell       AS modell,    -- TEST
      -- l.gml_id, l.unverschluesselt, l.lage AS schluessel, -- zur Lage  TEST
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.drehwinkel * 57.296     AS winkel,    -- * 180 / Pi
         p.wkb_geometry
    FROM ap_pto p
    JOIN alkis_beziehungen v   -- Relation zur Lagebezeichnung o. HsNr.
      ON p.gml_id = v.beziehung_von
    JOIN ax_lagebezeichnungohnehausnummer l
      ON v.beziehung_zu = l.gml_id
   WHERE NOT p.schriftinhalt IS NULL 
     AND  p.endet IS NULL                            -- nichts historisches
     AND  p.art   IN ('Strasse','Weg','Platz','BezKlassifizierungStrasse') -- Diese Werte als CLASSES in LAYER behandeln. 
     AND  v.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
     AND ('DKKM1000' = ANY (p.advstandardmodell)     -- "Lika 1000" bevorzugen
           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
           OR (p.advstandardmodell IS NULL
               AND (SELECT s.ogc_fid                -- irgend ein Feld
					  FROM ap_pto s                 -- eines anderen Textes (suchen)
                      JOIN alkis_beziehungen vs     -- zur gleichen Lage o.HsNr
                        ON s.gml_id = vs.beziehung_von
                      JOIN ax_lagebezeichnungohnehausnummer ls
                        ON vs.beziehung_zu = ls.gml_id
                     WHERE ls.gml_id = l.gml_id
                       AND vs.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
                       AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
					) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         )
;
COMMENT ON VIEW ap_pto_stra IS 'Beschriftung aus ap_pto für Lagebezeichnung mit Art "Straße", "Weg", "Platz" oder Klassifizierung. Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe';


-- Layer NAME "ap_pto_nam" GROUP "praesentation"
-- -------------------------------------------------------
-- 'NAM' = Name (Eigenname) und 'ZNM' = Zweitname (touristischer oder volkstümlicher Name) zu ...
--   -- AX_Strassenverkehr oder AX_Platz usw.
--  ap_pto >dientZurDarstellungVon> ?irgendwas?

-- Dieser View wird bisher nicht verwendet. Dazu müsste ein neuer Layer erzeugt werden und die 
-- Arten 'NAM' und 'ZNM' dann aus den View 'ap_pto_rest' heraus genommen werden.

-- Entweder Layer trennen nach Text-Typen "NAM"+"ZNM" und dem Rest
-- ODER           trennen nach fachlichen Ebenen wie "Nutzung" und "Gebäude" und ....

CREATE OR REPLACE VIEW ap_pto_nam 
AS 
  SELECT p.ogc_fid,
	  -- p.advstandardmodell       AS modell,    -- TEST
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.drehwinkel * 57.296     AS winkel,    -- * 180 / Pi
         p.wkb_geometry
    FROM ap_pto p
    JOIN alkis_beziehungen v       
      ON p.gml_id = v.beziehung_von
  --JOIN nutzung l                      -- Im PostProcessing zusammen gefasste Nutzungsarten-Abschnitte
  --  ON v.beziehung_zu = l.gml_id
   WHERE NOT p.schriftinhalt IS NULL 
     AND  p.endet IS NULL                            -- nichts historisches
     AND  p.art   IN ('NAM','ZNM') -- Diese Werte als CLASSES in LAYER behandeln. 
     AND  v.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
     AND ('DKKM1000' = ANY (p.advstandardmodell)     -- "Lika 1000" bevorzugen
           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
           OR (p.advstandardmodell IS NULL
               AND (SELECT vs.beziehung_zu          -- irgend ein Feld
					  FROM ap_pto s                 -- eines anderen Textes (suchen)
                      JOIN alkis_beziehungen vs     -- zur gleichen ?irgendwas?
                        ON s.gml_id = vs.beziehung_von
                     WHERE vs.beziehung_zu = v.beziehung_zu
                       AND vs.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
                       AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
					) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         )
;
COMMENT ON VIEW ap_pto_nam IS 'Beschriftung mit Art = Name/Zweitname. Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe';


-- Layer NAME "ap_pto" GROUP "praesentation"
-- ----------------------------------------
-- REST: Texte, die nicht schon in einem anderen Layer ausgegeben werden
-- Ersetzt den View "s_beschriftung"

-- alte Version bis 2013-04-15
-- Nachteil: es werden mehrere Texte zum gleichen Objekt angezeigt die für verschiedene Maßstäbe gedacht sind.
--CREATE OR REPLACE VIEW ap_pto_rest 
--AS 
--  SELECT p.ogc_fid, 
--         p.schriftinhalt, 
--         p.art, 
--         p.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
--         p.wkb_geometry 
--    FROM ap_pto p
--   WHERE not p.schriftinhalt IS NULL 
--     AND p.endet IS NULL
--     AND p.art NOT IN ('HNR','Strasse','Weg','Platz','BezKlassifizierungStrasse','AOG_AUG');


-- 2013-04-15 Doppelte Darstellung aufgrund verschiedener "advstandardmodell" zum Objekt unterdrücken analog ap_pto_stra und ap_pto_nam
CREATE OR REPLACE VIEW ap_pto_rest 
AS 
  SELECT p.ogc_fid, 
         p.schriftinhalt, 
         p.art, 
         p.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
         p.wkb_geometry 
    FROM ap_pto p
    JOIN alkis_beziehungen v   -- Relation zur ?irgendwas?
      ON p.gml_id = v.beziehung_von
   WHERE not p.schriftinhalt IS NULL 
     AND p.endet IS NULL
     AND p.art   NOT IN ('HNR','Strasse','Weg','Platz','BezKlassifizierungStrasse','AOG_AUG')
     -- Diese 'IN'-Liste fortschreiben bei Erweiterungen des Mapfiles
     -- 'PNR' (Pseudonummer, lfd.-Nr.-Nebengebäude) kommt nicht mehr vor?
    AND  v.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
    AND ('DKKM1000' = ANY (p.advstandardmodell)     -- "Lika 1000" bevorzugen
           -- Ersatzweise auch "keine Angabe" (nul) akzeptieren, aber nur wenn es keinen besseren Text zu ?irgendwas? gibt
           -- Es wird hier nur bis zur Verbindungstabelle "alkis_beziehungen" gesucht, ob am anderen Ende die gleiche gml_id verlinkt ist.
           -- Diese gml_id können dann zu verschiedenen, unbekannten Objekttabellen linken.
           OR (p.advstandardmodell IS NULL
               AND (SELECT vs.beziehung_zu          -- irgend ein Feld
					  FROM ap_pto s                 -- eines anderen Textes (suchen)
                      JOIN alkis_beziehungen vs     -- zur gleichen ?irgendwas?
                        ON s.gml_id = vs.beziehung_von
                     WHERE vs.beziehung_zu = v.beziehung_zu
                       AND vs.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
                       AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Ausschlußkriterium
					) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         );
COMMENT ON VIEW ap_pto_rest IS 'Beschriftungen aus "ap_pto", die noch nicht in anderen Layern angezeigt werden';


-- Texte, die NICHT dargestellt werden sollen.
-- -------------------------------------------
-- Texte und Text-Fragmente aus der Konvertierung ALK+ALB, die noch nicht gelöscht worden sind.
CREATE OR REPLACE VIEW ap_pto_muell 
AS 
  SELECT p.ogc_fid, 
         p.schriftinhalt, 
         p.art, 
         p.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
         p.wkb_geometry 
    FROM ap_pto p
   WHERE not p.schriftinhalt IS NULL 
     AND p.endet IS NULL
     AND p.art IN ('AOG_AUG','PNR');
COMMENT ON VIEW ap_pto_muell IS 'Beschriftungen aus "ap_pto", die NICHT dargestellt werden sollen.';

-- ENDE BESCHRIFTUNG

-- Layer "s_zuordungspfeil_gebaeude"
-- -----------------------------------
CREATE OR REPLACE VIEW s_zuordungspfeil_gebaeude 
AS 
 SELECT l.ogc_fid, 
     -- alkis_beziehungen.beziehungsart, -- TEST
     -- ap_lpo.art, -- TEST
        l.wkb_geometry
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.gml_id = v.beziehung_von
   JOIN ax_gebaeude g
     ON v.beziehung_zu = g.gml_id
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND g.endet IS NULL
    AND l.endet IS NULL;
COMMENT ON VIEW s_zuordungspfeil_gebaeude IS 'fuer Kartendarstellung: Zuordnungspfeil für Gebäude-Nummer';

-- Grenzpunkte
-- -----------
--  ax_punktortta  >zeigtAuf?> AX_Grenzpunkt
-- Zum Punktort des Grenzpunktes auch eine Information zur Vermarkung holen
CREATE OR REPLACE VIEW grenzpunkt 
AS 
 SELECT o.ogc_fid, 
        o.wkb_geometry, 
     -- g.punktkennung,    -- ggf später als labelitem "rrrrrhhhhAnnnnn" "32483 5751 0 02002"
        g.abmarkung_marke, -- steuert die Darstellung >9000 = unvermarkt
        v.beziehungsart
   FROM ax_punktortta o
   JOIN alkis_beziehungen v 
     ON o.gml_id = v.beziehung_von
   JOIN ax_grenzpunkt g
     ON v.beziehung_zu  = g.gml_id
   WHERE v.beziehungsart = 'istTeilVon'
     AND g.endet IS NULL
     AND g.endet IS NULL;
COMMENT ON VIEW grenzpunkt IS 'Zusammenführung von Punktort (Geometrie) und AX_Grenzpunkt (Eigenschaften)';

-- Sichten vom OBK (Oberbergischer Kreis)
-- --------------------------------------
CREATE OR REPLACE VIEW sk2004_zuordnungspfeil 
AS
 SELECT ap.ogc_fid, ap.wkb_geometry 
 FROM ap_lpo ap 
 WHERE ((ap.signaturnummer = '2004') 
   AND ('DKKM1000'::text ~~ ANY ((ap.advstandardmodell)::text[])));
COMMENT ON VIEW sk2004_zuordnungspfeil IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer"';

CREATE OR REPLACE VIEW sk2004_zuordnungspfeil_spitze 
AS
 SELECT ap.ogc_fid, (((st_azimuth(st_pointn(ap.wkb_geometry, 1), 
        st_pointn(ap.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(ap.wkb_geometry) AS wkb_geometry 
 FROM ap_lpo ap 
 WHERE ((ap.signaturnummer = '2004') 
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
    AND advstandardmodell ~~ 'DLKM'::text;

COMMENT ON VIEW sk201x_politische_grenze IS 'fuer Kartendarstellung: besondere Flurstücksgrenze Politische Grenzen (Bund, Land, Kreis, Gemeinde)';
-- Gefällt mir nicht! Array-Felder eignen sich nicht als Filter. Optimierung: in Tabelle speichern


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
    AND f.endet IS NULL
--ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler
  ;
COMMENT ON VIEW flstnr_ohne_position IS 'Flurstücke ohne manuell gesetzte Position für die Präsentation der FS-Nr';

-- Umbruch im Label? z.B. "Schwimm-/nbecken"
-- Sind 2 Buchstaben in Mapfile bei "WRAP" möglich?
CREATE OR REPLACE VIEW texte_mit_umbruch 
AS 
 SELECT ogc_fid, schriftinhalt, art
   FROM ap_pto 
  WHERE not schriftinhalt is null
    AND schriftinhalt like '%/n%';


-- EXTENT für das Mapfile eines Mandanten ermitteln
CREATE OR REPLACE VIEW flurstuecks_minmax AS 
 SELECT min(st_xmin(wkb_geometry)) AS r_min, 
        min(st_ymin(wkb_geometry)) AS h_min, 
        max(st_xmax(wkb_geometry)) AS r_max, 
        max(st_ymax(wkb_geometry)) AS h_max
   FROM ax_flurstueck f
   WHERE f.endet IS NULL;
COMMENT ON VIEW flurstuecks_minmax IS 'Maximale Ausdehnung von ax_flurstueck fuer EXTENT-Angabe im Mapfile';

-- Nach Laden der Keytables:
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
      ON r.land   = d.land 
     AND r.stelle = d.stelle 
  WHERE r.endet IS NULL
    AND d.endet IS NULL ;

-- Man glaubt es kaum, aber im ALKIS haben Gemeinde und Gemarkung keinerlei Beziehung miteinander
-- Nur durch Auswertung der Flurstücke kann man ermitteln, in welcher Gemeinde eine Gemarkung liegt.
CREATE OR REPLACE VIEW gemarkung_in_gemeinde
AS
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  WHERE           endet IS NULL
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
;

COMMENT ON VIEW gemarkung_in_gemeinde IS 'Welche Gemarkung liegt in welcher Gemeinde? Durch Verweise aus Flurstück.';


-- Untersuchen, welche Geometrie-Typen vorkommen
CREATE OR REPLACE VIEW arten_von_flurstuecksgeometrie
AS
 SELECT   count(gml_id) as anzahl,
          st_geometrytype(wkb_geometry)
 FROM     ax_flurstueck
 WHERE    endet IS NULL
 GROUP BY st_geometrytype(wkb_geometry);


-- A d r e s s e n 

-- Verschluesselte Lagebezeichnung (Strasse und Hausnummer) fuer eine Gemeinde
-- Schluessel der Gemeinde nach Bedarf anpassen!

--  FEHLER: Funktion to_char(character varying, unknown) existiert nicht


CREATE OR REPLACE VIEW adressen_hausnummern
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

CREATE OR REPLACE VIEW adressen_zum_flurstueck
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

-- Punktförmige  P r ä s e n t a t i o n s o b j k t e  (ap_pto)
-- Ermittlung der vorkommenden Arten
CREATE OR REPLACE VIEW beschriftung_was_kommt_vor 
AS 
  SELECT DISTINCT art, horizontaleausrichtung, vertikaleausrichtung 
    FROM ap_pto 
   WHERE not schriftinhalt is null 
  ORDER BY art;
COMMENT ON VIEW beschriftung_was_kommt_vor IS 'Analyse der vorkommenden Kombinationen in ap_pto (Beschriftung)';

-- Ergebnis:
-- 2013: PostNAS 0.7  (aus 150,260,340)
-- ------------------
--	"AOG_AUG"				"zentrisch";"Basis"  - Schriftinhalkt immer nur "I" ?
--	"BWF"					"zentrisch";"Basis"/"zentrisch";"Mitte"
--	"BWF_ZUS"				"zentrisch";"Basis"
--	"FKT"					"zentrisch";"Basis"/"linksbündig";"Basis"/"zentrisch";"Mitte"
--	"FKT_TEXT"				"zentrisch";"Mitte"
--	"FreierText"			"zentrisch";"Basis"/"zentrisch";"Mitte"/"linksbündig";"Basis"
--	"FreierTextHHO"			"zentrisch";"Mitte"
--	"Friedhof"				"zentrisch";"Basis"
--	"Gewanne"				"zentrisch";"Basis"/"zentrisch";"Mitte"
--	"GFK"					"zentrisch";"Basis"/"zentrisch";"Mitte"
--	"HNR"					"zentrisch";"Basis"/"linksbündig";"Basis"/"zentrisch";"Mitte"  --> Hausnummer, group gebaeude
--	"HHO"					"zentrisch";"Mitte"  -- HHO = objekthoehe zu ax_gebaeude?
--	"NAM"					"zentrisch";"Basis"/"zentrisch";"Mitte"/"linksbündig";"Basis"
--	"SPO"					"zentrisch";"Basis"/
--	"Vorratsbehaelter"		"zentrisch";"Basis"
--	"WeitereHoehe"			"zentrisch";"Mitte"
--	"ZAE_NEN"				"zentrisch";"Basis"
--	"ZNM"					"zentrisch";"Basis"/"linksbündig";"Basis"

--* Layer "ap_pto_stra"
--                          hor ; ver / hor ; ver 
--	"BezKlassifizierungStrasse" "zent.";"Basis"	/ "linksbündig";"Basis"
--	"Platz"					"zentrisch";"Basis" / "zentrisch";"Mitte"
--	"Strasse"				"zentrisch";"Basis" / "zentrisch";"Mitte" / "linksbündig";"Basis"
--	"Weg"					"zentrisch";"Basis" / "zentrisch";"Mitte" / "linksbündig";"Basis"

--* geplanter layer "ap_pto_wasser"
--	"StehendesGewaesser"	"zentrisch";"Basis"
--	"Fliessgewaesser"		"zentrisch";"Basis"/"linksbündig";"Basis"


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

CREATE OR REPLACE VIEW flurstuecke_eines_eigentuemers 
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
     AND p.endet IS NULL 
     AND n.endet IS NULL
     AND g.endet IS NULL
     AND b.endet IS NULL
     AND s.endet IS NULL
     AND f.endet IS NULL
     AND k.endet IS NULL
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

-- Wobei ">xxx>" = JOIN über die Verbindungs-Tabelle "alkis_beziehungen" mit der Beziehungsart "xxx".


CREATE OR REPLACE VIEW rechte_eines_eigentuemers 
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
     AND p.endet IS NULL
     AND n.endet IS NULL
     AND g.endet IS NULL
     AND b.endet IS NULL
     AND sh.endet IS NULL
     AND sd.endet IS NULL
     AND f.endet IS NULL
     AND k.endet IS NULL
   ORDER BY   
         k.bezeichnung,
         f.flurnummer,
         f.zaehler,
         f.nenner,
         g.bezirk, 
         g.buchungsblattnummermitbuchstabenerweiterung,
         sh.laufendenummer 
;

CREATE OR REPLACE VIEW beziehungen_redundant 
AS
SELECT *
 FROM alkis_beziehungen AS bezalt
 WHERE EXISTS
       (SELECT ogc_fid
         FROM alkis_beziehungen AS bezneu
        WHERE bezalt.beziehung_von = bezneu.beziehung_von
          AND bezalt.beziehung_zu  = bezneu.beziehung_zu
          AND bezalt.beziehungsart = bezneu.beziehungsart
          AND bezalt.ogc_fid       < bezneu.ogc_fid
        );

COMMENT ON VIEW beziehungen_redundant IS 'alkis_beziehungen zu denen es eine identische neue Version gibt.';


CREATE OR REPLACE VIEW beziehungen_redundant_in_delete
AS
SELECT *
 FROM alkis_beziehungen AS bezalt
 WHERE EXISTS
       (SELECT ogc_fid
         FROM alkis_beziehungen AS bezneu
        WHERE bezalt.beziehung_von = bezneu.beziehung_von
          AND bezalt.beziehung_zu  = bezneu.beziehung_zu
          AND bezalt.beziehungsart = bezneu.beziehungsart
          AND bezalt.ogc_fid       < bezneu.ogc_fid
        )
     -- mit dem Zusatz nur die Faelle aus dem letzten Durchlauf,
     -- die aktuell noch in der Delet-Tabelle stehen
     AND EXISTS
        (SELECT ogc_fid
         FROM delete
         WHERE bezalt.beziehung_von = substr(featureid, 1, 16)
            OR bezalt.beziehung_zu  = substr(featureid, 1, 16)
        );

COMMENT ON VIEW beziehungen_redundant_in_delete IS 'alkis_beziehungen zu denen es eine identische neue Version gibt und wo das Objekt noch in der delete-Tabelle vorkommt.';


-- Suche nach Fehler durch "Replace"
-- Wenn ax_flurstueck über "replace" ausgetauscht wird und dabei gleichzeitig eine andere 
-- Buchungsstelle bekommt, dann bleibt die alte Buchungsstelle in den alkis_beziehungen.
-- Mail PostNAS Mailingliste von 2013-02-20
CREATE OR REPLACE VIEW mehrfache_buchung_zu_fs
AS
  SELECT f.gml_id, count(b.ogc_fid) AS anzahl
    FROM ax_flurstueck f
    JOIN alkis_beziehungen b
      ON f.gml_id = b.beziehung_von 
  WHERE b.beziehungsart = 'istGebucht'
  GROUP BY f.gml_id
  HAVING count(b.ogc_fid) > 1;

-- Noch einfacher? - Auch ohne JOIN wird das selbe Ergebnis geliefert.
-- Doppelte Verweise zählen ohne zu prüfen, ob die gml_id in ax_flurstueck existiert.
--  SELECT b.beziehung_von, count(b.ogc_fid) AS anzahl
--    FROM alkis_beziehungen b
--   WHERE b.beziehungsart = 'istGebucht'
--  GROUP BY b.beziehung_von
--  HAVING count(b.ogc_fid) > 1;

COMMENT ON VIEW mehrfache_buchung_zu_fs IS 'Nach replace von ax_flurtstueck mit einer neuen ax_buchungsstelle bleibt die alte Verbindung in alkis_beziehungen';

-- END --