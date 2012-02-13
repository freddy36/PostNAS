
-- ALKIS PostNAS 0.7

-- Post Processing Teil 2: Laden der Tabellen

-- Stand 

--  2012-02-13 PostNAS 07, Umbenennung


-- ============================
-- Tabellen des Post-Processing
-- ============================

-- Einige Informationen liegen nach der NAS-Konvertierung in der Datenbank "verstreut" vor.
-- Die dynamische Aufbereitung über Views und Functions würde zu lange dauern und somit lange 
-- Antwortzeiten in WMS, WFS, Buchauskunft oder Navigation (Suche) verursachen.

-- Im Rahmen eines "Post-Processing" werden diese Daten nach jeder Konvertierung (NBA-Aktialisierung) 
-- einmal komplett aufbereitet. Die benötigten Informationen stehen somit den Anwendungen mundgerecht zur Verfügung.

-- Die per PostProcessing gefüllten Tabellen bekommen den Profix "pp_". 


-- ========================================================
-- Tabellen fuer die Zuordnung vom Gemarkungen zu Gemeinden
-- ========================================================

-- Für die Regelung der Zugriffsberechtigung einer Gemeindeverwaltung auf die 
-- Flurstücke in ihrem Gebiet braucht man die Information, in welcher Gemeinde eine Gemarkung liegt.
-- 'ax_gemeinde' und 'ax_gemarkung' haben aber im ALKIS keinerlei Beziehung zueinander - kaum zu glauben!
-- Nur über die Auswertung der Flurstücke kann man die Zuordnung ermitteln.
-- Da nicht ständig mit 'SELECT DISTINCT' sämtliche Flurstücke durchsucht werden können, 
-- muss diese Information als (redundante) Tabelle nach dem Laden zwischengespeichert werden. 


SET client_encoding = 'UTF-8';


-- Alles auf Anfang!
  DELETE FROM pp_gemeinde;
  DELETE FROM pp_gemarkung;
  DELETE FROM pp_flur;


-- Vorkommende Paarungen Gemarkung <-> Gemeinde in ax_Flurstueck
INSERT INTO pp_gemarkung
  (               land, regierungsbezirk, kreis, gemeinde, gemarkung       )
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer 
;

-- daraus: Vorkommende Gemeinden
INSERT INTO pp_gemeinde
  (               land, regierungsbezirk, kreis, gemeinde)
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde
  FROM            pp_gemarkung
  ORDER BY        land, regierungsbezirk, kreis, gemeinde 
;

-- Namen der Gemeinde dazu als Optimierung bei der Auskunft 
UPDATE pp_gemeinde a
   SET gemeindename =
   ( SELECT b.bezeichnung 
     FROM    ax_gemeinde b
     WHERE a.land=b.land 
       AND a.regierungsbezirk=b.regierungsbezirk 
       AND a.kreis=b.kreis
       AND a.gemeinde=b.gemeinde
   );

-- Namen der Gemarkung dazu als Optimierung bei der Auskunft 
UPDATE pp_gemarkung a
   SET gemarkungsname =
   ( SELECT b.bezeichnung 
     FROM    ax_gemarkung b
     WHERE a.land=b.land 
       AND a.gemarkung=b.gemarkungsnummer
   );


-- ===============================================================
-- Geometrien der Flurstücke zu größeren Einheiten zusammen fassen
-- ===============================================================

INSERT INTO pp_flur (land, regierungsbezirk, kreis, gemarkung, flurnummer, anz_fs, the_geom )
   SELECT  f.land, f.regierungsbezirk, f.kreis, f.gemarkungsnummer as gemarkung, f.flurnummer, 
           count(gml_id) as anz_fs,
           multi(st_union(st_buffer(f.wkb_geometry,0))) AS the_geom 
     FROM  ax_flurstueck f
  GROUP BY f.land, f.regierungsbezirk, f.kreis, f.gemarkungsnummer, f.flurnummer;


-- Fluren zu Gemarkungen zusammen fassen
-- -------------------------------------

-- Flächen vereinigen
UPDATE pp_gemarkung a
  SET the_geom = 
   ( SELECT multi(st_union(st_buffer(b.the_geom,0))) AS the_geom 
     FROM    pp_flur b
     WHERE a.land=b.land AND a.gemarkung=b.gemarkung
   );

-- Fluren zählen
UPDATE pp_gemarkung a
  SET anz_flur = 
   ( SELECT count(flurnummer) AS anz_flur 
     FROM    pp_flur b
     WHERE a.land=b.land AND a.gemarkung=b.gemarkung
   ); -- Gemarkungsnummer ist je BundesLand eindeutig

-- Geometrie vereinfachen
UPDATE pp_gemarkung SET simple_geom = simplify(the_geom, 4.0);

COMMENT ON COLUMN pp_gemarkung.simple_geom     IS 'Vereinfachte Geometrie mit 4 Meter-Genauigkeit. Für Anzeige von Übersichten in kleinen Maßstäben.';


-- Gemarkungen zu Gemeinden zusammen fassen
-- ----------------------------------------

-- Flächen vereinigen
UPDATE pp_gemeinde a
  SET the_geom = 
   ( SELECT multi(st_union(st_buffer(b.the_geom,0))) AS the_geom 
     FROM    pp_gemarkung b
     WHERE a.land=b.land AND a.gemeinde=b.gemeinde
   );

-- Gemarkungen zählen
UPDATE pp_gemeinde a
  SET anz_gemarkg = 
   ( SELECT count(gemarkung) AS anz_gemarkg 
     FROM    pp_gemarkung b
     WHERE a.land=b.land AND a.gemeinde=b.gemeinde
   );

-- Geometrie vereinfachen

UPDATE pp_gemeinde SET simple_geom = simplify(the_geom, 10.0);

COMMENT ON COLUMN pp_gemeinde.simple_geom     IS 'Vereinfachte Geometrie mit 10 Meter-Genauigkeit. Für Anzeige von Übersichten in kleinen Maßstäben.';



-- =======================================================
-- Tabelle fuer die Zuordnung vom Eigentümern zu Gemeinden
-- =======================================================


-- erst mal sauber machen
DELETE FROM gemeinde_person;

-- alle direkten Buchungen mit View ermitteln und in Tabelle speichern
-- Für eine Stadt: ca. 20 Sekunden
INSERT INTO  gemeinde_person 
       (land, regierungsbezirk, kreis, gemeinde, person, buchtyp)
 SELECT land, regierungsbezirk, kreis, gemeinde, person, 1
   FROM gemeinde_person_typ1;


-- noch die komplexeren Buchungen ergänzen (Recht an ..)
-- Mit View ermitteln und in Tabelle speichern
-- Für eine Stadt: ca. 10 Sekunden
INSERT INTO  gemeinde_person 
       (  land,   regierungsbezirk,   kreis,   gemeinde,   person,  buchtyp)
 SELECT q.land, q.regierungsbezirk, q.kreis, q.gemeinde, q.person,  2
   FROM gemeinde_person_typ2 q   -- Quelle
   LEFT JOIN gemeinde_person z   -- Ziel
     ON q.person   = z.person    -- Aber nur, wenn dieser Fall im Ziel
    AND q.land     = z.land 
    AND q.regierungsbezirk = z.regierungsbezirk 
    AND q.kreis    = z.kreis 
    AND q.gemeinde = z.gemeinde
  WHERE z.gemeinde is Null;      -- ..  noch nicht vorhanden ist


-- ENDE --