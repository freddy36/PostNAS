
-- ALKIS PostNAS 0.7

-- Post Processing (pp_) Teil 2: Laden der Tabellen

-- Stand 

--  2012-02-13 PostNAS 07, Umbenennung
--  2012-02-17 Optimierung
--  2012-04-17 Flurstuecksnummern auf Standardposition
--  2012-04-24 Generell Filter 'endet IS NULL' um historische Objekte auszublenden
--  2012-04-25 Abst�rze und Fehler (durch kaputte Geometrie?) beim Zusammenfassen der Fl�chen
--  2012-10-29 F.J. Redundanzen aus alkis_beziehungen beseitigen, die nach NAS replace auftreten
--  2013-02-06 A.E. Function-Name an PostGIS 2 angepasst: multi() -> st_multi(), simplify() -> st_simplify()
--  2013-02-21 F.J. doppelte Buchungen zum Flurst�ck aus alkis_beziehungen beseitigen, die nach NAS replace auftreten

-- ============================
-- Tabellen des Post-Processing
-- ============================

-- Einige Informationen liegen nach der NAS-Konvertierung in der Datenbank "verstreut" vor.
-- Die dynamische Aufbereitung �ber Views und Functions w�rde zu lange dauern und somit lange 
-- Antwortzeiten in WMS, WFS, Buchauskunft oder Navigation (Suche) verursachen.

-- Im Rahmen eines "Post-Processing" werden diese Daten nach jeder Konvertierung (NBA-Aktualisierung) 
-- einmal komplett aufbereitet. Die ben�tigten Informationen stehen somit den Anwendungen mundgerecht zur Verf�gung.

-- Die per PostProcessing gef�llten Tabellen bekommen den Profix "pp_". 

-- Die Ausf�hrung dieses Scriptes auf einer Datenbank f�r eine 80T-Einwohner-Stadt dauert ca.: 500 Sek. !

SET client_encoding = 'UTF-8';


-- ============================================================================
-- Redundanzen aus alkis_beziehungen beseitigen, die nach NAS replace auftreten
-- ============================================================================
-- Workaround: alle Redundazen nach einem Lauf entfernen.
-- Besser w�re: sofort im Trigger bei replace entfernen.
-- Siehe Schema in FUNCTION delete_feature_kill

DELETE 
  FROM alkis_beziehungen AS bezalt        -- Beziehung Alt
 WHERE EXISTS
       (SELECT ogc_fid
         FROM alkis_beziehungen AS bezneu -- Beziehung Neu
        WHERE bezalt.beziehung_von = bezneu.beziehung_von
          AND bezalt.beziehung_zu  = bezneu.beziehung_zu
          AND bezalt.beziehungsart = bezneu.beziehungsart
          AND bezalt.ogc_fid       < bezneu.ogc_fid
        );
-- Denkbar ist eine Variante f�r den Trigger, die zus�tzlich
-- auf eine bestimmte gml_id filtert.
-- Damit w�re die DB schon w�hrend der Konvertierung konsistenter.
-- Nachtrag 2013-02-20:
-- Diese provisorische L�sung korrigiert nur die F�lle, wo ein Replace eine redundante Beziehung
-- eintr�gt. Wenn ein Objekt und seine Beziehung gleichzeitig ge�ndert wird, wird der alte
-- Eintrag nicht gefunden und verbleibt in den Beziehungen.
-- Siehe z.B. in Datei "sichten.sql" die Abfrage "mehrfache_buchung_zu_fs" 


-- Mehrfache Buchungen zu einem Flurst�ck korrigieren.
-- Neu 2013-02-21
-- Dieser Fehler enststeht, wenn ein Replace zu "ax_flurstueck" gleichzeitig die
-- Beziehung 'istGebucht' zu "ax_buchungsStelle" �ndert.
-- Kann entfallen, sobald PostNAS bei Replace die "alkis_beziehungen" richtig fortf�hrt.

