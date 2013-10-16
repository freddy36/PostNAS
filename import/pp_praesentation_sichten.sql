
-- ALKIS PostNAS 0.7

-- Post Processing (pp_) Teil 3: Präsentationsobjekte ergänzen / reparieren

-- Dies Script "pp_praesentation_sichten.sql" dient der Vorbereitung der Reparatur, 
-- die mit dem Script "pp_praesentation_action.sql" durchgeführt wird.

-- Dies Script muss beim Anlegen der Datenbank verarbeitet werden und wenn sich die Sichten verändert haben. 
-- Das Action-Script muss im Rahmen des Post-Processing nach jeder Konvertierung laufen.

-- Stand 
--  2013-10-16  F.J. krz: Straßennamen fehlen in den Präsentationsobjekten, Tabelle "ap_pto"


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
-- Diese Redundanz führt bei einer Änderung des Namens zu einem erhöhten Aufwand.
-- Ziel ist es daher, die identischen Kopien des Namens-Textes in "ap_pto" nicht mehr zu führen.
-- Dort ist nur noch dann ein Eintrag zu finden, wenn Text (oder Signaturnummer?) nicht identisch sind.

-- Signaturnummern werden auch nur noch dann erfasst, wenn mehrere Werte möglich sind.

-- In Niedersachsen wurde oder wird das Löschen der identischen Texte in ap_pto möglicherweise als Nachmigration gezielt
-- durchgeführt. Die Mehrzahl der Texte ist bereits gelöscht!
-- In NRW tritt dies erst seit dem letzten Update der EQK (ibR, Stand Oktober 2013) zunächst bei den Fällen auf,
-- die seit dem Update fortgeführt wurden. Eine großflächige gezielte Entfernung wurde nicht bemerkt. 


-- Es soll versucht werden, dies Label durch die Zuordnung der Schrift-Position 
-- in einem Flurstück und über dessen Lagebezeichnung zu rekonstruieren.

-- "Label"   >liegt in>   "Flurstück"    >hat Lagebezeichnung>   "Straßenname"
--           (geometrische                 (Beziehung)
--           Verschniedung)


-- Simulation der Fehlersituation in einem TEST-Bestand
-- ----------------------------------------------------

-- VORSICHT! - Nur in einer Test-Kopie ausführen. Löscht Daten!

  -- UPDATE ap_pto SET schriftinhalt = NULL  WHERE art = 'Strasse';
  -- UPDATE ap_pto SET schriftinhalt = NULL  WHERE art = 'BezKlassifizierungStrasse';


-- Anzeige der leeren Sätze
-- ---------------------------------------

-- Diese Views ermitteln, ob der Fall im vorliegenden Datenbestand vorkommt.
-- Dies ist in zunehmend in Niedersachsen der Fall.

-- In NRW-Daten wurden weniger Fälle gefunden.

-- Dann ist jeweils auch die Signaturnummer leer. 
-- Daher sollte "signaturnummer" nicht als Filter bei der "Reparatur" verwendet werden.


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


-- Diese Views sollen zeigen, welche Namen in ap_pto.schriftinhalt eingesetzt werden,
-- wenn die nachfolgenden update-Befehle ausgeführt werden.

-- Dies dient während der Entwicklung zu manuellen Vorab-Kontrolle.
-- Wenn hier keine Zeilen ausgegeben werden, kann die Ausführung dieses Scriptes im Workflow ausgeschaltet werden.
-- Dann sind (Bundesland-spezifisch) die Namen bereits gefüllt und brauchen nicht 
-- auf diese Weise rekonstruiert werden.

-- An einem Referenzbestand (amtliche Karte?) kann/sollte kontrolliert werden, 
--  ob die richtigen Namen zugeordnet werden.


