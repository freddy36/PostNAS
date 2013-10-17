
-- ALKIS PostNAS 0.7

-- Post Processing (pp_) Teil 3: Präsentationsobjekte ergänzen / reparieren

-- Dies Script "pp_praesentation_sichten.sql" dient der Vorschau der Reparatur, 
-- die mit dem Script "pp_praesentation_action.sql" durchgeführt wird.

-- Dies Script kann beim Anlegen der Datenbank verarbeitet werden und wenn sich die Sichten verändert haben. 
-- Das Action-Script muss im Rahmen des Post-Processing nach jeder Konvertierung laufen.

-- Stand 
--  2013-10-16  F.J. krz: Straßennamen fehlen in den Präsentationsobjekten, Tabelle "ap_pto"
--  2013-10-17  F.J. krz: Relation "dientZurDarstellungVon" macht es einfacher


-- ========================================
-- Straßen-Namen und Straßen-Klassifikation
-- ========================================

-- Bei den NAS-Daten, die vom Land Niedersachsen an die Kommunen abgegeben werden,
-- tritt in zunehmenden Umfang folgendes Problem auf (Stand Oktober 2013):

-- Die Namen und Klassifikationen der Straßen fehlen in der Tabelle "ap_pto".
-- Somit fehlt das Label für die Darstellung des Straßennamens in der Karte.
-- Position und Drehwinkel sind dort aber noch vorhanden.

-- Der Name, der in anderen Tabellen vorhanden ist, muss nach "ap_pto" kopiert werden,
-- damit die WMS-Kartendarstellung wieder komplett ist.

-- Tabelle: ap_pto
-- Spalten:
--  art:                         'strasse', 'BezKlassifizierungStrasse'
--  schriftinhalt:               leer
--  signaturnummer:              ??
--  drehwinkel und wkb_geometry: gefüllt

-- Hintergrund:
-- Der Straßenname ist nach der Migration der ALKIS-Daten aus ALB und ALK zunächst redundant gespeichert worden.
-- Er befindet sich "im Original" in "ax_lagebezeichnungkatalogeintrag.bezeichnung".
-- Für die Darstellung im Kartenbild ist der gleiche Name oder eine Variante davon (Abkürzung, getrennt-Schreibung) 
-- auch in jedem Präsentationsobjekt noch einmal abgelegt.
-- Diese Redundanz führt bei einer Änderung des Namens zu einem erhöhten Aufwand, weil er an mehreren Stellen geändrt werden muss..
-- Ziel ist es daher, die identischen Kopien des Namens-Textes in "ap_pto" nicht mehr zu führen.
-- Dort ist nur noch dann ein Eintrag zu finden, wenn der Text nicht identisch sind (Abkürzung, Getrennt-Schreibung).

-- Signaturnummern werden in ap_pto nur noch erfasst, wenn mehrere Werte möglich sind.

-- In Niedersachsen wurde oder wird das Löschen der identischen Texte in ap_pto möglicherweise als Nachmigration gezielt
-- durchgeführt. Die Mehrzahl der Texte ist bereits gelöscht!
-- In NRW tritt dies erst seit dem letzten Update der EQK (ibR, Stand Oktober 2013) zunächst bei den Fällen auf,
-- die seit dem Update fortgeführt wurden. Eine großflächige gezielte Entfernung wurde nicht bemerkt. 


-- Simulation der Fehlersituation in einem TEST-Bestand
-- ----------------------------------------------------
-- VORSICHT! - Nur in einer Test-Kopie ausführen. Löscht Daten!
  -- UPDATE ap_pto SET schriftinhalt = NULL  WHERE art = 'Strasse';
  -- UPDATE ap_pto SET schriftinhalt = NULL  WHERE art = 'BezKlassifizierungStrasse';


-- Anzeige der leeren Sätze
-- ---------------------------------------

-- Diese Views ermitteln, ob der Fall im vorliegenden Datenbestand vorkommt.

-- Dies ist in zunehmend in Niedersachsen der Fall. 
-- In NRW-Daten wurden weniger Fälle gefunden. Dann ist jeweils auch die Signaturnummer leer. 
-- Daher sollte "signaturnummer" nicht als Filter bei der "Reparatur" verwendet werden.


-- Aus Vorgängerversion, nicht mehr relevant:
 -- DROP VIEW pp_praes_strassen_name_ausnahmen;
 -- DROP VIEW pp_praes_strassen_name_mehrfach;


