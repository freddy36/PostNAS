
-- ALKIS PostNAS 0.6

-- =======================================================
-- Tabelle fuer die Zuordnung vom Gemarkungen zu Gemeinden
-- =======================================================

-- Für die Regelung der Zugriffsberechtigung einer Gemeindeverwaltung auf die 
-- Flurstücke in ihrem Gebiet braucht man die Information, in welcher Gemeinde eine Gemarkung liegt.
-- 'ax_gemeinde' und 'ax_gemarkung' haben aber im ALKIS keinerlei Beziehung zueinander - kaum zu glauben!
-- Nur über die Auswertung der Flurstücke kann man die Zuordnung ermitteln.
-- Da nicht ständig mit 'SELECT DISTINCT' sämtliche Flurstücke durchsucht werden können, 
-- muss diese Information als (redundante) Tabelle nach dem Laden zwischengespeichert werden. 


-- Teil 2: Laden der Tabellen

-- Stand 

--  2011-07-25 PostNAS 06, Umbenennung
--  2011-12-08 Person -> Gemeinde


SET client_encoding = 'UTF-8';

-- Alles auf Anfang!

 DELETE FROM gemeinde_gemarkung;


-- Vorkommende Paarungen in Flurstücke
INSERT INTO gemeinde_gemarkung
  (               land, regierungsbezirk, kreis, gemeinde, gemarkung       )
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer 
;


-- Namen der Gemeinde dazu als Optimierung bei der Auskunft 
UPDATE gemeinde_gemarkung a
   SET gemeindename =
   ( SELECT b.bezeichnung 
     FROM    ax_gemeinde b
     WHERE a.land=b.land 
       AND a.regierungsbezirk=b.regierungsbezirk 
       AND a.kreis=b.kreis
       AND a.gemeinde=b.gemeinde
   );
 
 
-- Namen der Gemarkung dazu als Optimierung bei der Auskunft 
UPDATE gemeinde_gemarkung a
   SET gemarkungsname =
   ( SELECT b.bezeichnung 
     FROM    ax_gemarkung b
     WHERE a.land=b.land 
       AND a.gemarkung=b.gemarkungsnummer
   );



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