-- Version Marvin Brandt, Unna
--	DELETE
--	--  SELECT *
--	FROM alkis_beziehungen a1
--	WHERE a1.beziehung_von = ANY(SELECT gml_id FROM (
--				SELECT f.*,
--						(SELECT count(f2.gml_id) as anzahl
--						FROM ax_flurstueck f2
--						JOIN alkis_beziehungen a1 ON f2.gml_id = a1.beziehung_von AND a1.beziehungsart = 'istGebucht'
--						WHERE f2.gml_id = f.gml_id
--						) as anzahl
--					FROM ax_flurstueck f
--					) as sub
--				WHERE sub.anzahl > 1 )
--	AND a1.beziehungsart = 'istGebucht'
--	AND a1.ogc_fid = (SELECT min(sub.ogc_fid) as ogc_fid FROM (
--		SELECT a1.*,
--			(SELECT count(f2.gml_id) as anzahl
--				FROM ax_flurstueck f2
--				JOIN alkis_beziehungen a1 ON f2.gml_id = a1.beziehung_von AND a1.beziehungsart = 'istGebucht'
--				WHERE f2.gml_id = f.gml_id
--			) as anzahl
--		FROM ax_flurstueck f
--		JOIN alkis_beziehungen a1 
--		ON f.gml_id = a1.beziehung_von AND a1.beziehungsart = 'istGebucht'
--		) as sub
--	WHERE sub.beziehung_von = a1.beziehung_von);


-- Version Frank J�ger, Lemgo 
DELETE
-- SELECT *   -- TEST: erst mal schauen, was gel�scht w�rde, wenn ...
FROM alkis_beziehungen b
WHERE b.beziehungsart = 'istGebucht'
  -- Die erste subquery z�hlt die Buchungen zu einer (Flurst�cks-) gml_id.
  -- Es wird nur dort gel�scht, wo mehrerer Buchungen existieren.
  AND 1 < 
     ( SELECT count(f1.ogc_fid) AS anzfs
        FROM ax_flurstueck f1
        JOIN alkis_beziehungen z
          ON f1.gml_id = z.beziehung_von
       WHERE f1.gml_id = b.beziehung_von
         AND z.beziehungsart = 'istGebucht'
       GROUP BY f1.gml_id )
  -- Die zweite Subquery liefert die letzte (= aktuelle) Beziehung.
  -- Diese aktuelle Buchung wird vom L�schen ausgeschlossen.
  AND b.ogc_fid <
     ( SELECT max(a.ogc_fid) AS maxi
        FROM ax_flurstueck f2
        JOIN alkis_beziehungen a
          ON f2.gml_id = a.beziehung_von
       WHERE f2.gml_id = b.beziehung_von
         AND a.beziehungsart = 'istGebucht'
       GROUP BY a.beziehung_von )
-- bei Test mit SELECT darf man sortieren:
--  ORDER BY b.beziehung_von, b.ogc_fid
;



-- SELECT *
--  FROM alkis_beziehungen AS bezalt
--  WHERE EXISTS
--        (SELECT ogc_fid
--          FROM alkis_beziehungen AS bezneu
--         WHERE bezalt.beziehung_von = bezneu.beziehung_von
--           AND bezalt.beziehung_zu  = bezneu.beziehung_zu
--           AND bezalt.beziehungsart = bezneu.beziehungsart
--           AND bezalt.ogc_fid       < bezneu.ogc_fid
--         );

-- SELECT *
--  FROM alkis_beziehungen AS bezalt
--  WHERE EXISTS
--        (SELECT ogc_fid
--          FROM alkis_beziehungen AS bezneu
--         WHERE bezalt.beziehung_von = bezneu.beziehung_von
--           AND bezalt.beziehung_zu  = bezneu.beziehung_zu
--           AND bezalt.beziehungsart = bezneu.beziehungsart
--           AND bezalt.ogc_fid       < bezneu.ogc_fid
--         )
--      -- mit dem Zusatz nur die Faelle aus dem letzten Durchlauf,
--      -- die aktuell noch in der Delet-Tabelle stehen
--      AND EXISTS
--         (SELECT ogc_fid
--          FROM delete
--          WHERE bezalt.beziehung_von = substr(featureid, 1, 16)
--             OR bezalt.beziehung_zu  = substr(featureid, 1, 16)
--         );


