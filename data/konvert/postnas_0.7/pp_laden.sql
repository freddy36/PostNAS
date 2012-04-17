
-- ALKIS PostNAS 0.7

-- Post Processing (pp_) Teil 2: Laden der Tabellen

-- Stand 

--  2012-02-13 PostNAS 07, Umbenennung
--  2012-02-17 Optimierung
--  2012-04-17 Flurstuecksnummern auf Standardposition


-- ============================
-- Tabellen des Post-Processing
-- ============================

-- Einige Informationen liegen nach der NAS-Konvertierung in der Datenbank "verstreut" vor.
-- Die dynamische Aufbereitung über Views und Functions würde zu lange dauern und somit lange 
-- Antwortzeiten in WMS, WFS, Buchauskunft oder Navigation (Suche) verursachen.

-- Im Rahmen eines "Post-Processing" werden diese Daten nach jeder Konvertierung (NBA-Aktialisierung) 
-- einmal komplett aufbereitet. Die benötigten Informationen stehen somit den Anwendungen mundgerecht zur Verfügung.

-- Die per PostProcessing gefüllten Tabellen bekommen den Profix "pp_". 

-- Die Ausführung dieses Scriptes auf einer Datenbank für eine 80T-Einwohner-Stadt dauert ca.: 500 Sek. !



-- ===========================
-- Flurstuecksnummern-Position
-- ===========================

-- ersetzt den View "s_flurstueck_nr" für WMS-Layer "ag_t_flurstueck"

  DELETE FROM pp_flurstueck_nr;

  INSERT INTO pp_flurstueck_nr
          ( fsgml, fsnum, the_geom )
    SELECT f.gml_id,
           f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum,
           p.wkb_geometry  -- manuelle Position des Textes
      FROM ap_pto             p
      JOIN alkis_beziehungen  v  ON p.gml_id       = v.beziehung_von
      JOIN ax_flurstueck      f  ON v.beziehung_zu = f.gml_id
     WHERE v.beziehungsart = 'dientZurDarstellungVon' 
     --AND p."art" = 'ZAE_NEN'
   UNION 
    SELECT f.gml_id,
           f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum,
           ST_PointOnSurface(f.wkb_geometry) AS wkb_geometry  -- Flaechenmitte als Position des Textes
      FROM      ax_flurstueck     f 
      LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.gml_id
     WHERE v.beziehungsart is NULL
  ;
-- Ausführung: mittlere Stadt: ca. 4 - 18 Sec.


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


-- ==============================================================================
-- Geometrien der Flurstücke schrittweise zu groesseren Einheiten zusammen fassen
-- ==============================================================================

-- Dies macht nur Sinn, wenn der Inhalt der Datenbenk einen ganzen Katasterbezirk enthält.
-- Wenn ein Gebiet durch geometrische Filter im NBA ausgegeben wurde, dann gibt es Randstreifen, 
-- die zu Pseudo-Fluren zusammen gefasst werden. Fachlich falsch!

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

-- Fluren zaehlen
UPDATE pp_gemarkung a
  SET anz_flur = 
   ( SELECT count(flurnummer) AS anz_flur 
     FROM    pp_flur b
     WHERE a.land=b.land AND a.gemarkung=b.gemarkung
   ); -- Gemarkungsnummer ist je BundesLand eindeutig

-- Geometrie vereinfachen (Wirkung siehe pp_gemarkung_analyse)
UPDATE pp_gemarkung SET simple_geom = simplify(the_geom, 8.0);


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

-- Geometrie vereinfachen (Wirkung siehe pp_gemeinde_analyse)
UPDATE pp_gemeinde SET simple_geom = simplify(the_geom, 20.0);


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