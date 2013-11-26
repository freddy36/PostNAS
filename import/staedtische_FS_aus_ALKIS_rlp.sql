
-- ===========================================================
-- Kommunale Flurstücke aus ALKIS selektieren
-- ===========================================================

-- Individuelle Auswertung "Kommunales Eigentum" für eine Stadt oder Gemeinde.
-- Ggf. müssen verschiedene Schreibweisen des Eigentümers oder Zusätze zum Namen berücksichtigt werden.

-- Stand: 2013-11-26 - hier die Version für die ALKIS-Musterdaten RLP Mustermonzel


-- Voraussetzung = View "doppelverbindung" aus ALKIS PostNAS-Projekt Datei "sichten.sql"


-- View für Shape-Export
-- ---------------------

--           DROP VIEW st_flurst_exp;
CREATE OR REPLACE VIEW st_flurst_exp
AS
  SELECT   -- DISTINCT
     f.gml_id,
     f.land, f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner,
     f.amtlicheflaeche,
  -- f.flurstueckskennzeichen,
  -- p.nachnameoderfirma                -- Familienname
     f.wkb_geometry
  FROM ax_flurstueck    f               -- Flurstück
  JOIN doppelverbindung d               -- beide Fälle über Union-View: direkt und über Recht von BS an BS
    ON d.fsgml = f.gml_id 
  JOIN ax_buchungsstelle s              -- Buchungs-Stelle
    ON d.bsgml = s.gml_id 
  JOIN ax_buchungsstelle_buchungsart b  -- Enstschlüsselung der Buchungsart
    ON s.buchungsart = b.wert 
  JOIN alkis_beziehungen v3             -- Grundbuch (zur Buchungs-Stelle)
    ON s.gml_id = v3.beziehung_von  
  JOIN ax_buchungsblatt  gb 
    ON v3.beziehung_zu = gb.gml_id 
  JOIN alkis_beziehungen v4             -- Namensnummer (zum GB-Blatt)
    ON v4.beziehung_zu = gb.gml_id
  JOIN ax_namensnummer nn 
    ON v4.beziehung_von = nn.gml_id 
  JOIN alkis_beziehungen v5             -- Person (zur Namensnummer)
    ON v5.beziehung_von = nn.gml_id
  JOIN ax_person p
    ON v5.beziehung_zu = p.gml_id 
 WHERE v3.beziehungsart = 'istBestandteilVon'  -- Buchung  --> Blatt
   AND v4.beziehungsart = 'istBestandteilVon'  -- Blatt    --> NamNum
   AND v5.beziehungsart = 'benennt'            -- NamNum   --> Person
   AND f.endet IS NULL
   AND p.nachnameoderfirma = 'Ortsgemeinde Osann-Monzel'; -- ** EIGENTÜMER / ERBBAUBERECHTIGTER **

-- Bei Schreib-Varianten wie "Stadt XXX - Wasserwerke -" oder  "Stadt XXX - Kanalbetriebe -"
-- muss hier ggf. der LOKE-Operator verwendet werden: LIKE "Stadt XXX%"

COMMENT ON VIEW st_flurst_exp  IS 'Flurstücke der Ortsgemeinde Osann-Monzel. Für Shape-Export: Mit Kennzeichen und Fläche';


-- View für Shape-Export
--        DROP    VIEW st_flurst;
CREATE OR REPLACE VIEW st_flurst
AS
  SELECT   -- DISTINCT
     f.gml_id,
     d.ba_dien,                         -- Buchungsart der dienenden Buchung
  -- f.land, f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner,
  -- f.amtlicheflaeche,
  -- f.flurstueckskennzeichen,
  -- p.nachnameoderfirma                -- Familienname
     f.wkb_geometry
  FROM ax_flurstueck    f               -- Flurstück
  JOIN doppelverbindung d               -- beide Fälle über Union-View: direkt und über Recht von BS an BS
    ON d.fsgml = f.gml_id 
  JOIN ax_buchungsstelle s              -- Buchungs-Stelle
    ON d.bsgml = s.gml_id 
  JOIN ax_buchungsstelle_buchungsart b  -- Enstschlüsselung der Buchungsart
    ON s.buchungsart = b.wert 
  JOIN alkis_beziehungen v3             -- Grundbuch (zur Buchungs-Stelle)
    ON s.gml_id = v3.beziehung_von  
  JOIN ax_buchungsblatt  gb 
    ON v3.beziehung_zu = gb.gml_id 
  JOIN alkis_beziehungen v4             -- Namensnummer (zum GB-Blatt)
    ON v4.beziehung_zu = gb.gml_id
  JOIN ax_namensnummer nn 
    ON v4.beziehung_von = nn.gml_id 
  JOIN alkis_beziehungen v5             -- Person (zur Namensnummer)
    ON v5.beziehung_von = nn.gml_id
  JOIN ax_person p
    ON v5.beziehung_zu = p.gml_id 
 WHERE v3.beziehungsart = 'istBestandteilVon'  -- Buchung  --> Blatt
   AND v4.beziehungsart = 'istBestandteilVon'  -- Blatt    --> NamNum
   AND v5.beziehungsart = 'benennt'            -- NamNum   --> Person
   AND f.endet IS NULL
   AND p.nachnameoderfirma = 'Ortsgemeinde Osann-Monzel'; -- ** EIGENTÜMER / ERBBAUBERECHTIGTER **

COMMENT ON VIEW st_flurst  IS 'Flurstücke der Ortsgemeinde Osann-Monzel. Für WMS: nur ID und Geometrie.';

--GRANT SELECT ON TABLE st_flurst TO ms6;


-- Buchungsarten darin?
--    SELECT DISTINCT ba_dien, count(gml_id) AS anzahl FROM st_flurst GROUP BY ba_dien ORDER BY ba_dien;


-- the HAPPY end --