-- =================================
-- Flurstuecksnummern-Label-Position
-- =================================

-- ersetzt den View "s_flurstueck_nr" f�r WMS-Layer "ag_t_flurstueck"

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
       AND f.endet IS NULL 
       AND p.endet IS NULL 
     --AND p."art" = 'ZAE_NEN'
   UNION 
    SELECT f.gml_id,
           f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum,
           ST_PointOnSurface(f.wkb_geometry) AS wkb_geometry  -- Flaechenmitte als Position des Textes
      FROM      ax_flurstueck     f 
      LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.gml_id
     WHERE v.beziehungsart is NULL
       AND f.endet IS NULL 
  ;
-- Ausf�hrung: mittlere Stadt: ca. 4 - 18 Sec.


-- ========================================================
-- Tabellen fuer die Zuordnung vom Gemarkungen zu Gemeinden
-- ========================================================

-- F�r die Regelung der Zugriffsberechtigung einer Gemeindeverwaltung auf die 
-- Flurst�cke in ihrem Gebiet braucht man die Information, in welcher Gemeinde eine Gemarkung liegt.
-- 'ax_gemeinde' und 'ax_gemarkung' haben aber im ALKIS keinerlei Beziehung zueinander - kaum zu glauben!
-- Nur �ber die Auswertung der Flurst�cke kann man die Zuordnung ermitteln.
-- Da nicht st�ndig mit 'SELECT DISTINCT' s�mtliche Flurst�cke durchsucht werden k�nnen, 
-- muss diese Information als (redundante) Tabelle nach dem Laden zwischengespeichert werden. 


-- G E M A R K U N G

DELETE FROM pp_gemarkung;

-- Vorkommende Paarungen Gemarkung <-> Gemeinde in ax_Flurstueck
INSERT INTO pp_gemarkung
  (               land, regierungsbezirk, kreis, gemeinde, gemarkung       )
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  WHERE           endet IS NULL
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer 
;

-- Namen der Gemarkung dazu als Optimierung bei der Auskunft 
UPDATE pp_gemarkung a
   SET gemarkungsname =
   ( SELECT b.bezeichnung 
     FROM    ax_gemarkung b
     WHERE a.land=b.land 
       AND a.gemarkung=b.gemarkungsnummer
       AND b.endet IS NULL
   );


-- G E M E I N D E

DELETE FROM pp_gemeinde;

-- Vorkommende Gemeinden aus den gemarkungen
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
       AND b.endet IS NULL
   );


-- ==============================================================================
-- Geometrien der Flurst�cke schrittweise zu groesseren Einheiten zusammen fassen
-- ==============================================================================

-- Dies macht nur Sinn, wenn der Inhalt der Datenbank einen ganzen Katasterbezirk enth�lt.
-- Wenn ein Gebiet durch geometrische Filter im NBA ausgegeben wurde, dann gibt es Randstreifen, 
-- die zu Pseudo-Fluren zusammen gefasst werden. Fachlich falsch!

-- Ausf�hrungszeit: 1 mittlere Stadt mit ca. 14.000 Flurst�cken > 100 Sek

-- ToDo:
--   Nur "gepr�fte Flurst�cke" verwenden?  Filter?

--   070: TopologyException: found non-noded intersection between   ...


DELETE FROM pp_flur;

