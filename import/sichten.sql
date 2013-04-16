-- =====
-- ALKIS
-- =====

--  -----------------------------------------
--  Sichten für Fehlersuche und Daten-Analyse
--  -----------------------------------------

--  Dieses SQL braucht nur bei Bedarf in einer PostNAS-DB verarbeitet werden.
--  Es werden zusätzliche Views einegerichtet, die nur bei Fehlersuche und Analys (vom Entwickler) benötigt werden.

--  PostNAS 0.7

--  2012-04-17 flstnr_ohne_position
--  2012-04-24 pauschal Filter 'endet IS NULL' um historische Objekte auszublenden
--  2012-10-29 Redundanzen in Beziehungen suchen (entstehen durch replace)
--  2013-02-20 Mehrfache Buchungsstellen zum FS suchen, dies sind Auswirkungen eines Fehlers bei Replace
--  2013-03-05 Beschriftungen aus ap_pto auseinander sortieren, neuer View "grenzpunkt"
--  2013-03-12 Optimierung Hausnummern, View "gebaeude_txt" (Funktion und Name)
--  2013-04-15 Unterdrücken doppelter Darstellung in den Views 'ap_pto_stra', 'ap_pto_nam', 'ap_pto_rest'
--  2013-04-16 Thema "Bodenschätzung" und fehlernde Kommentare zum Views ergänzt.
--             Diese Datei aufgeteilt in "sichten.sql" und "sichten_wms.sql"


-- Welche Karten-Typen ?
CREATE OR REPLACE VIEW kartentypen_der_texte_fuer_hnr
AS 
   SELECT DISTINCT advstandardmodell 
   FROM ap_pto p 
   WHERE p.art = 'HNR';
COMMENT ON VIEW kartentypen_der_texte_fuer_hnr 
  IS 'Datenanalyse: Kartentypen in Tabelle ap_pto für Hausnummern.';

-- Dies liefert:
--  "{DKKM1000}"
--  "{DKKM1000,DKKM500}"
--  "{DKKM500}"
--  NULL

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
COMMENT ON VIEW ap_pto_muell IS 'Datenanalyse: Beschriftungen aus "ap_pto", die NICHT dargestellt werden sollen.';


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
COMMENT ON VIEW flstnr_ohne_position IS 'Sicht für Datenanalyse: Flurstücke ohne manuell gesetzte Position für die Präsentation der FS-Nr';

-- Umbruch im Label? z.B. "Schwimm-/nbecken"
-- Sind 2 Buchstaben in Mapfile bei "WRAP" möglich?
CREATE OR REPLACE VIEW texte_mit_umbruch 
AS 
 SELECT ogc_fid, schriftinhalt, art
   FROM ap_pto 
  WHERE not schriftinhalt is null
    AND schriftinhalt like '%/n%';
COMMENT ON VIEW texte_mit_umbruch IS 'Sicht für Datenanalyse: Vorkommen eines Umbruchs im Label-Text.';

-- EXTENT für das Mapfile eines Mandanten ermitteln
CREATE OR REPLACE VIEW flurstuecks_minmax AS 
 SELECT min(st_xmin(wkb_geometry)) AS r_min, 
        min(st_ymin(wkb_geometry)) AS h_min, 
        max(st_xmax(wkb_geometry)) AS r_max, 
        max(st_ymax(wkb_geometry)) AS h_max
   FROM ax_flurstueck f
   WHERE f.endet IS NULL;
COMMENT ON VIEW flurstuecks_minmax IS 'Sicht für Datenanalyse: Maximale Ausdehnung von ax_flurstueck fuer EXTENT-Angabe im Mapfile.';

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
  WHERE r.endet IS NULL AND d.endet IS NULL ;
COMMENT ON VIEW baurecht IS 'Datenanalyse: Enstschlüsselte Felder zu einer Fläche des Baurechts.';

-- Man glaubt es kaum, aber im ALKIS haben Gemeinde und Gemarkung keinerlei Beziehung miteinander
-- Nur durch Auswertung der Flurstücke kann man ermitteln, in welcher Gemeinde eine Gemarkung liegt.
CREATE OR REPLACE VIEW gemarkung_in_gemeinde
AS
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  WHERE           endet IS NULL
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer;
COMMENT ON VIEW gemarkung_in_gemeinde IS 'Welche Gemarkung liegt in welcher Gemeinde? Durch Verweise aus Flurstück.';


-- Untersuchen, welche Geometrie-Typen vorkommen
CREATE OR REPLACE VIEW arten_von_flurstuecksgeometrie
AS
 SELECT   count(gml_id) as anzahl,
          st_geometrytype(wkb_geometry)
 FROM     ax_flurstueck
 WHERE    endet IS NULL
 GROUP BY st_geometrytype(wkb_geometry);
COMMENT ON VIEW arten_von_flurstuecksgeometrie IS 'Datenanalyse: vorkommende Geometry-Typen in Tabelle ax_flurstueck.';


-- A d r e s s e n 

-- Verschluesselte Lagebezeichnung (Strasse und Hausnummer) fuer eine Gemeinde
-- Schluessel der Gemeinde nach Bedarf anpassen!
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
     AND l.lage = s.lage
    WHERE l.gemeinde = 40;  -- "40" = Stadt Lage
