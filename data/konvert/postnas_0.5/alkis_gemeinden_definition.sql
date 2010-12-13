
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


-- Teil 1: Anlegen der Tabelle

-- Stand 
--  2010-11-25  


SET client_encoding = 'UTF-8';

-- Alles auf Anfang!

DROP TABLE gemeinde_gemarkung;

CREATE TABLE gemeinde_gemarkung (
  land 			integer,
  regierungsbezirk	integer,
  kreis			integer,
  gemeinde		integer,
  gemarkung		integer NOT NULL,
  gemeindename		character varying(80), 
  gemarkungsname	character varying(80), 
  gkz			character varying(3),  
  CONSTRAINT gemeinde_gemarkung_pk PRIMARY KEY (land, gemarkung)
);


COMMENT ON TABLE  gemeinde_gemarkung                IS 'Beziehung: Gemarkung liegt in Gemeinde';
COMMENT ON COLUMN gemeinde_gemarkung.gemeinde       IS 'Gemeindenummer';
COMMENT ON COLUMN gemeinde_gemarkung.gemarkung      IS 'Gemarkungsnummer';

COMMENT ON COLUMN gemeinde_gemarkung.gkz            IS 'Gemeindekennziffer f�r Mandant';
