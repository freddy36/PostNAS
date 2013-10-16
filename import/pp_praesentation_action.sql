
-- ALKIS PostNAS 0.7

-- Post Processing (pp_) Teil 3: Präsentationsobjekte ergänzen / reparieren

-- Dies Script "pp_praesentation_action.sql" dient der Reparatur von fehlenden Präsentationsobjekten.
-- Voraussetzung ist, dass vorher das Script "pp_praesentation_sichten.sql" verarbeitet wurde.

-- Dies Script muss im Rahmen des Post-Processing nach jeder Konvertierung laufen.
-- Das Sichten-Sript muss nur beim Anlegen der Datenbank einmalig verarbeitet werden 

-- Stand 
--  2013-10-16  F.J. krz: Straßennamen fehlen in den Präsentationsobjekten, Tabelle "ap_pto"

-- ========================================
-- Straßen-Namen und Straßen-Klassifikation
-- ========================================

--
-- Weitere Kommantare und Erläuterungen siehe in "pp_praesentation_sichten.sql".
--

-- Reparatur Sonderfall
-- ====================

  -- Gibt es Fälle, wo der Label in einem benachbarten FS liegt?
  -- Hat er dann einen Zuordnungspfeil?
  -- Dann müssten diese Sonderfälle zuerst gefüllt werden.



-- Reparatur Normalfall
-- ====================

   -- Label   >liegt in>   Flurstück     >zeigtAuf>       Lage o.H.   -->   Katalog
   --        (Geometrisch)            (Alkis_Beziehung)             (JOIN)

-- N a m e n
UPDATE ap_pto  p          -- Präsentationsobjekte Punktförmig
   SET schriftinhalt =    -- Hier fehlt der Label
   -- Subquery "Gib mir den Straßennamen":
   -- Diese Subquery darf nur eine einzige Zeile liefern damit der Inhalt in eine Spalte passt.
    (SELECT k.bezeichnung                        -- Straßenname ...
       FROM ax_lagebezeichnungkatalogeintrag  k  --   .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer  l  -- wobei dieser Katalogeintrag
            ON     k.land=l.land
               AND k.regierungsbezirk=l.regierungsbezirk 
               AND k.kreis=l.kreis
               AND k.gemeinde=l.gemeinde
               AND k.lage=l.lage 
       JOIN alkis_beziehungen  b  ON l.gml_id = b.beziehung_zu  -- in Beziehung steht
       JOIN ax_flurstueck      f  ON f.gml_id = b.beziehung_von -- zu dem Flurstück
      WHERE b.beziehungsart = 'zeigtAuf'
        AND ST_Within(p.wkb_geometry, f.wkb_geometry) -- in dessen Fläche der Label liegt
    --LIMIT 1  -- siehe unten !
    )
 WHERE     p.art = 'Strasse'  -- Filter
   AND     p.schriftinhalt IS NULL
   AND NOT p.wkb_geometry  IS NULL
   -- Die ap_pto zunächst auslassen, zu dessen Flurstücken es mehrere Lagebezeichnungen gibt.
   AND p.gml_id NOT IN (SELECT * FROM pp_praes_strassen_name_ausnahmen); -- siehe unten !


-- "LIMIT 1" wozu?

-- Es wird möglicherweise mal mehr als 1 Wert je Subquery geliefert.
-- Dann ist dies SQL nicht ausführbar und bricht ab.

-- In den Testdaten "Mustermonzel" sind Name und Klassifikation nicht unterscheidbar weil
-- die Klassifikation nicht als art='BezKlassifizierungStrasse' sondern auch als art='strasse'
-- eingetragen ist. Dann werden 2 Zeilen geliefert, die Ausführung bricht ab.

-- In aktuellen Daten ist diese Ursache ausgeschaltet.
-- Es gibt trotzdem Sonderfälle, bei dem mehrere Werte geliefert werden.
-- Wenn das über die Verschneidung gefundene Flurstücke mehrer "Lagebezeichnung ohne Hausnummer" hat,
-- dann kann zur Zeit nicht jedes dieser Label der passenden Position aus ap_pto zugewiesen weden.
-- Die obige Lösung funktioniert nur bei 1:1-Konstallationen.

-- Welcher Label gehört dann zu welcher Position?
-- Es gibt keine Verbindung (alkis_beziehung) zwischen "ap_pto" und "lagebezeichnung*".

-- Die Lösung über "LIMIT 1" macht die Query ausführbar, führt aber dazu, dass nur einer der 
-- mehrfachen Label an allen Positionen angezeigt wird, was falsch ist.

-- Die alternative Lösung über 
--    "p.gml_id NOT IN (SELECT * FROM pp_praes_strassen_name_ausnahmen)"
-- lässt die Label dagegen zunächst leer.
-- Diese Fälle bleiben dann durch obigen Views weiterhin erkennbar. 


-- K l a s s i f i k a t i o n e n
-- (analog zu strassen)
UPDATE ap_pto  p          -- Präsentationsobjekte Punktförmig
   SET schriftinhalt =    -- Hier fehlt der Label
   -- Subquery "Gib mir die Straßen-Klassifikation":
   -- Diese Subquery darf nur eine einzige Zeile liefern damit der Inhalt in eine Spalte passt.
    (SELECT k.bezeichnung                        -- Straßenname ...
       FROM ax_lagebezeichnungkatalogeintrag  k  --   .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer  l  -- wobei dieser Katalogeintrag
            ON     k.land=l.land
               AND k.regierungsbezirk=l.regierungsbezirk 
               AND k.kreis=l.kreis
               AND k.gemeinde=l.gemeinde
               AND k.lage=l.lage 
       JOIN alkis_beziehungen  b  ON l.gml_id = b.beziehung_zu  -- in Beziehung steht
       JOIN ax_flurstueck      f  ON f.gml_id = b.beziehung_von -- zu dem Flurstück
      WHERE b.beziehungsart = 'zeigtAuf'
        AND ST_Within(p.wkb_geometry, f.wkb_geometry) -- in dessen Fläche der Label liegt
    -- LIMIT 1
    )
 WHERE     p.art = 'BezKlassifizierungStrasse' -- Filter
   AND     p.schriftinhalt IS NULL
   AND NOT p.wkb_geometry  IS NULL;

-- ENDE --
