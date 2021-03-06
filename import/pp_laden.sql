
-- ALKIS PostNAS 0.8

-- Post Processing (pp_) Teil 2: Laden der Tabellen

-- Stand 

--  2012-02-13 PostNAS 07, Umbenennung
--  2012-02-17 Optimierung
--  2012-04-17 Flurstuecksnummern auf Standardposition
--  2012-04-24 Generell Filter 'endet IS NULL' um historische Objekte auszublenden
--  2012-04-25 Abstürze und Fehler (durch kaputte Geometrie?) beim Zusammenfassen der Flächen
--  2012-10-29 F.J. Redundanzen aus alkis_beziehungen beseitigen, die nach NAS replace auftreten
--  2013-02-06 A.E. Function-Name an PostGIS 2 angepasst: multi() -> st_multi(), simplify() -> st_simplify()
--  2013-02-21 F.J. doppelte Buchungen zum Flurstück aus alkis_beziehungen beseitigen, die nach NAS replace auftreten
--  2013-07-10 F.J. Bereinigen der alkis_beziehungen auskommentiert, wird jetzt im Trigger gelöst.
--  2012-10-24 Neue Tabelle für die Präsentation von Straßennamen und -Klassifikationen
--  2014-02-05 Bereits auskommentierte Aktionen gelöscht für die Beseitigung von Rdundanzen aus fehlerhaften Triggern
--  2014-02-12 Zusammen fassen Flur->Gemarkung->Gemeinde nicht aus simple_geom weil dadurch Löscher entstehen können.
--  2014-09-08 PostNAS 0.8, Umbenennung. Ohne Tabelle "alkis_beziehungen".
--             Beseitigung eines Fehlers beim Laden der Straßennamen-Label.
--             Dabei Trennung in pp_strassenname_p und -_l (Punkt- und Liniengeometrie).
--  2014-09-19 Substring auf gml_id, Korrektur "endet IS NULL"
--  2014-09-30 Rückbau substring(gml_id)
--  2014-12-17 Neue Spalte "gemeinde" in Tabelle "pp_flur", dient der Filterung im WMS-Layer "Gebiete"
--  2015-01-08 Mehrfach-Versuche der Geometrie-Zusammenfassung mit wachsender Puffergröße.


-- ============================
-- Tabellen des Post-Processing
-- ============================

-- Einige Informationen liegen nach der NAS-Konvertierung in der Datenbank "verstreut" vor.
-- Die dynamische Aufbereitung über Views und Functions würde zu lange dauern und somit lange 
-- Antwortzeiten in WMS, WFS, Buchauskunft oder Navigation (Suche) verursachen.

-- Geometrie glätten und vereinfachen für Flur, Gemarkung und Gemeinde:
-- Die "simplen" Geometrien sollen nur für die Darstellung einer Übersicht verwendet werden.
-- Ablage der simplen Geometrie in einem alternativen Geometriefeld im gleichen Datensatz.

-- Im Rahmen eines "Post-Processing" werden diese Daten nach jeder Konvertierung (NBA-Aktualisierung) 
-- einmal komplett aufbereitet. Die benötigten Informationen stehen somit den Anwendungen mundgerecht zur Verfügung.

-- Die per PostProcessing gefüllten Tabellen bekommen den Profix "pp_". 

-- Die Ausführung dieses Scriptes auf einer Datenbank für eine 80T-Einwohner-Stadt dauert ca.: 500 Sek. !

SET client_encoding = 'UTF-8';


-- Flurstuecksnummern-Label-Position
-- =================================

TRUNCATE pp_flurstueck_nr;  -- effektiver als DELETE

/* 
-- Alte Version über "alkis_beziehungen"
-- Ausführung: mittlere Stadt: ca. 4 - 18 Sec.

-- 1:1 umgestellt (UNION) unter Verwendeung der neuen Relationenspalten

INSERT INTO pp_flurstueck_nr
          ( fsgml, fsnum, the_geom )
    SELECT f.gml_id,
           f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum,
           p.wkb_geometry  -- manuelle Position des Textes
      FROM ax_flurstueck  f 
      JOIN ap_pto         p
        ON f.gml_id = ANY(p.dientzurdarstellungvon)
     WHERE f.endet IS NULL AND p.endet IS NULL -- AND p."art" = 'ZAE_NEN'
   UNION 
    SELECT f.gml_id,
           f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum,
           ST_PointOnSurface(f.wkb_geometry) AS wkb_geometry  -- Flaechenmitte als Position des Textes
      FROM ax_flurstueck  f 
      LEFT JOIN ap_pto    p
        ON f.gml_id = ANY(p.dientzurdarstellungvon)  -- kein Präsentationsobjekt vorhanden
     WHERE p.gml_id is NULL AND f.endet IS NULL ;
*/