--DROP VIEW  pp_praes_strassen_name_update_vorschau;
CREATE OR REPLACE VIEW pp_praes_strassen_name_update_vorschau
AS
  SELECT f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler || '/' ||
         coalesce(cast(f.nenner as character varying), '') AS fskennz, -- Flurstückskennzeichen zur Eingabe in Navigation
         f.gml_id AS gml_fs,  -- ID des Flurstücks zum Nachsehen in der Auskunft (PHP/HTML)
      -- p.gml_id AS gml_pto,
         k.bezeichnung,                          -- der Name aus dem Katalog, der nach ap_pto kopiert wird
         st_asewkt(p.wkb_geometry) AS label_geom -- Lesbare Koordinaten: Wo liegt der Label?
  FROM   ax_lagebezeichnungkatalogeintrag  k     -- Katalog enthält den Straßennamen
    JOIN ax_lagebezeichnungohnehausnummer  l     -- Diese Eintrag ist dem Flurstück als Lage o. HsNr. zugeordnet
      ON ( k.land=l.land
     AND k.regierungsbezirk=l.regierungsbezirk 
     AND k.kreis=l.kreis
     AND k.gemeinde=l.gemeinde
     AND k.lage=l.lage )
    JOIN alkis_beziehungen b ON l.gml_id = b.beziehung_zu 
    JOIN ax_flurstueck     f ON f.gml_id = b.beziehung_von                -- Flurstück ..
    JOIN ap_pto            p ON ST_Within(p.wkb_geometry, f.wkb_geometry) -- in dessen Fläche die Label-Position liegt
   WHERE p."art" = 'Strasse'  -- Filter
     AND p.schriftinhalt      IS NULL       -- Text fehlt in ap_pto
     AND NOT (p.wkb_geometry  IS NULL)      -- hat aber eine Position in ap_pto
     AND b.beziehungsart = 'zeigtAuf'       -- Relation Flurstück - Lage o.HsNr
  -- AND k.bezeichnung = 'Unter der Treff'  -- kleiner Test in Mustermonzel Testdaten
   ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;

COMMENT ON VIEW pp_praes_strassen_name_update_vorschau 
  IS 'Präsentationsobjekt zu Straßen. Vorschau zum Update des Namens der in ap_pto.';


-- Werden hier zu einem PTO möglicherweise mal mehrere Werte geliefert?
-- In diesen Problem-Fällen liefert die Subquery im Update (ohne Limit 1) mehrere Zeilen für ein Feld.

--DROP VIEW pp_praes_strassen_name_mehrfach;
CREATE OR REPLACE VIEW pp_praes_strassen_name_mehrfach
AS
	SELECT p.gml_id, p.advstandardmodell,
	   st_asewkt(p.wkb_geometry) AS label_geom,  -- Wo liegt der Label?
       (SELECT f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler || '/' ||
        coalesce(cast(f.nenner as character varying), '') AS fskennz -- Flurstückskennzeichen zur Eingabe in Navigation
		FROM ax_flurstueck f
		WHERE ST_Within(p.wkb_geometry, f.wkb_geometry)
	   ) AS flurstueck
	FROM       ap_pto  p
	 WHERE     p.art = 'Strasse'  
	   AND     p.schriftinhalt IS NULL
	   AND NOT p.wkb_geometry  IS NULL
	   AND (SELECT count(k.bezeichnung) AS anzahl_label  -- die Subquery aus dem Update
		   FROM ax_lagebezeichnungkatalogeintrag  k
		   JOIN ax_lagebezeichnungohnehausnummer  l
				ON k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis
				   AND k.gemeinde=l.gemeinde AND k.lage=l.lage
		   JOIN alkis_beziehungen b ON l.gml_id = b.beziehung_zu
		   JOIN ax_flurstueck f ON f.gml_id = b.beziehung_von
		  WHERE b.beziehungsart = 'zeigtAuf'
			AND ST_Within(p.wkb_geometry, f.wkb_geometry)
		  ) > 1
	ORDER BY p.gml_id, p.advstandardmodell;

