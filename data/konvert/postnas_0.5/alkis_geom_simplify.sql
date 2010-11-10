
-- ----------------------------------------------------------------
-- Vereinfachung der Geometrie mit der PostGIS-Function ST_Simplify
-- ----------------------------------------------------------------

-- ALKIS / PostNAS 0.5

-- "Tuning" der Anwendung durch Reduktion der Datenmenge.
-- "Unnötige" Zwischenpunkte in der Geometrie werden entfernt.
-- Für die Kartendarstellung hat das keine Qualitätseinbußen, weil die Toleranzwerte 
-- weit unterhalb der Darstellungsgenauigkeit liegen.
-- Es kann aber Probleme geben bei Rechenoperationen mit den Flächen weil vorher "genau" übereinander
-- liegende Geometrien möglicherweise unterschiedlich reduziert werden.
-- Bei einem Objekt ist ein Zwischenpunkt vielleicht unnötig weil der Umring gerade weiter läuft.
-- Bei einem anderen Objekt zweigt der Umring aber ab, so das der Punkt nicht entfernt wird.
-- Dabei kann eine winzige Abweichung entstehen, die bei Verschneidungen zu etwas anderen Ergebnissen führt.
-- Die Abweichungen sind nur gering aber mathematisch gilt eben:  "0.0 <> 0.000001".
-- Dies ist bei der Gestaltung von Anwendungen zu berücksichtigen.


-- Stand

-- 2010-10-11 
--  erstmalige Anwendung, Toleranz 2 mm

-- 2010-10-11 
--  Reduzierung auf 1 mm. Es sollen nur Zwischenpunkte "in der Geraden" entfernt werden.
--  Der Toleranzwert soll nur die Rundungsungenauigkeiten enthalten.
--  Es kann Probleme geben bei Verschneidung von Flächen. Die PostGIS-Function "st_intersects"
--  liefert auch Flächen, die sich am Rand berühren.
--  Wenn wirklich nur überlappende Flächen gewünscht sind, dann müssen diese mit 
--     "st_area(st_intersection(a.geom,b.geom)) > 0" 
--  heraus gefiltert werden.
--  Nach Anwendung dieses Simplify-Scriptes ist aber 0 nicht mehr 0. Es muss statt dessen mit 
--  (etwas schwammigen) Grenzwerten gearbeitet werden.
--  Wenn z.B. die Ergebnis-Fläche sowieso auf eine Nachkommastelle gerundet wird, dann kann als Schwellwert 
--     "st_area(st_intersection(a.geom,b.geom)) > 0.05" 
--  verwendet werden. Es werden dann keine Flächen angezeigt, die gerundet als '0.0' angezeigt würden.
--  Im Zweifelsfall, z.B. wenn mit der Datenbank sehr viele Verschneidungen präzise berechnet werden solllen,
--  sollte dieses Script nicht verwendet werden.


-- 2010-11-10
--  neue Tabelle "nutzung"


-- Mengenanalyse siehe file "alkis_test_simplify.sql".


-- Daten im Geometriefeld optimieren:

UPDATE "ap_lpo"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_leitung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_transportanlage"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_besondereflurstuecksgrenze"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_wald"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_gehoelz"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_fliessgewaesser"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_stehendesgewaesser"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_wohnbauflaeche"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_sportfreizeitunderholungsflaeche"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_landwirtschaft"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_strassenverkehr"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_weg"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_flaechegemischternutzung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_industrieundgewerbeflaeche"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_flaechebesondererfunktionalerpraegung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_platz"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_halde"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bergbaubetrieb"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_tagebaugrubesteinbruch"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_friedhof"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_flugverkehr"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_schiffsverkehr"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bahnverkehr"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_hafenbecken"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_heide"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_moor"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_sumpf"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_unlandvegetationsloseflaeche"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_besonderegebaeudelinie"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_gebaeude"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bauteil"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bauwerkoderanlagefuersportfreizeitunderholung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bauwerkimgewaesserbereich"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_turm"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_vorratsbehaelterspeicherbauwerk"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_klassifizierungnachwasserrecht"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_naturumweltoderbodenschutzrecht"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bewertung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_klassifizierungnachstrassenrecht"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_schutzzone"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bodenschaetzung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_bauraumoderbodenordnungsrecht"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_denkmalschutzrecht"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);

UPDATE "ax_anderefestlegungnachwasserrecht"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);


-- Zusammen gefasste Nutzungarten
UPDATE "nutzung"
SET    wkb_geometry = st_simplify(wkb_geometry, 0.001);


-- Vaccum der Datenbank ist notwendig um die gewonnen Reduzierung endgueltig zu erschließen.


-- Fuer weitere Fortfuehrungen (NBA-Verfahren) einen Trigger einrichten?

-- Function zum Simplifizieren des Geometriefeldes:
--    CREATE OR REPLACE FUNCTION axsimlify()
--      RETURNS TRIGGER AS
--    $$
--    BEGIN
--      NEW.wkb_geometry := ST_Simplify(NEW.wkb_geometry, 0.001); -- Toleranz 1 Millimeter
--      RETURN NEW;
--    END;
--    $$
--    LANGUAGE 'plpgsql';


-- fuer alle Tabellen:

--    CREATE TRIGGER axsimplify
--      BEFORE INSERT ON ax_wohnbauflaeche
--      FOR EACH ROW EXECUTE PROCEDURE axsimlify();


-- weitere. Liste wie oben ....


-- END --