-- Ersatz: Füllen in 3 Schritten

-- 1. zu allen Flurstücken zunächst nur die Nummer, aber noch keine Geometrie
INSERT INTO pp_flurstueck_nr
          ( fsgml, fsnum )
    SELECT f.gml_id, f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS fsnum
      FROM ax_flurstueck f 
     WHERE f.endet IS NULL;

-- 2. Geometrie aus Präsentationsobjekt (manuelle Position), wenn vorhanden. Aus Subquery.
UPDATE pp_flurstueck_nr n
  SET the_geom = (
      SELECT p.wkb_geometry 
        FROM ap_pto p
       WHERE n.fsgml=ANY(p.dientzurdarstellungvon) 
         AND p.endet IS NULL
       LIMIT 1 -- wegen vereinzelt FEHLER: als Ausdruck verwendete Unteranfrage ergab mehr als eine Zeile
    );
-- Dies läuft sehr lange. Optimierbar?


-- 3. Geometrie auf Flächenmitte (Standard), wenn jetzt noch leer
UPDATE pp_flurstueck_nr n
  SET the_geom = (
      SELECT ST_PointOnSurface(f.wkb_geometry) AS wkb_geometry 
       FROM ax_flurstueck  f 
       WHERE f.gml_id = n.fsgml 
         AND f.endet IS NULL
      )
   WHERE n.the_geom IS NULL; --- nur die Fehlenden, nichts überschreiben


-- Straßen - N a m e n  und  - K l a s s i f i k a t i o n
-- Tabellen für die Präsentation von Straßen-Namen und -Klassifikationen
-- Daten aus dem View "ap_pto_stra" werden im PostProcessing gespeichert in der Tabelle "pp_strassenname".
-- Der View übernimmt die Auswahl des passenden "advstandardmodell" und rechnet den Winkel passend um.
-- In der Tabelle werden dann die leer gebliebenen Label aus dem Katalog noch ergänzt. 

-- Tabelle aus View befüllen
-- 2014-08-22 
--  Variante "_p" = Punktgeometrie, Spalte gml_id ergänzt.
--  Es werden nun auch Sätze mit leerem "schriftinhalt" angelegt. Das wird dann nachträglich gefüllt.

-- Alles auf Anfang
TRUNCATE pp_strassenname_p;

-- Zunächst die Sonderschreibweisen (Abkürzungen) und die Standardschreibweisen, 
-- die von der Migration redundant abgelegt wurden.
INSERT INTO pp_strassenname_p (gml_id, schriftinhalt, hor, ver, art, winkel, the_geom)
       SELECT gml_id, schriftinhalt, hor, ver, art, winkel, wkb_geometry
       FROM ap_pto_stra; -- Der View sucht das passende advstandardmodell

-- Schriftinhalt ergänzen
-- Das sind die Standardschreibweisen aus dem Katalog, die nicht mehr redundant in ap_pto sind.
UPDATE pp_strassenname_p  p
   SET schriftinhalt =     -- Hier ist der Label noch leer
   -- Subquery "Gib mir den Straßennamen":
   ( SELECT k.bezeichnung                         -- Straßenname ..
       FROM ax_lagebezeichnungkatalogeintrag k    --  .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer l    -- verwendet als Lage o.H.
         ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
      WHERE p.gml_id = l.gml_id                   -- die gml_id wurde aus View importiert
    )
 WHERE     p.schriftinhalt IS NULL
   AND NOT p.the_geom      IS NULL;

-- Die immer noch leeren Texte sind nun sinnlos.
-- Die finden sich ggf. in der Variante "_l" mit Liniengeometrie.
DELETE FROM pp_strassenname_p WHERE schriftinhalt IS NULL;

-- Nun das Gleiche noch einmal für Linien-Geometrie

-- Auf Anfang
TRUNCATE pp_strassenname_l;

-- Zunächst die Sonderschreibweisen (Abkürzungen) und die Standardschreibweisen, 
-- die von der Migration redundant abgelegt wurden.
INSERT INTO pp_strassenname_l (gml_id, schriftinhalt, hor, ver, art, the_geom)
       SELECT gml_id, schriftinhalt, hor, ver, art, wkb_geometry
       FROM ap_lto_stra; -- Der View sucht das passende advstandardmodell

