
-- ===========================================================
-- Kommunale Flurstücke aus ALKIS selektieren
-- ===========================================================

-- Individuelle Auswertung "Kommunales Eigentum" für eine Stadt oder Gemeinde.
-- Ggf. müssen verschiedene Schreibweisen des Eigentümers oder Zusätze zum Namen berücksichtigt werden.

-- Stand:
--  2013-11-26 Version für die ALKIS-Musterdaten RLP Mustermonzel
--  2014-08-29 Umstellung auf Datenstruktur PostNAS 0.8 (ohne Tabelle "alkis_beziehungen")
--  2014-09-16 Substring fuer variabel lange gml_id
--  2014-09-30 Rückbau subsrting(gml_id), Umbenennung Schlüsseltabellen "ax_*" nach "v_*"
--  2014-12-16 Views für Gebiete im WMS, gefiltert nach individueller Gemeinde
--  2014-12-17 Spalte "gemeinde" in "pp_flur" nutzen

-- Voraussetzung = View "doppelverbindung" aus ALKIS PostNAS-Projekt Datei "sichten.sql"

-- ToDo: Umbenennen der Datei von "staedtische_FS" nach "staedtische_views" oder so ähnlich.


-- View für Shape-Export
-- ---------------------

--           DROP VIEW staedtische_flurstuecke;
CREATE OR REPLACE VIEW staedtische_flurstuecke
AS
  SELECT
     f.gml_id,
     f.land, f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner,
     f.amtlicheflaeche,
     f.wkb_geometry
  FROM ax_flurstueck f                                       -- Flurstück
  JOIN doppelverbindung d  ON d.fsgml=f.gml_id               -- beide Fälle über Union-View: direkt und über Recht von BS an BS
  JOIN ax_buchungsstelle s ON d.bsgml=s.gml_id               -- Buchungs-Stelle
  JOIN ax_buchungsblatt gb ON gb.gml_id=s.istbestandteilvon  -- Buchung >istBestandteilVon> Blatt
  JOIN ax_namensnummer nn  ON gb.gml_id=nn.istbestandteilvon -- Blatt <istBestandteilVon< NamNum
  JOIN ax_person p         ON p.gml_id=nn.benennt            -- NamNum  >benennt> Person
 WHERE f.endet  IS NULL
   AND s.endet  IS NULL
   AND gb.endet IS NULL
   AND nn.endet IS NULL
   AND p.endet  IS NULL
   AND p.nachnameoderfirma = 'Ortsgemeinde Osann-Monzel'; -- ** EIGENTÜMER / ERBBAUBERECHTIGTER **

-- Bei Schreib-Varianten wie "Stadt XXX - Wasserwerke -" oder  "Stadt XXX - Kanalbetriebe -"
-- muss hier ggf. der LIKE-Operator verwendet werden: LIKE "Stadt XXX%"

COMMENT ON VIEW staedtische_flurstuecke  IS 'Flurstücke der Ortsgemeinde Osann-Monzel. Für Shape-Export: Mit Kennzeichen und Fläche';


-- View für WMS
-- ---------------------

--        DROP    VIEW st_flurst;
CREATE OR REPLACE VIEW st_flurst
AS
  SELECT
     f.gml_id,
     d.ba_dien, -- Buchungsart der dienenden Buchung --> CLASSITEM im WMS
     f.wkb_geometry
  FROM ax_flurstueck f                                       -- Flurstück
  JOIN doppelverbindung d  ON d.fsgml=f.gml_id               -- beide Fälle über Union-View: direkt und über Recht von BS an BS
  JOIN ax_buchungsstelle s ON d.bsgml=s.gml_id               -- Buchungs-Stelle
  JOIN v_bs_buchungsart b  ON s.buchungsart=b.wert           -- Enstschlüsselung Buchungsart
  JOIN ax_buchungsblatt gb ON gb.gml_id=s.istbestandteilvon  -- Buchung >istBestandteilVon> Blatt
  JOIN ax_namensnummer nn  ON gb.gml_id=nn.istbestandteilvon -- Blatt <istBestandteilVon< NamNum
  JOIN ax_person p         ON p.gml_id=nn.benennt            -- NamNum  >benennt> Person
 WHERE f.endet  IS NULL
   AND s.endet  IS NULL
   AND gb.endet IS NULL
   AND nn.endet IS NULL
   AND p.endet  IS NULL
   AND p.nachnameoderfirma = 'Ortsgemeinde Osann-Monzel'; -- ** EIGENTÜMER / ERBBAUBERECHTIGTER **

COMMENT ON VIEW st_flurst  IS 'Flurstücke der Ortsgemeinde Osann-Monzel. Für WMS: nur ID und Geometrie.';

GRANT SELECT ON TABLE st_flurst TO ms6;


-- Buchungsarten darin?
/*
 SELECT DISTINCT 
     ba_dien, 
     count(gml_id) AS anzahl 
  FROM st_flurst 
  GROUP BY ba_dien
  ORDER BY ba_dien;
*/


-- Views für WMS Layer-Group "Gebiete"
-- -----------------------------------

-- Eine Filterung ist nicht notwendig wenn das NBA-Verfahren so eingerichtet ist,
-- dass keine Flurstücke aus Nachbargemeinden enthalten sind (fachliche Filterung).
-- Bei Geometrischer Filterung (Umring) rutschen immer ein paar rein.

-- Der Gemeinde-Schlüssel für die Filterung kann am besten aus der Tabelle pp_gemeinde ermittelt werden

-- Flur gefiltert
CREATE OR REPLACE VIEW gebiet_flur
AS
  SELECT gid, gemarkung, flurnummer, the_geom 
    FROM pp_flur 
   WHERE gemeinde = '103'; -- Osann-Monzel
COMMENT ON VIEW gebiet_flur  IS 'Flurflächen (vereinfachte Geometrie), gefiltert nach Gemeinde.';
GRANT SELECT ON TABLE gebiet_flur TO ms6;

-- Gemarkung gefiltert
CREATE OR REPLACE VIEW gebiet_gemarkung
AS
  SELECT gid, gemarkungsname, simple_geom
    FROM pp_gemarkung
   WHERE gemeinde = '103'; -- Osann-Monzel
COMMENT ON VIEW gebiet_gemarkung  IS 'Gemarkungsflächen (vereinfachte Geometrie), gefiltert nach Gemeinde.';
GRANT SELECT ON TABLE gebiet_gemarkung TO ms6;

-- Gemeinde gefiltert
CREATE OR REPLACE VIEW gebiet_gemeinde
AS
  SELECT gid, gemeindename, simple_geom
    FROM pp_gemeinde
   WHERE gemeinde = '103'; -- Osann-Monzel
COMMENT ON VIEW gebiet_gemeinde  IS 'Gemeindefläche (vereinfachte Geometrie), gefiltert nach Gemeinde.';
GRANT SELECT ON TABLE gebiet_gemeinde TO ms6;

-- the HAPPY end --