COMMENT ON VIEW adressen_hausnummern IS 'Datenanalyse: Verschlüsselte Lagebezeichnung (Straße und Hausnummer) für eine Gemeinde. Schlüssel der Gemeinde nach Bedarf anpassen.';

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
       AND l.lage = s.lage
     WHERE v.beziehungsart='weistAuf'
       AND l.gemeinde = 40  -- "40" = Stadt Lage
     ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;
COMMENT ON VIEW adressen_zum_flurstueck IS 'Datenanalyse: Zuordnung von Adressen zu Flurstuecken. Schlüssel der Gemeinde nach Bedarf anpassen.';

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
     AND p.endet IS NULL AND n.endet IS NULL AND g.endet IS NULL AND b.endet IS NULL
     AND s.endet IS NULL AND f.endet IS NULL AND k.endet IS NULL
   ORDER BY k.bezeichnung, f.flurnummer, f.zaehler, f.nenner, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer;
COMMENT ON VIEW flurstuecke_eines_eigentuemers IS 'Muster für Export: Suchkriteriumnach Bedarf anpassen.';

-- Rechte eines Eigentümers
-- ------------------------
-- Dieser View sucht speziell die Fälle wo eine Buchungsstelle ein Recht "an" einer anderen Buchungsstelle hat.
--  - "Erbbaurecht *an* Grundstück" 
--  - "Wohnungs-/Teileigentum *an* Aufgeteiltes Grundstück"
--  - "Miteigentum *an* Aufteteiltes Grundstück"
-- Suchkriterium ist der Name des Eigentümers auf dem "herrschenden" Grundbuch, also dem Besitzer des Rechtes.

-- Diese Fälle fehlen im View "flurstuecke_eines_eigentuemers".

-- Übersicht der Tabellen:
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
     AND p.endet IS NULL AND n.endet IS NULL AND g.endet IS NULL AND b.endet IS NULL
     AND sh.endet IS NULL AND sd.endet IS NULL AND f.endet IS NULL AND k.endet IS NULL
   ORDER BY k.bezeichnung, f.flurnummer, f.zaehler, f.nenner, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung, sh.laufendenummer;
COMMENT ON VIEW rechte_eines_eigentuemers IS 'Muster für Export: Suchkriteriumnach Bedarf anpassen. Dies ergänzt "flurstuecke_eines_eigentuemers" um die Fälle mit besonderen Buchungen.';

-- Die 2 Views nur fuer Entwicklung: 

-- 	CREATE OR REPLACE VIEW beziehungen_redundant 
-- 	AS
-- 	 SELECT *
-- 	   FROM alkis_beziehungen AS bezalt
-- 	   WHERE EXISTS
-- 		   (SELECT ogc_fid
-- 			 FROM alkis_beziehungen AS bezneu
-- 			WHERE bezalt.beziehung_von = bezneu.beziehung_von
-- 			  AND bezalt.beziehung_zu  = bezneu.beziehung_zu
-- 			  AND bezalt.beziehungsart = bezneu.beziehungsart
-- 			  AND bezalt.ogc_fid       < bezneu.ogc_fid
-- 			);
-- 	COMMENT ON VIEW beziehungen_redundant IS 'Datenanalyse: alkis_beziehungen zu denen es eine identische neue Version gibt. Fehlersuche bei PostNAS-Trigger für Replace.';
--
-- 	CREATE OR REPLACE VIEW beziehungen_redundant_in_delete
-- 	AS
-- 	SELECT *
-- 	 FROM alkis_beziehungen AS bezalt
-- 	 WHERE EXISTS
-- 		   (SELECT ogc_fid
-- 			 FROM alkis_beziehungen AS bezneu
-- 			WHERE bezalt.beziehung_von = bezneu.beziehung_von
-- 			  AND bezalt.beziehung_zu  = bezneu.beziehung_zu
-- 			  AND bezalt.beziehungsart = bezneu.beziehungsart
-- 			  AND bezalt.ogc_fid       < bezneu.ogc_fid
-- 			)
-- 		 -- mit dem Zusatz nur die Faelle aus dem letzten Durchlauf,
-- 		 -- die aktuell noch in der Delete-Tabelle stehen
-- 		 AND EXISTS
-- 			(SELECT ogc_fid
-- 			 FROM delete
-- 			 WHERE bezalt.beziehung_von = substr(featureid, 1, 16)
-- 				OR bezalt.beziehung_zu  = substr(featureid, 1, 16)
-- 			);
-- 	COMMENT ON VIEW beziehungen_redundant_in_delete IS 'Datenanalyse: alkis_beziehungen zu denen es eine identische neue Version gibt und wo das Objekt noch in der delete-Tabelle vorkommt. Fehlersuche bei PostNAS-Trigger für Replace.';


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
--   SELECT b.beziehung_von, count(b.ogc_fid) AS anzahl
--     FROM alkis_beziehungen b
--    WHERE b.beziehungsart = 'istGebucht'
--   GROUP BY b.beziehung_von
--   HAVING count(b.ogc_fid) > 1;

COMMENT ON VIEW mehrfache_buchung_zu_fs IS 'Nach replace von ax_flurtstueck mit einer neuen ax_buchungsstelle bleibt die alte Verbindung in alkis_beziehungen';

-- END --