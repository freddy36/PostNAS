
-- ALKIS PostNAS 0.5

-- =======================================================
-- Tabelle fuer die Zuordnung vom Gemarkungen zu Gemeinden
-- =======================================================

-- F�r die Regelung der Zugriffsberechtigung einer Gemeindeverwaltung auf die 
-- Flurst�cke in ihrem Gebiet braucht man die Information, in welcher Gemeinde eine Gemarkung liegt.
-- 'ax_gemeinde' und 'ax_gemarkung' haben aber im ALKIS keinerlei Beziehung zueinander - kaum zu glauben!
-- Nur �ber die Auswertung der Flurst�cke kann man die Zuordnung ermitteln.
-- Da nicht st�ndig mit 'SELECT DISTINCT' s�mtliche Flurst�cke durchsucht werden k�nnen, 
-- muss diese Information als (redundante) Tabelle nach dem Laden zwischengespeichert werden. 


-- Teil 2: Laden der Tabelle

-- Stand 
--  2010-11-25  


SET client_encoding = 'UTF-8';

-- Alles auf Anfang!

 DELETE FROM gemeinde_gemarkung;


-- Vorkommende Paarungen in Flurst�cke
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


-- ENDE --