-- Schriftinhalt ergänzen (korrigiert 2014-08-25)
-- Das sind die Standardschreibweisen aus dem Katalog, die nicht mehr redundant in ap_pto sind.
-- Der Satz mit der passenen gml_id (Lage o.H.) ist aus dem View bereits importiert.
-- Jetzt noch den dazu passenen Schriftinhalt aus dem Katalog holen.
UPDATE pp_strassenname_l  p
   SET schriftinhalt =     -- Hier ist der Label noch leer
   -- Subquery "Gib mir den Straßennamen":
   ( SELECT k.bezeichnung                         -- Straßenname ..
       FROM ax_lagebezeichnungkatalogeintrag k    --  .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer l    -- verwendet als Lage o.H.
         ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
      WHERE p.gml_id = l.gml_id                   -- die gml_id wurde aus View importiert
    )
 WHERE     p.schriftinhalt IS NULL
   AND NOT p.the_geom      IS NULL;

-- Die immer noch leeren Texte sind sinnlos.
DELETE FROM pp_strassenname_l WHERE schriftinhalt IS NULL;


-- Tabellen fuer die Zuordnung vom Gemarkungen zu Gemeinden
-- ========================================================

-- Für die Regelung der Zugriffsberechtigung einer Gemeindeverwaltung auf die 
-- Flurstücke in ihrem Gebiet braucht man die Information, in welcher Gemeinde eine Gemarkung liegt.
-- 'ax_gemeinde' und 'ax_gemarkung' haben aber im ALKIS keinerlei Beziehung zueinander - kaum zu glauben!
-- Nur über die Auswertung der Flurstücke kann man die Zuordnung ermitteln.
-- Da nicht ständig mit 'SELECT DISTINCT' sämtliche Flurstücke durchsucht werden können, 
-- muss diese Information als (redundante) Tabelle nach dem Laden zwischengespeichert werden. 


-- G E M A R K U N G

TRUNCATE pp_gemarkung;
-- Vorkommende Paarungen Gemarkung <-> Gemeinde in ax_Flurstueck
INSERT INTO pp_gemarkung
  (               land, regierungsbezirk, kreis, gemeinde, gemarkung       )
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  WHERE           endet IS NULL
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer ;

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

TRUNCATE pp_gemeinde;
-- Vorkommende Gemeinden aus den Gemarkungen
INSERT INTO pp_gemeinde
  (               land, regierungsbezirk, kreis, gemeinde)
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde
  FROM            pp_gemarkung
  ORDER BY        land, regierungsbezirk, kreis, gemeinde;

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


-- Geometrien der Flurstücke schrittweise zu groesseren Einheiten zusammen fassen
-- ==============================================================================
-- http://postgis.net/docs/manual-1.5/ST_Union.html (Aggregate version)
-- http://postgis.net/docs/manual-1.5/ST_Collect.html

-- Wenn ein Gebiet durch geometrische Filter im NBA-Verfahren ausgegeben wurde, dann gibt es 
-- Randstreifen, die zu Pseudo-Fluren zusammen gefasst werden. 
-- Diese werden für den WMS durch einen View ausgefiltert, der nur eine Gemeinde darstellt.

-- Ausführungszeit: 1 mittlere Stadt mit ca. 14.000 Flurstücken > 100 Sek

TRUNCATE pp_flur;

INSERT INTO pp_flur (land, regierungsbezirk, kreis, gemeinde, gemarkung, flurnummer, anz_fs, the_geom )
   SELECT  f.land, f.regierungsbezirk, f.kreis, f.gemeinde, f.gemarkungsnummer as gemarkung, f.flurnummer, 
           count(gml_id) as anz_fs,
           ST_Multi(st_union(st_buffer(f.wkb_geometry,0.06))) AS the_geom -- Zugabe um Zwischenräume zu vermeiden
     FROM  ax_flurstueck f
     WHERE f.endet IS NULL AND NOT f.wkb_geometry IS NULL
  GROUP BY f.land, f.regierungsbezirk, f.kreis, f.gemeinde, f.gemarkungsnummer, f.flurnummer;

-- Vereinfachte Geometrie der Flur für die Darstelung im WMS in einem kleinen Maßstab
UPDATE pp_flur      SET simple_geom = st_simplify(the_geom, 0.5);


-- Fluren zu Gemarkungen zusammen fassen
-- -------------------------------------