COMMENT ON VIEW pp_praes_strassen_name_mehrfach 
  IS 'Präsentationsobjekt zu Straßen. Zu einem PTO werden über das Flurstück mehrere Texte gefunden.';


-- Work-Arround, bis die eindeutige Zuordnung von "ap_pto" zu "lagebezeichnung*" geklärt ist.  

-- Wie "pp_praes_strassen_name_mehrfach" aber nur eine Liste der gml_id liefern um
-- diese beim Update (vorläufig) auszuschließen.

--DROP VIEW pp_praes_strassen_name_ausnahmen;
CREATE OR REPLACE VIEW pp_praes_strassen_name_ausnahmen
AS
	SELECT p.gml_id
	FROM   ap_pto  p
	 WHERE p.art = 'Strasse'  
	   AND p.schriftinhalt IS NULL
	   AND NOT p.wkb_geometry  IS NULL
	   AND (SELECT count(k.bezeichnung) AS anzahl_label  -- die Subquery aus dem Update
		   FROM ax_lagebezeichnungkatalogeintrag  k
		   JOIN ax_lagebezeichnungohnehausnummer  l
				ON k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis
				   AND k.gemeinde=l.gemeinde AND k.lage=l.lage
		   JOIN alkis_beziehungen b ON l.gml_id = b.beziehung_zu
		   JOIN ax_flurstueck f ON f.gml_id = b.beziehung_von
		  WHERE b.beziehungsart = 'zeigtAuf'
			AND ST_Within(p.wkb_geometry, f.wkb_geometry)
		  ) > 1;

COMMENT ON VIEW pp_praes_strassen_name_ausnahmen 
  IS 'Präsentationsobjekt zu Straßen. Zu einem PTO werden über das Flurstück mehrere Texte gefunden. Liefert Liste der gml_is, die beim Update ausgenommen werden müssen.';


--DROP VIEW pp_praes_strassen_klass_update_vorschau;
CREATE OR REPLACE VIEW pp_praes_strassen_klass_update_vorschau
AS
  SELECT p.gml_id, -- ID des Flurstücks zum Nachsehen in der Auskunft (PHP/HTML)
         f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler || '/' ||
         coalesce(cast(f.nenner as character varying), '') AS fskennz, -- Flurstückskennzeichen zur Eingabe in Navigation
         k.bezeichnung,                          -- der Name aus dem Katalog, der nach ap_pto kopiert wird
         st_asewkt(p.wkb_geometry) AS label_geom -- Lesbare Koordinaten: Wo liegt der Label?
  FROM   ax_lagebezeichnungkatalogeintrag  k     -- Katalog enthält den Straßennamen
    JOIN ax_lagebezeichnungohnehausnummer  l     -- Diese Eintrag ist dem Flurstück als Lage o. HsNr. zugeordnet
     ON (k.land=l.land
     AND k.regierungsbezirk=l.regierungsbezirk 
     AND k.kreis=l.kreis
     AND k.gemeinde=l.gemeinde
     AND k.lage=l.lage)
    JOIN alkis_beziehungen b ON l.gml_id = b.beziehung_zu 
    JOIN ax_flurstueck     f ON f.gml_id = b.beziehung_von                -- Flurstück ..
    JOIN ap_pto            p ON ST_Within(p.wkb_geometry, f.wkb_geometry) -- in dessen Fläche die Label-Position liegt
   WHERE p."art" = 'BezKlassifizierungStrasse'  -- Filter
     AND p.schriftinhalt      IS NULL    -- Text fehlt in ap_pto
     AND NOT (p.wkb_geometry  IS NULL)   -- hat aber eine Position in ap_pto
     AND b.beziehungsart = 'zeigtAuf'    -- Relation Flurstück - Lage o.HsNr
   ORDER BY f.flurnummer, f.zaehler, f.nenner;

COMMENT ON VIEW pp_praes_strassen_klass_update_vorschau 
  IS 'Präsentationsobjekt zu Straßen. Vorschau zum Update der Klassifikation der in ap_pto.';


-- ENDE --
