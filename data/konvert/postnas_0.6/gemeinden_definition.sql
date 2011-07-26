
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


-- Teil 1: Anlegen der Tabelle

-- Stand 

--  2011-07-25 PostNAS 06, Umbenennung


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

COMMENT ON COLUMN gemeinde_gemarkung.gkz            IS 'Gemeindekennziffer für Mandant';
