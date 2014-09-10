
-- ALKIS PostNAS 0.8

-- Post Processing (pp_) Teil 3: Präsentationsobjekte ergänzen / reparieren

-- Dies Script "pp_praesentation_action.sql" dient der Reparatur von fehlenden Texten in Präsentationsobjekten.
-- Dies Script muss im Rahmen des Post-Processing nach jeder Konvertierung laufen.
-- Kommentare und Erläuterungen siehe in "pp_praesentation_sichten.sql".

-- Stand 
--  2013-10-16  F.J. krz: Straßennamen fehlen in den Präsentationsobjekten, Tabelle "ap_pto"
--  2013-10-17  F.J. krz: Relation "dientZurDarstellungVon" macht es einfacher

--  2013-10-24  F.J. krz: Diese Zwischenlösung  N I C H T   M E H R   V E R W E N D E N !
--                        Die neue Lösung lässt die Tabelle "ap_pto" unberührt und sammelt die Daten zur Präsentation
--                        der Straßennemen im der Tabelle "pp_strassenname".
--                        Die Lösung ist nun integriert in pp_definition.sql und pp_laden.sql 


-- ========================================
-- Straßen-Namen und Straßen-Klassifikation
-- ========================================

-- N a m e n

--	UPDATE ap_pto  p          -- Präsentationsobjekte Punktförmig
--	   SET schriftinhalt =    -- Hier fehlt der Label
--	   -- Subquery "Gib mir den Straßennamen":
--	   ( SELECT k.bezeichnung                       -- Straßenname ..
--		   FROM ax_lagebezeichnungkatalogeintrag k  --  .. aus Katalog
--		   JOIN ax_lagebezeichnungohnehausnummer l  -- verwendet als Lage o.H.
--			 ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk 
--				 AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
--		   JOIN alkis_beziehungen x ON l.gml_id = x.beziehung_zu  -- Relation zum Präsentationsobjekt
--		  WHERE p.gml_id = x.beziehung_von
--			AND x.beziehungsart = 'dientZurDarstellungVon'
--		  -- LIMIT 1 -- war in einem Fall notwendig, wo 2mal der gleiche Text zugeordnet war, Ursache?
--	   )
--	 WHERE     p.art = 'Strasse' -- Filter
--	   AND     p.schriftinhalt IS NULL
--	   AND NOT p.wkb_geometry  IS NULL;
--


-- K l a s s i f i k a t i o n e n   (analog zu Strassen)

--	UPDATE ap_pto  p          -- Präsentationsobjekte Punktförmig
--	   SET schriftinhalt =    -- Hier fehlt der Label
--	   ( SELECT k.bezeichnung                       -- Klassifikation "B nnn", "L nnn", "K nnn"
--		   FROM ax_lagebezeichnungkatalogeintrag k  -- .. aus Katalog
--		   JOIN ax_lagebezeichnungohnehausnummer l  -- verwendet als Lage o.H.
--			 ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk 
--				 AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
--		   JOIN alkis_beziehungen x ON l.gml_id = x.beziehung_zu  -- Relation zum Präsentationsobjekt
--		  WHERE p.gml_id = x.beziehung_von
--			AND x.beziehungsart = 'dientZurDarstellungVon'
--	   )
--	 WHERE     p.art = 'BezKlassifizierungStrasse' -- Filter
--	   AND     p.schriftinhalt IS NULL
--	   AND NOT p.wkb_geometry  IS NULL;
--

-- ENDE --