INSERT INTO pp_flur (land, regierungsbezirk, kreis, gemarkung, flurnummer, anz_fs, the_geom )
   SELECT  f.land, f.regierungsbezirk, f.kreis, f.gemarkungsnummer as gemarkung, f.flurnummer, 
           count(gml_id) as anz_fs,
           st_multi(st_union(st_buffer(f.wkb_geometry,0.05))) AS the_geom -- 5 cm Zugabe um Zwischenr�ume zu vermeiden
     FROM  ax_flurstueck f
     WHERE f.endet IS NULL
  GROUP BY f.land, f.regierungsbezirk, f.kreis, f.gemarkungsnummer, f.flurnummer;

-- Geometrie vereinfachen, auf 1 Meter gl�tten
UPDATE pp_flur SET simple_geom = st_simplify(the_geom, 1.0);


-- Fluren zu Gemarkungen zusammen fassen
-- -------------------------------------

-- FEHLER: 290 Absturz PG! Bei Verwendung der ungebufferten pr�zisen Geometrie.  
-- bufferOriginalPrecision failed (TopologyException: unable to assign hole to a shell), trying with reduced precision
-- UPDATE: ../../source/headers/geos/noding/SegmentString.h:175: void geos::noding::SegmentString::testInvariant() const: Zusicherung �pts->size() > 1� nicht erf�llt.


-- Fl�chen vereinigen (aus der bereits vereinfachten Geometrie)
UPDATE pp_gemarkung a
  SET the_geom = 
   ( SELECT st_multi(st_union(st_buffer(b.simple_geom,0.1))) AS the_geom -- noch mal 10 cm Zugabe
     FROM    pp_flur b
     WHERE a.land      = b.land 
       AND a.gemarkung = b.gemarkung
   );

-- Fluren zaehlen
UPDATE pp_gemarkung a
  SET anz_flur = 
   ( SELECT count(flurnummer) AS anz_flur 
     FROM    pp_flur b
     WHERE a.land      = b.land 
       AND a.gemarkung = b.gemarkung
   ); -- Gemarkungsnummer ist je BundesLand eindeutig

-- Geometrie vereinfachen (Wirkung siehe pp_gemarkung_analyse)
UPDATE pp_gemarkung SET simple_geom = st_simplify(the_geom, 8.0);


-- Gemarkungen zu Gemeinden zusammen fassen
-- ----------------------------------------

-- Fl�chen vereinigen (aus der bereits vereinfachten Geometrie)
UPDATE pp_gemeinde a
  SET the_geom = 
   ( SELECT st_multi(st_union(st_buffer(b.simple_geom,0.1))) AS the_geom -- noch mal Zugabe 10 cm
     FROM    pp_gemarkung b
     WHERE a.land     = b.land 
       AND a.gemeinde = b.gemeinde
   );

-- Gemarkungen z�hlen
UPDATE pp_gemeinde a
  SET anz_gemarkg = 
   ( SELECT count(gemarkung) AS anz_gemarkg 
     FROM    pp_gemarkung b
     WHERE a.land     = b.land 
       AND a.gemeinde = b.gemeinde
   );

-- Geometrie vereinfachen (Wirkung siehe pp_gemeinde_analyse)
UPDATE pp_gemeinde SET simple_geom = st_simplify(the_geom, 20.0);


-- =======================================================
-- Tabelle fuer die Zuordnung vom Eigent�mern zu Gemeinden
-- =======================================================


-- erst mal sauber machen
DELETE FROM gemeinde_person;

-- alle direkten Buchungen mit View ermitteln und in Tabelle speichern
-- F�r eine Stadt: ca. 20 Sekunden
INSERT INTO  gemeinde_person 
       (land, regierungsbezirk, kreis, gemeinde, person, buchtyp)
 SELECT land, regierungsbezirk, kreis, gemeinde, person, 1
   FROM gemeinde_person_typ1;


-- noch die komplexeren Buchungen erg�nzen (Recht an ..)
-- Mit View ermitteln und in Tabelle speichern
-- F�r eine Stadt: ca. 10 Sekunden
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