-- DROP VIEW pp_praes_strassen_name_leer;
CREATE OR REPLACE VIEW pp_praes_strassen_name_leer
AS
	SELECT gml_id, schriftinhalt, signaturnummer, art, drehwinkel
	  FROM ap_pto
	 WHERE schriftinhalt IS NULL
	   AND art = 'Strasse'
	-- AND (signaturnummer = '4107' OR signaturnummer = '8113') -- char
;
COMMENT ON VIEW pp_praes_strassen_name_leer 
  IS 'Es fehlt der Name der Straße in der Präsentationstabelle ap_pto.';


--DROP VIEW pp_praes_strassen_klass_leer;
CREATE OR REPLACE VIEW pp_praes_strassen_klass_leer
AS
	SELECT gml_id, schriftinhalt, signaturnummer, art, drehwinkel
	  FROM ap_pto
	 WHERE schriftinhalt IS NULL  -- oder '' ?
	   AND art = 'BezKlassifizierungStrasse'
	-- AND (signaturnummer = '4080' OR signaturnummer = '4140' OR signaturnummer = '8115')
;
COMMENT ON VIEW pp_praes_strassen_klass_leer 
  IS 'Es fehlt die Klassifikation der Straße in der Präsentationstabelle ap_pto.';


-- Diese Views sollen zeigen, welche Namen in "ap_pto.schriftinhalt" eingesetzt werden,
-- wenn die nachfolgenden update-Befehle ausgeführt werden.

-- Dies dient während der Entwicklung zu manuellen Vorab-Kontrolle.
-- Wenn hier keine Zeilen ausgegeben werden, kann die Ausführung dieses Scriptes im Workflow ausgeschaltet werden.
-- Dann sind die Namen noch gefüllt und brauchen nicht auf diese Weise rekonstruiert werden.


 DROP VIEW  pp_praes_strassen_name_update_vorschau;
CREATE OR REPLACE VIEW pp_praes_strassen_name_update_vorschau
AS
  SELECT -- p.gml_id AS gml_pto,
         k.bezeichnung,                              -- der Name aus dem Katalog, der nach ap_pto kopiert wird
         st_asewkt(p.wkb_geometry) AS label_geom     -- Lesbare Koordinaten: Wo liegt der Label?
  FROM   ax_lagebezeichnungkatalogeintrag  k         -- Katalog enthält den Straßennamen
    JOIN ax_lagebezeichnungohnehausnummer  l         -- dient als Lage ohne HsNr.
      ON ( k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk 
     AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
    JOIN alkis_beziehungen x ON l.gml_id = x.beziehung_zu  -- Relation ..
    JOIN ap_pto            p ON p.gml_id = x.beziehung_von -- .. zum Präsentationsobjekt
   WHERE p."art" = 'Strasse' -- Filter
     AND p.schriftinhalt      IS NULL                -- Text fehlt in ap_pto
     AND NOT (p.wkb_geometry  IS NULL)               -- hat aber eine Position in ap_pto
     AND x.beziehungsart = 'dientZurDarstellungVon'; -- Relation PTO - Lage o.HsNr

COMMENT ON VIEW pp_praes_strassen_name_update_vorschau 
  IS 'Präsentationsobjekt zu Straßen. Vorschau zum Update des Namens der in ap_pto.';


 DROP VIEW pp_praes_strassen_klass_update_vorschau;
CREATE OR REPLACE VIEW pp_praes_strassen_klass_update_vorschau
AS
  SELECT -- p.gml_id AS gml_pto,
         k.bezeichnung,                              -- der Name aus dem Katalog, der nach ap_pto kopiert wird
         st_asewkt(p.wkb_geometry) AS label_geom     -- Lesbare Koordinaten: Wo liegt der Label?
  FROM   ax_lagebezeichnungkatalogeintrag  k         -- Katalog enthält den Straßennamen
    JOIN ax_lagebezeichnungohnehausnummer  l         -- dient als Lage ohne HsNr.
      ON ( k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk 
     AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
    JOIN alkis_beziehungen x ON l.gml_id = x.beziehung_zu  -- Relation ..
    JOIN ap_pto            p ON p.gml_id = x.beziehung_von -- .. zum Präsentationsobjekt
   WHERE p."art" = 'BezKlassifizierungStrasse'       -- Filter
     AND p.schriftinhalt      IS NULL                -- Text fehlt in ap_pto
     AND NOT (p.wkb_geometry  IS NULL)               -- hat aber eine Position in ap_pto
     AND x.beziehungsart = 'dientZurDarstellungVon'; -- Relation PTO - Lage o.HsNr

COMMENT ON VIEW pp_praes_strassen_klass_update_vorschau 
  IS 'Präsentationsobjekt zu Straßen. Vorschau zum Update der Klassifikation der in ap_pto.';

-- ENDE --
