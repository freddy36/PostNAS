
-- ===========================================================
-- Kommunale Flurstücke aus ALKIS selektieren
-- ===========================================================

-- Individuelle Auswertung "Kommunales Eigentum" für eine Stadt oder Gemeinde.
-- Ggf. müssen verschiedene Schreibweisen des Eigentümers oder Zusätze zum Namen berücksichtigt werden.

-- Stand:
--  2013-11-26 Version für die ALKIS-Musterdaten RLP Mustermonzel
--  2014-08-29 Umstellung auf Datenstruktur PostNAS 0.8 (ohne Tabelle "alkis_beziehungen")
--  2014-09-16 Substring fuer variabal lange gml_id

-- Voraussetzung = View "doppelverbindung" aus ALKIS PostNAS-Projekt Datei "sichten.sql"


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
  FROM ax_flurstueck    f                                        -- Flurstück
  JOIN doppelverbindung d    ON d.fsgml = f.gml_id               -- beide Fälle über Union-View: direkt und über Recht von BS an BS
  JOIN ax_buchungsstelle s   ON d.bsgml = s.gml_id               -- Buchungs-Stelle
--JOIN ax_buchungsstelle_buchungsart b ON s.buchungsart = b.wert -- Enstschlüsselung Buchungsart
 
-- Bei gml_id character(16):
--JOIN ax_buchungsblatt  gb  ON gb.gml_id = s.istbestandteilvon  -- Buchung >istBestandteilVon> Blatt
--JOIN ax_namensnummer nn    ON gb.gml_id = nn.istbestandteilvon -- Blatt <istBestandteilVon< NamNum
--JOIN ax_person p           ON p.gml_id  = nn.benennt           -- NamNum  >benennt> Person

-- Bei gml_id character varying:
  JOIN ax_buchungsblatt  gb  ON substring(gb.gml_id,1,16)=s.istbestandteilvon  -- Buchung >istBestandteilVon> Blatt
  JOIN ax_namensnummer nn    ON substring(gb.gml_id,1,16)=nn.istbestandteilvon -- Blatt <istBestandteilVon< NamNum
  JOIN ax_person p           ON substring(p.gml_id,1,16) =nn.benennt           -- NamNum  >benennt> Person
 
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
  FROM ax_flurstueck    f                                        -- Flurstück
  JOIN doppelverbindung d    ON d.fsgml = f.gml_id               -- beide Fälle über Union-View: direkt und über Recht von BS an BS
  JOIN ax_buchungsstelle s   ON d.bsgml = s.gml_id               -- Buchungs-Stelle
  JOIN ax_buchungsstelle_buchungsart b ON s.buchungsart = b.wert -- Enstschlüsselung Buchungsart
 
-- Bei gml_id character(16):
--JOIN ax_buchungsblatt  gb  ON gb.gml_id = s.istbestandteilvon  -- Buchung >istBestandteilVon> Blatt
--JOIN ax_namensnummer nn    ON gb.gml_id = nn.istbestandteilvon -- Blatt <istBestandteilVon< NamNum
--JOIN ax_person p           ON p.gml_id  = nn.benennt           -- NamNum  >benennt> Person

-- Bei gml_id character varying:
  JOIN ax_buchungsblatt  gb  ON substring(gb.gml_id,1,16)=s.istbestandteilvon  -- Buchung >istBestandteilVon> Blatt
  JOIN ax_namensnummer nn    ON substring(gb.gml_id,1,16)=nn.istbestandteilvon -- Blatt <istBestandteilVon< NamNum
  JOIN ax_person p           ON substring(p.gml_id,1,16) =nn.benennt           -- NamNum  >benennt> Person
 
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

-- the HAPPY end --