-- Flächen vereinigen
UPDATE pp_gemarkung a
  SET the_geom = 
   ( SELECT ST_Multi(ST_Union(ST_Buffer(b.the_geom,0.15))) AS the_geom -- Puffer/Zugabe um Löcher zu vermeiden
       FROM pp_flur b
      WHERE a.land      = b.land 
        AND a.gemarkung = b.gemarkung
   );
-- Hierbei können Exceptions auftreten wobei das Geometriefeld einzelner Gemarkungen leer bleibt.
-- Die Ursache ist unklar.
--  TopologyException: found non-noded intersection between LINESTRING

-- Praktische Lösung:
-- Bei den Gemarkungen, die nichts abbekommen haben, mit schrittweise groesserem Buffer noch mal versuchen.
UPDATE pp_gemarkung a
  SET the_geom = 
   ( SELECT ST_Multi(ST_Union(ST_Buffer(b.the_geom,0.20))) AS the_geom -- Puffer vergroessert
       FROM pp_flur b
      WHERE a.land      = b.land 
        AND a.gemarkung = b.gemarkung
   ) WHERE the_geom IS NULL;

UPDATE pp_gemarkung a
  SET the_geom = 
   ( SELECT ST_Multi(ST_Union(ST_Buffer(b.the_geom,0.30))) AS the_geom -- Puffer vergroessert
       FROM pp_flur b
      WHERE a.land      = b.land 
        AND a.gemarkung = b.gemarkung
   ) WHERE the_geom IS NULL;

/* Guggst du (auf leeren Geometry-Typ achten:

   SELECT gemarkungsname, geometrytype(the_geom) AS typ, 
     st_isvalid(the_geom) AS vali, st_asewkt(the_geom) AS ewkt
   FROM pp_gemarkung;

*/

-- Die Fluren in der Gemarkung zaehlen
UPDATE pp_gemarkung a
  SET anz_flur = 
   ( SELECT count(flurnummer) AS anz_flur 
     FROM    pp_flur b
     WHERE a.land      = b.land 
       AND a.gemarkung = b.gemarkung
   ); -- Gemarkungsnummer ist je BundesLand eindeutig


-- Vereinfachte Geometrie der Gemarkung für die Darstellung im WMS in einem kleinen Maßstab
-- Gemarkung (Wirkung siehe pp_gemarkung_analyse)
UPDATE pp_gemarkung SET simple_geom = st_simplify(the_geom, 2.2); 


-- Gemarkungen zu Gemeinden zusammen fassen
-- ----------------------------------------

-- Flächen vereinigen
UPDATE pp_gemeinde a
  SET the_geom = 
   ( SELECT st_multi(st_union(st_buffer(b.the_geom,0.2))) AS the_geom -- noch mal Zugabe
     FROM    pp_gemarkung b
     WHERE a.land     = b.land 
       AND a.gemeinde = b.gemeinde
   );
-- Hierbei können Exceptions auftreten wobei das Geometriefeld einzelner Gemarkungen leer bleibt.
-- Die Ursache ist unklar.

-- Praktische Lösung:
-- weitere Versuche mit mehr Puffer, wenn Exception auftrat
UPDATE pp_gemeinde a
  SET the_geom = 
   ( SELECT st_multi(st_union(st_buffer(b.the_geom,0.3))) AS the_geom -- MEHR Zugabe
     FROM    pp_gemarkung b
     WHERE a.land     = b.land 
       AND a.gemeinde = b.gemeinde
   ) WHERE the_geom IS NULL;

UPDATE pp_gemeinde a
  SET the_geom = 
   ( SELECT st_multi(st_union(st_buffer(b.the_geom,0.4))) AS the_geom -- noch MEHR Zugabe
     FROM    pp_gemarkung b
     WHERE a.land     = b.land 
       AND a.gemeinde = b.gemeinde
   ) WHERE the_geom IS NULL;


-- Vereinfachte Geometrie der Gemeinde für die Darstellung im WMS in einem kleinen Maßstab
-- Gemeinde (Wirkung siehe pp_gemeinde_analyse)
UPDATE pp_gemeinde  SET simple_geom = st_simplify(the_geom, 5.0); 

-- Gemarkungen in der Gemeinde zählen
UPDATE pp_gemeinde a
  SET anz_gemarkg = 
   ( SELECT count(gemarkung) AS anz_gemarkg 
     FROM    pp_gemarkung b
     WHERE a.land     = b.land 
       AND a.gemeinde = b.gemeinde
   );


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
